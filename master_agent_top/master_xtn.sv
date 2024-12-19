class master_xtn extends uvm_sequence_item;
	
	`uvm_object_utils(master_xtn)
	
	rand bit [31:0] HADDR;
	rand bit [31:0] HWDATA;
		 bit [31:0] HRDATA;
	rand bit 	    HRESETn;
	rand bit        HWRITE;
	rand bit 		HREADYin;
	rand bit 		HREADYout;
	rand bit [1:0]  HTRANS;
	rand bit [2:0]  HSIZE;
 	rand bit [2:0]  HBURST;
	rand bit [9:0]  HLENGTH;
	
	constraint valid_size{HSIZE inside{0,1,2};}
	
	constraint valid_HADDR{HADDR inside{[32'h 8000_0000 :32'h 8000_03ff],
										[32'h 8400_0000 :32'h 8400_03ff],
										[32'h 8800_0000 :32'h 8800_03ff],
										[32'h 8c00_0000 :32'h 8c00_03ff]};}
										
	constraint aligned_addr{HSIZE == 1 -> HADDR%2==0;
							HSIZE == 2 -> HADDR%4==0;}
							
	constraint valid_length{HBURST == 1 -> HADDR%1024+(HLENGTH*(2**HSIZE))<=1023;
							HBURST == 2 -> HLENGTH == 4;
							HBURST == 3 -> HLENGTH == 4;
							HBURST == 4 -> HLENGTH == 8;
							HBURST == 5 -> HLENGTH == 8;
							HBURST == 6 -> HLENGTH == 16;
							HBURST == 7 -> HLENGTH == 16;}
							
	extern function new (string name="master_xtn");
	extern function void do_print(uvm_printer printer);

endclass


//-------------------new() method -----------------//
function master_xtn::new(string name="master_xtn");
	super.new(name);
endfunction


//--------------- do_print() method ----------------//
function void master_xtn::do_print(uvm_printer printer);
	super.do_print(printer);
	
	//					string name 		bitstream value		size	radix for printing
	printer.print_field("HRESETn",			this.HREADYin,		1,			UVM_DEC		);
	printer.print_field("HWRITE",			this.HWRITE,		1,			UVM_DEC		);
	printer.print_field("HREADYin",			this.HREADYin,		1,			UVM_DEC		);
	printer.print_field("HREADYout",		this.HREADYout,		1,			UVM_DEC		);
	printer.print_field("HTRANS",			this.HTRANS,		2,			UVM_DEC		);
	printer.print_field("HBURST",			this.HBURST,		3,			UVM_DEC		);
	printer.print_field("HSIZE",			this.HSIZE,		    3,			UVM_DEC		);
	printer.print_field("HLENGTH",			this.HLENGTH,		10,			UVM_DEC		);
	printer.print_field("HADDR",			this.HADDR,			32,			UVM_HEX		);
	printer.print_field("HWDATA",			this.HWDATA,		32,			UVM_HEX		);
	printer.print_field("HRDATA",			this.HRDATA,		32,			UVM_HEX		);
	
endfunction
	
	
	
