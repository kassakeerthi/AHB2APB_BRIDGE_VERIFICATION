class bridge_env_config extends uvm_object;
	
	//Factory registeration
	`uvm_object_utils(bridge_env_config)
	
	bit has_scoreboard =1;
	
	bit has_master_agent=1;
	bit has_slave_agent=1;
	
	bit has_virtual_sequencer=1;
	
	master_agent_config m_master_agent_cfg[];
	slave_agent_config  m_slave_agent_cfg[];
	
	int no_of_duts;
	int no_of_master_agents=1;
	int no_of_slave_agents=1;
	//-----------------------------
	// STANDARD METHODS
	//-----------------------------
	extern function new(string name="bridge_env_config");
endclass


//-------------------------------- NEW() METHOD ---------------------------------//
function bridge_env_config::new(string name="bridge_env_config");
	super.new(name);
endfunction