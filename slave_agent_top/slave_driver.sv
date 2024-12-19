
class slave_driver extends uvm_driver #(slave_xtn);

	`uvm_component_utils(slave_driver)

   virtual slave_interface.DRV_MP vif;
   
   // Declare the ram_wr_agent_config handle as "m_cfg"
    slave_agent_config m_cfg;
	
	slave_xtn xtn;
	
	extern function new(string name ="slave_driver",uvm_component parent);
	extern function void build_phase(uvm_phase phase);	
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task send_to_dut();
endclass:slave_driver


//-------------------new() method ----------------------//
function slave_driver::new (string name ="slave_driver", uvm_component parent);
	super.new(name, parent);
endfunction : new


//--------------- build() phase method -----------------//
function void slave_driver::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(slave_agent_config)::get(this,"","slave_agent_config",m_cfg)) 
		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?") 
 endfunction:build_phase


//----------------- connect() phase method -------------//
function void slave_driver::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	vif=m_cfg.vif;
	$display("SLAVE DRIVER INTERFACE %p",vif);
endfunction:connect_phase


//----------------- run() phase method -------------//
task slave_driver::run_phase(uvm_phase phase);
	xtn=slave_xtn::type_id::create("xtn");
	forever
		begin
			seq_item_port.get_next_item(req);
			send_to_dut();
			seq_item_port.item_done(req);

		end
endtask


//----------------- send_to_dut() method -------------//
task slave_driver::send_to_dut();

	
	wait(vif.drv_cb.PSELx!==0) 	//Check whether PSELx state is	idle or not?
		if(vif.drv_cb.PWRITE==0)
			begin
				wait(vif.drv_cb.PENABLE==1)
				vif.drv_cb.PRDATA<={$random};
			end
	@(vif.drv_cb);
	
	$display("************************PRINTING FROM APB DRIVER************************");
	xtn.print();
	
	m_cfg.drv_data_sent_cnt ++ ;
	 `uvm_info(get_type_name(), $sformatf("Report: Slave driver sent %0d transactions", m_cfg.drv_data_sent_cnt), UVM_LOW)
endtask