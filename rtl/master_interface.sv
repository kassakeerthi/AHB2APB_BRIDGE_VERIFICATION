interface master_interface(input bit clock);

	bit 		 HCLK;
	bit 		 HRESETn;
	bit   [1:0]  HTRANs;
	bit 		 HWRITE;
	bit 		 HSELAPBif;
	bit 		 HREADYin;
	bit 		 HREADYout;
	bit   [1:0]  HRESP;
	logic [31:0] HWDATA;
	logic [31:0] HRDATA;
	logic [31:0] HADDR;
	logic [2:0]  HSIZE;
	
	assign HCLK=clock;
	
	clocking drv_cb@(posedge clock);
		default input #1 output#0;
		input  HREADYout;
		input  HRDATA;
		output HRESETn;
		output HTRANs;
		output HWRITE;
		output HSELAPBif;
		output HREADYin;
		output HWDATA;
		output HADDR;
		output HSIZE;
	endclocking
	
	clocking mon_cb@(posedge clock);
		default input #1 output #0;
		input HRESETn;
		input HTRANs;
		input HWRITE;
		input HSELAPBif;
		input HREADYin;
		input HREADYout;
		input HRESP;
		input HWDATA;
		input HRDATA;
		input HADDR;
		input HSIZE;
	endclocking
	
	modport DRV_MP(clocking drv_cb);
	
	modport MON_MP(clocking mon_cb);
	
endinterface