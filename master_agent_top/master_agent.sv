class master_agent extends uvm_agent;

	`uvm_component_utils(master_agent)
	
	master_monitor mon_h;
	master_sequencer seqrh;
	master_driver drvh;
	master_agent_config m_cfg;
	

  extern function new(string name = "master_agent", uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

endclass : master_agent


//-----------------  constructor new method  -------------------//
function master_agent::new(string name = "master_agent",uvm_component parent = null);
    super.new(name, parent);
endfunction:new
     
	 
//-----------------  build() phase method  -------------------//
function void master_agent::build_phase(uvm_phase phase);
	super.build_phase(phase);
          if(! uvm_config_db #(master_agent_config) :: get(this," ","master_agent_config",m_cfg))
             `uvm_fatal("CONFIG","cannot get() w_cfg from uvm_config_db. Have you set() it?")

		 mon_h= master_monitor :: type_id :: create("monh",this);
  
		if(m_cfg.is_active== UVM_ACTIVE)
        drvh= master_driver :: type_id :: create("drvh",this);
		seqrh= master_sequencer :: type_id :: create("seqrh",this);
endfunction:build_phase


//-----------------  connect() phase method  -------------------//
function void master_agent::connect_phase(uvm_phase phase);
	if(m_cfg.is_active==UVM_ACTIVE)
	begin
	drvh.seq_item_port.connect(seqrh.seq_item_export);
 	end
endfunction:connect_phase
   

   
	