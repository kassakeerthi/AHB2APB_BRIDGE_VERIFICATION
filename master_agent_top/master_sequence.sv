
class master_sequence extends uvm_sequence #(master_xtn);  
	`uvm_object_utils(master_sequence)  

	extern function new(string name ="master_sequence");
	extern task body();

endclass:master_sequence


//------------------------ NEW() method -----------------------------//
function master_sequence::new(string name ="master_sequence");
	super.new(name);
endfunction:new


//------------------------- body() method ----------------------------//
task master_sequence::body();    
		
endtask:body

//---------------------------------------------------------------------//

//                           SINGLE TRANSFER

//--------------------------------------------------------------------//
class master_single_xtns extends uvm_sequence #(master_xtn);
	`uvm_object_utils(master_single_xtns)
	
	extern function new (string name="master_single_xtns");
	extern task body();
	
endclass:master_single_xtns


//---------------------------- NEW() method ---------------------------//
function master_single_xtns::new(string name="master_single_xtns");
	super.new();
endfunction


//------------------------- body() method -----------------------------//
task master_single_xtns::body();
	
	req=master_xtn::type_id::create("req");
	
	start_item(req);
	assert(req.randomize() with {HTRANS == 2'b10; HWRITE inside{0,1}; HBURST == 0; HADDR inside {32'h8800_0000 , 32'h8800_03ff}; HSIZE inside{0};}) 
	finish_item(req);
endtask


//---------------------------------------------------------------------//

//                           BURST INCR TRANSFER

//--------------------------------------------------------------------//
class master_incr_xtns extends uvm_sequence #(master_xtn);
	
	`uvm_object_utils(master_incr_xtns)
	
	//Declaring haddr, START_ADDR, BOUNDARY_ADDR, hburst, hsize, hwrite and hlength 
	bit [31:0] haddr;
	bit [2:0]  hsize;
	bit [2:0]  hburst;
	bit        hwrite;
	bit [9:0]  hlength;
	extern function new (string name="master_incr_xtns");
	extern task body();
	
endclass:master_incr_xtns


//---------------------------- NEW() method ---------------------------//
function master_incr_xtns::new(string name="master_incr_xtns");
	super.new();
endfunction


//------------------------- body() method -----------------------------//
task master_incr_xtns::body();
	
	req=master_xtn::type_id::create("req");
	
	repeat(5);
	
	start_item(req);
	assert(req.randomize() with {HTRANS == 2'b10; HWRITE inside{0,1}; HBURST inside{1,3,5,7};}) 	//HBURST should be 1,3,5, or 7 for BURST_INCR type.  
	finish_item(req);
	
	//Declaring the local_properties for to store the CONTROL SIGNALS[of NON_SEQUENTIAL] wich we got from the randomize
	//In BURST_INCR the 1st TRANSFER is always the NON_SEQUENTIAL type and it continues with SEQUENTIAL type.
	//We need to pass the control signals of the NON_SEQUENTIAL type to SEQUENTIAL type 
	haddr=req.HADDR;
	hsize=req.HSIZE;
	hburst=req.HBURST;
	hwrite=req.HWRITE;
	hlength=req.HLENGTH;
	
	//int i=1[i should be 1 always, becuase i=0 is NON_SEQUENTIAL type] 
	for(int i=1; i<hlength; i++)
		begin
			start_item(req);
			//HTRANS == 2'b11; is SEQUENTIAL type TRANSFER
			assert(req.randomize() with {HTRANS == 2'b11; 
										HWRITE == hwrite;
										HBURST == hburst;
										HSIZE == hsize;
										HADDR == haddr+(2**HSIZE);})
			finish_item(req);
			haddr=req.HADDR;	//Updating the address
		end
	
endtask


//---------------------------------------------------------------------//

//                           WRAP INCR TRANSFER

//--------------------------------------------------------------------//
class master_wrap_xtns extends uvm_sequence #(master_xtn);
	`uvm_object_utils(master_wrap_xtns)
	
	//Declaring haddr, START_ADDR, BOUNDARY_ADDR, hburst, hsize, hwrite and hlength 
	bit [31:0] haddr;
	bit [31:0] start_addr;
	bit [31:0] boundary_addr;
	bit [2:0]  hsize;
	bit [2:0]  hburst;
	bit        hwrite;
	bit [9:0]  hlength;
	
	extern function new (string name="master_wrap_xtns");
	extern task body();
	
endclass:master_wrap_xtns


//---------------------------- NEW() method ---------------------------//
function master_wrap_xtns::new(string name="master_wrap_xtns");
	super.new();
endfunction


//------------------------- body() method -----------------------------//
task master_wrap_xtns::body();
	
	req=master_xtn::type_id::create("req");
	
	repeat(4);
	
	start_item(req);
	assert(req.randomize() with {HTRANS == 2'b10; HWRITE inside{0,1}; HBURST inside{2,4,6};}) 	//HBURST should be 2,4 or 6 for WRAP type.  
	finish_item(req);
	
	//Declaring the local_properties for to store the CONTROL SIGNALS[of NON_SEQUENTIAL] wich we got from the randomize
	//In BURST_INCR the 1st TRANSFER is always the NON_SEQUENTIAL type and it continues with SEQUENTIAL type.
	//We need to pass the control signals of the NON_SEQUENTIAL type to SEQUENTIAL type 
	haddr=req.HADDR;
	hsize=req.HSIZE;
	hburst=req.HBURST;
	hwrite=req.HWRITE;
	hlength=req.HLENGTH;
	
	//To caluculate the START_ADDR and BOUNDARY_ADDR
	start_addr=(haddr/(2**hsize)*(hlength))*(2**hsize)*(hlength);
	boundary_addr=start_addr+(2**hsize)*(hlength);
	
	//To update the haddr
	haddr=req.HADDR+(2**req.HSIZE);
	
	//int i=1[i should be 1 always, becuase i=0 is NON_SEQUENTIAL type] 
	for(int i=1; i<hlength; i++)
		begin
			//We need to check the haddr if it is crossing the BOUNDARY_ADDR
				if(haddr==boundary_addr)
					haddr = start_addr;		//if it cross then we need to start the storeing of data from START_ADDR  
				
				start_item(req);
				//HTRANS == 2'b11; is SEQUENTIAL type TRANSFER
				assert(req.randomize() with {HTRANS == 2'b11; 
											HWRITE == hwrite;
											HBURST == hburst;
											HSIZE == hsize;
											HADDR == haddr;})
				finish_item(req);
				
				haddr=req.HADDR+(2**hsize);	//Updating the address
		end
	
endtask


/////////////////////////////////////////////////////////////////////////////////////////
// 					masster incr 1
////////////////////////////////////////////////////////////////////////////////////////////


class master_incr_1 extends uvm_sequence #(master_xtn);
	
	`uvm_object_utils(master_incr_1)
	
	
	extern function new (string name="master_incr_1");
	extern task body();
	
endclass:master_incr_1


//---------------------------- NEW() method ---------------------------//
function master_incr_1::new(string name="master_incr_1");
	super.new();
endfunction


//------------------------- body() method -----------------------------//
task master_incr_1::body();
	
	req=master_xtn::type_id::create("req");
	
	start_item(req);
	assert(req.randomize() with {HTRANS == 2'b10; HWRITE inside{0,1}; HBURST inside{0}; HADDR inside {32'h8000_0000 , 32'h8000_03ff}; HSIZE inside{1}; }) 	
	finish_item(req);
	
	
endtask



/////////////////////////////////////////////////////////////////////////////////////////
// 					masster incr 2
////////////////////////////////////////////////////////////////////////////////////////////


class master_incr_2 extends uvm_sequence #(master_xtn);
	
	`uvm_object_utils(master_incr_2)
	
	//Declaring haddr, START_ADDR, BOUNDARY_ADDR, hburst, hsize, hwrite and hlength 
	bit [31:0] haddr;
	bit [2:0]  hsize;
	bit [2:0]  hburst;
	bit        hwrite;
	bit [9:0]  hlength;
	extern function new (string name="master_incr_2");
	extern task body();
	
endclass:master_incr_2


//---------------------------- NEW() method ---------------------------//
function master_incr_2::new(string name="master_incr_2");
	super.new();
endfunction


//------------------------- body() method -----------------------------//
task master_incr_2::body();
	
	req=master_xtn::type_id::create("req");
	
	start_item(req);
	assert(req.randomize() with {HTRANS == 2'b10; HWRITE inside{1}; HBURST inside{1,3,5,7}; HADDR inside {32'h8c00_0000 , 32'h8c00_03ff}; HSIZE inside {2};}) 	  
	finish_item(req);
	
	
endtask
