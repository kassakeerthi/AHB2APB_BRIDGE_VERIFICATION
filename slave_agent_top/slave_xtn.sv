class slave_xtn extends uvm_sequence_item;

	`uvm_object_utils(slave_xtn)
	
		 bit [31:0] PADDR;
		 bit [31:0] PWDATA;
	rand bit [31:0] PRDATA;
		 bit 		PENABLE;
		 bit 		PWRITE;
		 bit [3:0]  PSELx;
		 
	extern function new(string name="slave_xtn");
	extern function void do_print(uvm_printer printer);
	
endclass

function slave_xtn::new(string name ="slave_xtn");
	super.new(name);
endfunction

function void slave_xtn::do_print(uvm_printer printer);
	
	super.do_print(printer);
	
	//					string name 		bitstream value		size	radix for printing
	printer.print_field("PENABLE",			this.PENABLE,	 	1,		 UVM_DEC);
	printer.print_field("PWRITE",			this.PWRITE,	 	1,		 UVM_DEC);
	printer.print_field("PSELx",			this.PSELx,	 	    4,		 UVM_DEC);
	printer.print_field("PADDR",			this.PADDR,	  		32,		 UVM_HEX);
	printer.print_field("PWDATA",			this.PWDATA,	 	32,		 UVM_HEX);
	printer.print_field("PRDATA",			this.PRDATA,	 	32,		 UVM_HEX);
endfunction