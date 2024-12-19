
class slave_monitor extends uvm_monitor;

	`uvm_component_utils(slave_monitor)

	virtual slave_interface.MON_MP vif; 
    
	slave_agent_config m_cfg;

  // Analysis TLM port to connect the monitor to the scoreboard 
  uvm_analysis_port #(slave_xtn) monitor_port;

//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
	extern function new(string name = "slave_monitor", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect_data();
	
endclass :slave_monitor


//---------------------- new() method ---------------------//
 function slave_monitor::new (string name = "slave_monitor", uvm_component parent);
    super.new(name, parent);
// create object for handle monitor_port using new
    monitor_port = new("monitor_port", this);
  endfunction : new


//------------------- build() phase method ---------------//
function void slave_monitor::build_phase(uvm_phase phase);
	super.build_phase(phase);  
	if(!uvm_config_db #(slave_agent_config)::get(this,"","slave_agent_config",m_cfg))
	`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
endfunction:build_phase


//----------------- connect() phase method -------------//
function void slave_monitor::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	vif=m_cfg.vif;
	$display("SLAVE MONITOR INTERFACE %p",vif);
endfunction


//------------------- run() phase method ---------------//
task slave_monitor::run_phase(uvm_phase phase);
	forever
		collect_data();
endtask



//----------------- collect_data() method --------------//
task slave_monitor::collect_data();
	slave_xtn rcvd_xtn;
	
	rcvd_xtn=slave_xtn::type_id::create("rcvd_xtn");
	
	
	wait(vif.mon_cb.PENABLE==1)
	
		rcvd_xtn.PADDR=vif.mon_cb.PADDR;
		rcvd_xtn.PWRITE=vif.mon_cb.PWRITE;
		rcvd_xtn.PENABLE=vif.mon_cb.PENABLE;
		rcvd_xtn.PSELx=vif.mon_cb.PSELx;
		if(rcvd_xtn.PWRITE)
			rcvd_xtn.PWDATA=vif.mon_cb.PWDATA;
		else
			rcvd_xtn.PRDATA=vif.mon_cb.PRDATA;
	
	@(vif.mon_cb);
	
	 monitor_port.write(rcvd_xtn);
	
	$display("****************************** PRINTING FROM APB MONITOR*********************************");
	rcvd_xtn.print();
	
	m_cfg.mon_rcvd_xtn_cnt++;
	 `uvm_info(get_type_name(), $sformatf("Report: Slave monitor recived %0d transactions", m_cfg.mon_rcvd_xtn_cnt), UVM_LOW)
	 
endtask
		