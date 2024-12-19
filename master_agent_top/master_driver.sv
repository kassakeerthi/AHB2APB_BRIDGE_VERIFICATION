class master_driver extends uvm_driver #(master_xtn);

	`uvm_component_utils(master_driver)
	
	virtual master_interface.DRV_MP vif;

    master_agent_config m_cfg;

	extern function new(string name ="master_driver",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task send_to_dut(master_xtn xtn);
//	extern function void report_phase(uvm_phase phase);
	
endclass:master_driver


//-----------------  constructor new method  -------------------//
function master_driver::new(string name ="master_driver",uvm_component parent);
	super.new(name,parent);
endfunction


//-----------------  build() phase method  -------------------//
function void master_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(master_agent_config)::get(this,"","master_agent_config",m_cfg))
	`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?") 
endfunction:build_phase


//---------------- connect() phase method -------------------//
function void master_driver::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	vif=m_cfg.vif;
	$display("i am in master driver connect phase %p",m_cfg.vif);
endfunction 


//------------------- run() phase method ---------------------//
task master_driver::run_phase(uvm_phase phase);
	
	@(vif.drv_cb)
		vif.drv_cb.HRESETn<=1'b0;
	@(vif.drv_cb)
		vif.drv_cb.HRESETn<=1'b1;
	
	forever
		begin
			seq_item_port.get_next_item(req);
			send_to_dut(req);
			seq_item_port.item_done(req);

		end
endtask

task master_driver::send_to_dut(master_xtn xtn);
	
	wait(vif.drv_cb.HREADYout == 1)
		vif.drv_cb.HADDR <= xtn.HADDR;
		vif.drv_cb.HSIZE <= xtn.HSIZE;
		vif.drv_cb.HWRITE <= xtn.HWRITE;
		vif.drv_cb.HTRANs <= xtn.HTRANS;
		vif.drv_cb.HREADYin <= 1'b1;
	
	@(vif.drv_cb);
		wait(vif.drv_cb.HREADYout == 1)
			if(xtn.HWRITE)
			//vif.drv_cb.HWDATA <= 32'b0;
				vif.drv_cb.HWDATA <= xtn.HWDATA;
			else
				vif.drv_cb.HWDATA <= 32'b0;
			//vif.drv_cb.HWDATA <= xtn.HWDATA;
	$display("*****************************PRINTING FROM AHB DRIVER********************************");
	xtn.print();
	
	repeat(2)
	 @(vif.drv_cb);
	
	m_cfg.drv_data_sent_cnt ++ ;
	 `uvm_info(get_type_name(), $sformatf("Report: Master driver sent %0d transactions", m_cfg.drv_data_sent_cnt), UVM_LOW)
endtask
	
