class slave_sequence extends uvm_sequence #(slave_xtn);  
	
	`uvm_object_utils(slave_sequence)  

        extern function new(string name ="slave_sequence");
		extern task body();
endclass


function slave_sequence::new(string name ="slave_sequence");
	super.new(name);
endfunction:new

 task slave_sequence::body();
 
	req=slave_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize());
	finish_item(req);
	
endtask