class bridge_virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);
	
	`uvm_component_utils(bridge_virtual_sequencer)
	
	master_sequencer m_seqrh[];
	slave_sequencer  s_seqrh[];
	
	bridge_env_config m_cfg;
	
	extern function new(string name="bridge_virtual_sequencer",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	
endclass


//------------------------------ NEW() Method --------------------------------------//
function bridge_virtual_sequencer::new(string name="bridge_virtual_sequencer",uvm_component parent);
	super.new(name,parent);
endfunction


//--------------------------- BUILD_PHASE() Method ---------------------------------//
function void bridge_virtual_sequencer::build_phase(uvm_phase phase);
	if(!uvm_config_db #(bridge_env_config) :: get(null,get_full_name(),"bridge_env_config",m_cfg))
		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
	
	if(m_cfg.has_virtual_sequencer)
		begin
			if(m_cfg.has_master_agent)
				m_seqrh=new[m_cfg.no_of_master_agents];
			if(m_cfg.has_slave_agent)
				s_seqrh=new[m_cfg.no_of_slave_agents];
		end
endfunction