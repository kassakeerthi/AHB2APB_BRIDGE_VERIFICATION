class bridge_tb extends uvm_env;
	
	//Factory Registration
	`uvm_component_utils(bridge_tb)
	
	//Declare handles for agents
	master_agent_top m_agt_top;
	slave_agent_top  s_agt_top;
	
	//Declare handles for Virtual sequencer
	bridge_virtual_sequencer v_sequencer;
	
	//Declare handles for scoreboard
	bridge_scoreboard sb;
	
	//Declare handles for Environment Config_db
	bridge_env_config m_cfg;
	
	
	//----------------------------------
	// STANDARD METHODS
	//----------------------------------
	extern function new(string name="bridge_tb",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	
endclass


//----------------------------- NEW() METHOD ----------------------------//
function  bridge_tb::new(string name="bridge_tb",uvm_component parent);
	super.new(name,parent);
endfunction



//-------------------------- BUILD_PHASE() METHOD -----------------------//
function void bridge_tb ::build_phase(uvm_phase phase);
	if(!uvm_config_db #(bridge_env_config)::get(this,"","bridge_env_config",m_cfg))
		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db.Have you set() it?")
		
		if(m_cfg.has_master_agent)
			begin
				m_agt_top=master_agent_top::type_id::create("m_agt_top", this);
			end
			
		if(m_cfg.has_slave_agent)
			begin
				s_agt_top=slave_agent_top::type_id::create("s_agt_top", this);
			end
			
		super.build_phase(phase);
		
		if(m_cfg.has_virtual_sequencer)
			v_sequencer=bridge_virtual_sequencer::type_id::create("v_sequencer", this);
		
		if(m_cfg.has_scoreboard)
			sb=bridge_scoreboard::type_id::create("sb", this);
		
		`uvm_info(get_type_name(),"This is the BUILD_PHASE of bridge_tb",UVM_LOW)
endfunction


//--------------------------- CONNECT() METHOD --------------------------//
function void bridge_tb::connect_phase(uvm_phase phase);
	
	super.connect_phase(phase);
	
	if(m_cfg.has_virtual_sequencer)
		begin
			if(m_cfg.has_master_agent)
				begin
					for(int i=0; i<m_cfg.no_of_master_agents; i++)
						v_sequencer.m_seqrh[i]=m_agt_top.agent_h[i].seqrh;
				end
				
			if(m_cfg.has_slave_agent)
				begin 
					for(int i=0; i<m_cfg.no_of_slave_agents; i++)
						v_sequencer.s_seqrh[i]=s_agt_top.agent_h[i].seqrh;
				end
				
		end
		
	if(m_cfg.has_scoreboard)
		begin 	
			for(int i=0; i<m_cfg.no_of_master_agents; i++)
				m_agt_top.agent_h[i].mon_h.monitor_port.connect(sb.fifo_master[i].analysis_export);
				
			for(int i=0; i<m_cfg.no_of_slave_agents; i++)
				s_agt_top.agent_h[i].mon_h.monitor_port.connect(sb.fifo_slave[i].analysis_export);
		end 
endfunction
		
			
					
