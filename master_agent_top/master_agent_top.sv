class master_agent_top extends uvm_env;

	`uvm_component_utils(master_agent_top)
	
	master_agent agent_h[];
	bridge_env_config m_cfg;
	master_agent_config m_master_agent_cfg;
	
	extern function new(string name="master_agent_top",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);

endclass


//-------------------------------- NEW() METHOD --------------------------------//
function master_agent_top::new(string name="master_agent_top",uvm_component parent);
	super.new(name,parent);
endfunction



//-------------------------------- BUILD_PHASE() METHOD -------------------------//
function void master_agent_top::build_phase(uvm_phase phase);
	
	super.build_phase(phase);
	
	if(!uvm_config_db #(bridge_env_config) :: get(this," ","bridge_env_config",m_cfg))
		`uvm_fatal("CONFIG","cannot get m_cfg from uvm_config_db. Have you set it?")
		
		agent_h=new[m_cfg.no_of_master_agents];
		
		foreach(agent_h[i])
			begin
				uvm_config_db #(master_agent_config) :: set (this , $sformatf("agent_h[%0d]*",i) , "master_agent_config" , m_cfg.m_master_agent_cfg[i]);
				agent_h[i]=master_agent::type_id::create($sformatf("agent_h[%0d]*",i),this);
			end
endfunction

task master_agent_top::run_phase(uvm_phase phase);
	uvm_top.print_topology;
endtask


	

