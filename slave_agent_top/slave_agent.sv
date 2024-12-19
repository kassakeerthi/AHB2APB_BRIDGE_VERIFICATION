
class slave_agent extends uvm_agent;
	
	`uvm_component_utils(slave_agent)

   // Declare handle for configuration object
	slave_agent_config m_cfg;
       
   // Declare handles of slave_monitor,slave_sequencer and slave_driver
	slave_monitor mon_h;
	slave_sequencer seqrh;
	slave_driver drvh;

  extern function new(string name = "slave_agent", uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

endclass : slave_agent

function slave_agent::new(string name = "slave_agent",uvm_component parent = null);
	super.new(name, parent);
endfunction
     
function void slave_agent::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(slave_agent_config) :: get(this, " ", "slave_agent_config", m_cfg ) )
	`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
	  mon_h= slave_monitor :: type_id :: create("mon_h",this);
	if(m_cfg.is_active== UVM_ACTIVE) 
        begin
			drvh= slave_driver :: type_id :: create("drvh",this);
			seqrh= slave_sequencer :: type_id :: create("seqrh",this);
		end        
endfunction

      
function void slave_agent::connect_phase(uvm_phase phase);
	if(m_cfg.is_active==UVM_ACTIVE)
	drvh.seq_item_port.connect(seqrh.seq_item_export);
endfunction
   

   


