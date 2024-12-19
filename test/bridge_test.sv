class bridge_test extends uvm_test;
	
	`uvm_component_utils(bridge_test)
	
	bridge_tb envh;
	
	bridge_env_config m_tb_cfg;
	
	master_agent_config m_master_cfg[];
	slave_agent_config  s_slave_cfg[];
	
	int has_slave_agent = 1;
	int has_master_agent = 1;
	
	int no_of_master_agents = 1;
	int no_of_slave_agents = 1;
	
	extern function new(string name="bridge_test", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
endclass


//--------------------------------- NEW() METHOD ---------------------------------//
function bridge_test :: new(string name="bridge_test",uvm_component parent);
	super.new(name,parent);
endfunction


//------------------------------ BUILD_PHASE() METHOD-----------------------------//
function void bridge_test::build_phase(uvm_phase phase);
	
	m_tb_cfg=bridge_env_config::type_id::create("m_tb_cfg");
		
		if(has_master_agent)
			begin
				m_master_cfg=new[no_of_master_agents];
				m_tb_cfg.m_master_agent_cfg=new[no_of_master_agents];
				foreach(m_master_cfg[i])
					begin
						m_master_cfg[i]=master_agent_config::type_id::create($sformatf("m_master_cfg[%0d]",i),this);
						m_master_cfg[i].is_active=UVM_ACTIVE;					
						if(!uvm_config_db #(virtual master_interface)::get(this," ",$sformatf("master_vif_%0d",i), m_master_cfg[i].vif))
							`uvm_fatal("VIF CONFIG","cannot get()interface vif from uvm_config_db.Have you set() it?")
						$display("I am in test the ahb_interface %p",m_master_cfg[i].vif);
					//	m_master_cfg[i].is_active=UVM_ACTIVE;
						m_tb_cfg.m_master_agent_cfg[i]=m_master_cfg[i];
					end
			end
			
		if(has_slave_agent)
			begin 
				m_tb_cfg.m_slave_agent_cfg=new[no_of_slave_agents];
				s_slave_cfg=new[no_of_slave_agents];
				
					foreach(s_slave_cfg[i])
						begin 
							s_slave_cfg[i]=slave_agent_config::type_id::create($sformatf("s_slave_cfg[%0d]",i));
							if(!uvm_config_db #(virtual slave_interface)::get(this," ",$sformatf("slave_vif%0d",i),s_slave_cfg[i].vif))
								`uvm_fatal("VIF CONFIG","cannot get()interface vif from uvm_config_db.Have you set() it?")
								$display("I am in test the apb_interface %p",s_slave_cfg[i].vif);
							s_slave_cfg[i].is_active=UVM_ACTIVE;
							m_tb_cfg.m_slave_agent_cfg[i]=s_slave_cfg[i];
						end
			end
			
		m_tb_cfg.has_master_agent=has_master_agent;
		m_tb_cfg.has_slave_agent=has_slave_agent;
		
		m_tb_cfg.no_of_master_agents=no_of_master_agents;
		m_tb_cfg.no_of_slave_agents=no_of_slave_agents;
		
		uvm_config_db #(bridge_env_config)::set(this,"*","bridge_env_config",m_tb_cfg);
		
		super.build_phase(phase);
		
		envh=bridge_tb::type_id::create("envh",this);
endfunction



//----------------------------------------------------------------------------------------

//						SINGLE TRANSACTION

//----------------------------------------------------------------------------------------
class single_xtn_test extends bridge_test;
	`uvm_component_utils(single_xtn_test)
	
	master_single_vseq single_seqh;
	
	extern function new(string name="single_xtn_test",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);

endclass:single_xtn_test


//------------------------ NEW() METHOD -----------------------------//
function single_xtn_test::new(string name="single_xtn_test",uvm_component parent);
	super.new(name,parent);
endfunction:new


//---------------------- build() phase method -----------------------//
function void single_xtn_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction


//--------------------- ruun() phase method -------------------------//
task single_xtn_test::run_phase(uvm_phase phase);
	
	single_seqh=master_single_vseq::type_id::create("single_seqh");
	phase.raise_objection(this);
	single_seqh.start(envh.v_sequencer);
	#100;
	phase.drop_objection(this);

endtask



//----------------------------------------------------------------------------------------

//						INCR TRANSACTION

//----------------------------------------------------------------------------------------
class incr_xtn_test extends bridge_test;
	
	`uvm_component_utils(incr_xtn_test)
	
	master_incr_vseq incr_seqh;
	
	extern function new(string name="incr_xtn_test",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);

endclass:incr_xtn_test


//------------------------ NEW() METHOD -----------------------------//
function incr_xtn_test::new(string name="incr_xtn_test",uvm_component parent);
	super.new(name,parent);
endfunction:new


//---------------------- build() phase method -----------------------//
function void incr_xtn_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction


//--------------------- ruun() phase method -------------------------//
task incr_xtn_test::run_phase(uvm_phase phase);
	
	incr_seqh=master_incr_vseq::type_id::create("incr_seqh");
	phase.raise_objection(this);
	incr_seqh.start(envh.v_sequencer);
	#100;
	phase.drop_objection(this);

endtask



//----------------------------------------------------------------------------------------

//						WRAP TRANSACTION

//----------------------------------------------------------------------------------------
class wrap_xtn_test extends bridge_test;
	`uvm_component_utils(wrap_xtn_test)
	
	master_wrap_vseq wrap_seqh;
	
	extern function new(string name="wrap_xtn_test",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);

endclass:wrap_xtn_test


//------------------------ NEW() METHOD -----------------------------//
function wrap_xtn_test::new(string name="wrap_xtn_test",uvm_component parent);
	super.new(name,parent);
endfunction:new


//---------------------- build() phase method -----------------------//
function void wrap_xtn_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction


//--------------------- ruun() phase method -------------------------//
task wrap_xtn_test::run_phase(uvm_phase phase);
	
	wrap_seqh=master_wrap_vseq::type_id::create("wrap_seqh");
	phase.raise_objection(this);
	wrap_seqh.start(envh.v_sequencer);
	#100;
	phase.drop_objection(this);

endtask



//----------------------------------------------------------------------------------------

//						INCR 1 TRANSACTION

//----------------------------------------------------------------------------------------
class incr_xtn_test1 extends bridge_test;
	
	`uvm_component_utils(incr_xtn_test1)
	
	master_incr1_vseq incr_seqh;
	
	extern function new(string name="incr_xtn_test1",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);

endclass:incr_xtn_test1


//------------------------ NEW() METHOD -----------------------------//
function incr_xtn_test1::new(string name="incr_xtn_test1",uvm_component parent);
	super.new(name,parent);
endfunction:new


//---------------------- build() phase method -----------------------//
function void incr_xtn_test1::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction


//--------------------- ruun() phase method -------------------------//
task incr_xtn_test1::run_phase(uvm_phase phase);
	
	incr_seqh=master_incr1_vseq::type_id::create("incr_seqh");
	phase.raise_objection(this);
	incr_seqh.start(envh.v_sequencer);
	#100;
	phase.drop_objection(this);

endtask



//----------------------------------------------------------------------------------------

//						INCR 2 TRANSACTION

//----------------------------------------------------------------------------------------
class incr_xtn_test2 extends bridge_test;
	
	`uvm_component_utils(incr_xtn_test2)
	
	master_incr2_vseq incr_seqh;
	
	extern function new(string name="incr_xtn_test2",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);

endclass:incr_xtn_test2


//------------------------ NEW() METHOD -----------------------------//
function incr_xtn_test2::new(string name="incr_xtn_test2",uvm_component parent);
	super.new(name,parent);
endfunction:new


//---------------------- build() phase method -----------------------//
function void incr_xtn_test2::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction


//--------------------- ruun() phase method -------------------------//
task incr_xtn_test2::run_phase(uvm_phase phase);
	
	incr_seqh=master_incr2_vseq::type_id::create("incr_seqh");
	phase.raise_objection(this);
	incr_seqh.start(envh.v_sequencer);
	#100;
	phase.drop_objection(this);

endtask


