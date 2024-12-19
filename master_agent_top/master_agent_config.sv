
class master_agent_config extends uvm_object;

`uvm_object_utils(master_agent_config)

virtual master_interface vif;

uvm_active_passive_enum is_active = UVM_ACTIVE;

// Declare the mon_rcvd_xtn_cnt as static int and initialize it to zero  
static int mon_rcvd_xtn_cnt = 0;

// Declare the drv_data_sent_cnt as static int and initialize it to zero 
static int drv_data_sent_cnt = 0;


extern function new(string name = "master_agent_config");

endclass: master_agent_config


//-----------------  constructor new method  -------------------//
function master_agent_config::new(string name = "master_agent_config");
  super.new(name);
endfunction

 

