class slave_sequencer extends uvm_sequencer #(slave_xtn);

	`uvm_component_utils(slave_sequencer)
	extern function new(string name = "slave_sequencer",uvm_component parent);
endclass:slave_sequencer

function slave_sequencer::new(string name="slave_sequencer",uvm_component parent);
	super.new(name,parent);
endfunction:new