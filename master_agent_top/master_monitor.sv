//Router Source Monitor
class master_monitor extends uvm_monitor;

	`uvm_component_utils(master_monitor)

	virtual master_interface.MON_MP vif;
	
	master_agent_config m_cfg;

	uvm_analysis_port #(master_xtn) monitor_port;

	extern function new(string name = "master_monitor", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect_data ();
//  extern function void report_phase(uvm_phase phase);

endclass 


//-----------------  constructor new method  -------------------//
function master_monitor::new(string name = "master_monitor", uvm_component parent);
	super.new(name,parent);
	// create object for handle monitor_port using new
	monitor_port = new("monitor_port", this);
endfunction


//-----------------  build() phase method  -------------------//
function void master_monitor::build_phase(uvm_phase phase);
    super.build_phase(phase);
	// get the config object using uvm_config_db 
	if(!uvm_config_db #(master_agent_config)::get(this,"","master_agent_config",m_cfg))
	`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?") 
endfunction:build_phase


//----------------- connect() phase method() ----------------//
function void master_monitor::connect_phase(uvm_phase phase);	
	super.connect_phase(phase);
	vif=m_cfg.vif;
	$display("MASTER MONITOR INTERFACE %p",vif);
endfunction:connect_phase


//--------------- run() phase method -----------------------//
task master_monitor::run_phase(uvm_phase phase);
	
	forever
		begin
			collect_data();
		end
endtask


//------------- collect_data() method ---------------------//
task master_monitor::collect_data();
	master_xtn data_sent;
	begin
		data_sent=master_xtn::type_id::create("data_sent");
		
		wait(vif.mon_cb.HREADYout == 1)
		//wait(vif.mon_cb.HRESETn == 1)
		begin
			data_sent.HADDR=vif.mon_cb.HADDR;
			data_sent.HSIZE=vif.mon_cb.HSIZE;
			data_sent.HWRITE=vif.mon_cb.HWRITE;
			data_sent.HTRANS=vif.mon_cb.HTRANs;
			data_sent.HREADYin=vif.mon_cb.HREADYin;
		end
		
		@(vif.mon_cb);
		wait(vif.mon_cb.HREADYout == 1)
			if(data_sent.HWRITE)
				data_sent.HWDATA=vif.mon_cb.HWDATA;
			else
				data_sent.HRDATA=vif.mon_cb.HRDATA;
	end
	
	 monitor_port.write(data_sent);
	 
	$display("*******************************PRINTING FROM AHB MONITOR*******************************");
	data_sent.print();
	
	m_cfg.mon_rcvd_xtn_cnt++;
	 `uvm_info(get_type_name(), $sformatf("Report: Master monitor recived %0d transactions", m_cfg.mon_rcvd_xtn_cnt), UVM_LOW)
	 
endtask
		
			
			

