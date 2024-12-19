class bridge_scoreboard extends uvm_scoreboard;

	//Factory registeration
	`uvm_component_utils(bridge_scoreboard)
	
	uvm_tlm_analysis_fifo #(master_xtn) fifo_master[];
	uvm_tlm_analysis_fifo #(slave_xtn)  fifo_slave[];
	
	bridge_env_config m_cfg;
	
	master_xtn ahb;
	slave_xtn  apb;
	
	covergroup ahb_cg;
		HADDR	: 	coverpoint ahb.HADDR{
										bins Slave_1 = {[32'h8000_0000:32'h8000_03ff]};
										bins Slave_2 = {[32'h8400_0000:32'h8400_03ff]};
										bins Slave_3 = {[32'h8800_0000:32'h8800_03ff]};
										bins Slave_4 = {[32'h8c00_0000:32'h8c00_03ff]};
										}
									 
		HWRITE 	:	coverpoint ahb.HWRITE{
										bins Write = {1};
										bins Read  = {0};
										}
	
		HSIZE	:	coverpoint ahb.HSIZE{
										bins Byte_1 = {0};
										bins Byte_2 = {1};
										bins Byte_4 = {2};
										}
					
		cross HADDR,HWRITE,HSIZE;
	
	endgroup

	covergroup apb_cg;
		PADDR	: 	coverpoint apb.PADDR{
										bins Slave_1 = {[32'h8000_0000:32'h8000_03ff]};
										bins Slave_2 = {[32'h8400_0000:32'h8400_03ff]};
										bins Slave_3 = {[32'h8800_0000:32'h8800_03ff]};
										bins Slave_4 = {[32'h8c00_0000:32'h8c00_03ff]};
										}
									 
		PWRITE 	:	coverpoint apb.PWRITE{
										bins Write = {1};
										bins Read  = {0};
										}
	
	/*	PSELx	:	coverpoint apb.PSELx{
										bins PSELx_1 = {0};
										bins PSELx_2 = {1};
										bins PSELx_4 = {4};
										bins PSELx_8 = {8};
										}
	*/				
		cross PADDR,PWRITE;
	
	endgroup	
	
	extern function new(string name="bridge_scoreboard", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern function void check_data(master_xtn ahb,slave_xtn apb);
	extern function void compare_data(int HADDR,PADDR,HDATA,PDATA);
	extern function void report_phase(uvm_phase phase);
endclass


//----------------------------------- New() Method -----------------------------------------//
function bridge_scoreboard::new(string name="bridge_scoreboard", uvm_component parent);
	super.new(name,parent);
	
	if(!uvm_config_db #(bridge_env_config)::get(this,"","bridge_env_config",m_cfg))

	    `uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")

	fifo_master=new[m_cfg.no_of_master_agents];
	fifo_slave =new[m_cfg.no_of_slave_agents];
	
	foreach(fifo_master[i])
	fifo_master[i]=new($sformatf("fifo_master[%0d]",i),this);
	
	foreach(fifo_slave[i])
	fifo_slave[i]=new($sformatf("fifo_slave[%0d]",i),this);
	
	ahb_cg=new;
	apb_cg=new;
	
endfunction


//--------------------------------- build_phase() Method ----------------------------------//
function void bridge_scoreboard::build_phase(uvm_phase phase);
	super.build_phase(phase);
		`uvm_info(get_full_name(),"IN THE BUILD PHASE OF BRIDGE_SCOREBOARD",UVM_LOW)
endfunction


//----------------------------------- run_phase() Method ----------------------------------//
task bridge_scoreboard::run_phase(uvm_phase phase);
	
	`uvm_info(get_type_name(),"IN THE RUN_PHASE OF BRIDGE_SCOREBOARD",UVM_LOW)
	
	forever
		begin
			fork
				begin
					fifo_master[0].get(ahb);
					$display("SCOREBOARD:PRINTING AHB MONITOR DATA");
					ahb.print();
					ahb_cg.sample();
				end
				
				begin
					fifo_slave[0].get(apb);
					$display("SCOREBOARD:PRINTING APB MONITOR DATA");
					apb.print();
					apb_cg.sample();
				end
			join
			check_data(ahb,apb);
		end	
endtask

function void bridge_scoreboard::compare_data(int HADDR,PADDR,HDATA,PDATA);
	if(HADDR == PADDR)
		$display("ADDRESS COMPARED SUCCESSFULLY");
	else
		$display("ADDRESS COMPARED FAILED");
		
	if(HDATA == PDATA)
		$display("DATA COMPARED SUCCESSFULLY");
	else
		$display("DATA COMPARED FAILED");
endfunction

function void bridge_scoreboard::check_data(master_xtn ahb,slave_xtn apb);
	if(ahb.HWRITE == 1)
		begin	
			if(ahb.HSIZE == 0)
				begin 
					if(ahb.HADDR[1:0] == 2'b00)
						compare_data(ahb.HADDR,apb.PADDR,ahb.HWDATA[7:0],apb.PWDATA);
					
					if(ahb.HADDR[1:0] == 2'b01)
						compare_data(ahb.HADDR,apb.PADDR,ahb.HWDATA[15:8],apb.PWDATA);
					
					if(ahb.HADDR[1:0] == 2'b10)
						compare_data(ahb.HADDR,apb.PADDR,ahb.HWDATA[23:16],apb.PWDATA);
					
					if(ahb.HADDR[1:0] == 2'b00)
						compare_data(ahb.HADDR,apb.PADDR,ahb.HWDATA[31:24],apb.PWDATA);
				end
				
			if(ahb.HSIZE == 1)
				begin
					if(ahb.HADDR[1:0] == 2'b00)
						compare_data(ahb.HADDR,apb.PADDR,ahb.HWDATA[15:0],apb.PWDATA);
					
					if(ahb.HADDR[1:0] == 2'b01)
						compare_data(ahb.HADDR,apb.PADDR,ahb.HWDATA[31:16],apb.PWDATA);
				end
				
			if(ahb.HSIZE == 2)
				begin
					compare_data(ahb.HADDR,apb.PADDR,ahb.HWDATA,apb.PWDATA);
				end
		end

	if(ahb.HWRITE == 0)
		begin	
			if(ahb.HSIZE == 0)
				begin 
					if(ahb.HADDR[1:0] == 2'b00)
						compare_data(ahb.HADDR,apb.PADDR,ahb.HRDATA,apb.PRDATA[7:0]);
					
					if(ahb.HADDR[1:0] == 2'b01)
						compare_data(ahb.HADDR,apb.PADDR,ahb.HRDATA,apb.PRDATA[15:8]);
					
					if(ahb.HADDR[1:0] == 2'b10)
						compare_data(ahb.HADDR,apb.PADDR,ahb.HRDATA,apb.PRDATA[23:16]);
					
					if(ahb.HADDR[1:0] == 2'b00)
						compare_data(ahb.HADDR,apb.PADDR,ahb.HRDATA,apb.PRDATA[31:24]);
				end
				
			if(ahb.HSIZE == 1)
				begin
					if(ahb.HADDR[1:0] == 2'b00)
						compare_data(ahb.HADDR,apb.PADDR,ahb.HRDATA,apb.PRDATA[15:0]);
					
					if(ahb.HADDR[1:0] == 2'b01)
						compare_data(ahb.HADDR,apb.PADDR,ahb.HRDATA,apb.PRDATA[31:16]);
				end
				
			if(ahb.HSIZE == 2)
				begin
					compare_data(ahb.HADDR,apb.PADDR,ahb.HRDATA,apb.PRDATA);
				end
		end

endfunction

//--------------------------------- report_phase() Method --------------------------------//
function void bridge_scoreboard::report_phase(uvm_phase phase);
	
	`uvm_info(get_type_name(),"IN THE REPORT_PHASE OF BRIDGE_SCOREBOARD",UVM_LOW)
	
endfunction