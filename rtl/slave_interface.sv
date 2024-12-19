interface slave_interface(input clock);
	
	bit 		 HCLK;
	bit	  	     PENABLE;
	bit  		 PWRITE;
	logic [31:0] PWDATA;
	logic [31:0] PRDATA;
	logic [31:0] PADDR;
	logic [3:0]  PSELx;
	 
	//assign HCLK=clock;
	
	clocking drv_cb@(posedge clock);
		default input #1 output #1;
		output PRDATA;
		input PENABLE;
		input PWRITE;
		input PADDR;
		input PSELx;
	endclocking 
	
	clocking mon_cb@(posedge clock);
		default input #1 output #1;
			input PENABLE;
			input PWRITE;
			input PWDATA;
			input PRDATA;
			input PADDR;
			input PSELx;
	endclocking
	
	modport DRV_MP(clocking drv_cb);
	
	modport MON_MP(clocking mon_cb);

endinterface