class bridge_virtual_seqs extends uvm_sequence #(uvm_sequence_item);

	`uvm_object_utils(bridge_virtual_seqs)
	
	master_sequencer m_seqrh[];
	slave_sequencer  s_seqrh[];
	
	bridge_virtual_sequencer v_seqrh;
	
	bridge_env_config m_cfg;
	
	//----------------------------------------
	// STANDARD UVM METHODS
	//----------------------------------------
	extern function new (string name="bridge_virtual_seqs");
	extern task body();
endclass


//---------------------------- NEW() METHOD --------------------------//
function bridge_virtual_seqs::new(string name="bridge_virtual_seqs");
	super.new(name);
endfunction


//------------------------ TASK_BODY() METHOD --------------------------//
task bridge_virtual_seqs::body();
	if(!uvm_config_db #(bridge_env_config) :: get(null,get_full_name(),"bridge_env_config",m_cfg))
		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
		
	m_seqrh=new[m_cfg.no_of_master_agents];
	s_seqrh=new[m_cfg.no_of_slave_agents];
	
	assert($cast(v_seqrh,m_sequencer))
		else
			begin 
				`uvm_error("BODY","EROOR IN $CAST OF BRIDGE_VIRTUAL_SEQUENCER")
			end
			
		foreach(m_seqrh[i])
			m_seqrh[i]=v_seqrh.m_seqrh[i];
					
		foreach(s_seqrh[i])
			s_seqrh[i]=v_seqrh.s_seqrh[i];
			
endtask	



//-------------------------------------------------------------------------------------

// 							SINGLE_TRANSFER V_SEQUENCE

//-------------------------------------------------------------------------------------
class master_single_vseq extends bridge_virtual_seqs;
	
	`uvm_object_utils(master_single_vseq)
	
	master_single_xtns m_single_xtns;
	
	slave_sequence s_seqh;
	
	extern function new(string name="master_single_vseq");
	extern task body();
	
endclass:master_single_vseq


//------------------------- new() method -------------------------------//
function master_single_vseq::new(string name="master_single_vseq");
	super.new(name);
endfunction


//------------------------- body() method -----------------------------//
task master_single_vseq::body();
	
	super.body();
	
	if(m_cfg.has_master_agent)
		begin
			m_single_xtns=master_single_xtns::type_id::create("m_single_xtns");
		//	m_single_xtns.start(m_seqrh[0]);
	end
	
	if(m_cfg.has_slave_agent)
		begin
			s_seqh=slave_sequence::type_id::create("s_seqh");
	//		s_seqh.start(s_seqrh[0]);
	end	
	
	fork
		begin
			m_single_xtns.start(m_seqrh[0]);
		end
		
		begin
			s_seqh.start(s_seqrh[0]);
		end
	join
endtask



//-------------------------------------------------------------------------------------

// 							INCR_TRANSFER V_SEQUENCE

//-------------------------------------------------------------------------------------
class master_incr_vseq extends bridge_virtual_seqs;
	
	`uvm_object_utils(master_incr_vseq)
	
	master_incr_xtns m_incr_xtns;
	
	extern function new(string name="master_incr_vseq");
	extern task body();
	
endclass:master_incr_vseq


//------------------------- new() method -------------------------------//
function master_incr_vseq::new(string name="master_incr_vseq");
	super.new(name);
endfunction


//------------------------- body() method -----------------------------//
task master_incr_vseq::body();
	
	super.body();
	
	if(m_cfg.has_master_agent)
		begin
			m_incr_xtns=master_incr_xtns::type_id::create("m_incr_xtns");
			m_incr_xtns.start(m_seqrh[0]);
	end
	
endtask



//-------------------------------------------------------------------------------------

// 							WRAP_TRANSFER V_SEQUENCE

//-------------------------------------------------------------------------------------
class master_wrap_vseq extends bridge_virtual_seqs;
	
	`uvm_object_utils(master_wrap_vseq)
	
	master_wrap_xtns m_wrap_xtns;
	
	extern function new(string name="master_wrap_vseq");
	extern task body();
	
endclass:master_wrap_vseq


//------------------------- new() method -------------------------------//
function master_wrap_vseq::new(string name="master_wrap_vseq");
	super.new(name);
endfunction


//------------------------- body() method -----------------------------//
task master_wrap_vseq::body();
	
	super.body();
	
	if(m_cfg.has_master_agent)
		begin
			m_wrap_xtns=master_wrap_xtns::type_id::create("m_wrap_xtns");
			m_wrap_xtns.start(m_seqrh[0]);
	end
	
endtask



//-------------------------------------------------------------------------------------

// 							INCR_TRANSFER 1 V_SEQUENCE

//-------------------------------------------------------------------------------------
class master_incr1_vseq extends bridge_virtual_seqs;
	
	`uvm_object_utils(master_incr1_vseq)
	
	master_incr_1 m_incr_xtns;
	
	extern function new(string name="master_incr1_vseq");
	extern task body();
	
endclass:master_incr1_vseq


//------------------------- new() method -------------------------------//
function master_incr1_vseq::new(string name="master_incr1_vseq");
	super.new(name);
endfunction


//------------------------- body() method -----------------------------//
task master_incr1_vseq::body();
	
	super.body();
	
	if(m_cfg.has_master_agent)
		begin
			m_incr_xtns=master_incr_1::type_id::create("m_incr_xtns");
			m_incr_xtns.start(m_seqrh[0]);
	end
	
endtask




//-------------------------------------------------------------------------------------

// 							INCR_TRANSFER V_SEQUENCE

//-------------------------------------------------------------------------------------
class master_incr2_vseq extends bridge_virtual_seqs;
	
	`uvm_object_utils(master_incr2_vseq)
	
	master_incr_2 m_incr_xtns;
	
	extern function new(string name="master_incr2_vseq");
	extern task body();
	
endclass:master_incr2_vseq


//------------------------- new() method -------------------------------//
function master_incr2_vseq::new(string name="master_incr2_vseq");
	super.new(name);
endfunction


//------------------------- body() method -----------------------------//
task master_incr2_vseq::body();
	
	super.body();
	
	if(m_cfg.has_master_agent)
		begin
			m_incr_xtns=master_incr_2::type_id::create("m_incr_xtns");
			m_incr_xtns.start(m_seqrh[0]);
	end
	
endtask
