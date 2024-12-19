//Router Slave Agent top
class slave_agent_top extends uvm_env;

	`uvm_component_utils(slave_agent_top)
    
   // Create the agent handle
      slave_agent agent_h[]; 
      bridge_env_config m_cfg;
	  slave_agent_config slave_cfg;

	extern function new(string name = "slave_agent_top", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
  endclass

function slave_agent_top::new(string name = "slave_agent_top" , uvm_component parent);
	super.new(name,parent);
endfunction

    
function void slave_agent_top::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(bridge_env_config)::get(this," ","bridge_env_config",m_cfg))
	`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
	agent_h=new[m_cfg.no_of_slave_agents];
	
	foreach(m_cfg.m_slave_agent_cfg[i])
	begin
		agent_h[i]= slave_agent::type_id::create($sformatf("agent_h[%0d]",i),this);
		uvm_config_db #(slave_agent_config) :: set(this, $sformatf("agent_h[%0d]*",i),"slave_agent_config",m_cfg.m_slave_agent_cfg[i]);
	end
endfunction


task slave_agent_top::run_phase(uvm_phase phase);
	uvm_top.print_topology;
endtask   


