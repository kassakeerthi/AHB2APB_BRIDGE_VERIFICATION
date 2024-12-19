module top();

	//import test_pkg
	import bridge_test_pkg::*;
	
	// import uvm_pkg
	import uvm_pkg::*;
	
	//generate clock signal
	bit clock;
	always
		#10 clock=~clock;
		
	//initialize the interface file.
	master_interface ahb_if(clock);
	slave_interface apb_if(clock);
			
	//initialize the DUV
	rtl_top DUV( .Hclk(ahb_if.HCLK),
                 .Hresetn(ahb_if.HRESETn),
                 .Htrans(ahb_if.HTRANs),
				 .Hsize(ahb_if.HSIZE), 
		         .Hreadyin(ahb_if.HREADYin),
		         .Hwdata(ahb_if.HWDATA), 
				 .Haddr(ahb_if.HADDR),
		         .Hwrite(ahb_if.HWRITE),
                 .Prdata(apb_if.PRDATA),
				 .Hrdata(ahb_if.HRDATA),
				 .Hresp(ahb_if.HRESP),
				 .Hreadyout(ahb_if.HREADYout),
				 .Pselx(apb_if.PSELx),
				 .Pwrite(apb_if.PWRITE),
		       	 .Penable(apb_if.PENABLE), 
		         .Paddr(apb_if.PADDR),
				 .Pwdata(apb_if.PWDATA)
		    ) ;	
	
	initial
		begin 
			`ifdef VCS
         		$fsdbDumpvars(0, top);
			`endif
			
			//Passing Interface
			uvm_config_db #(virtual master_interface)::set(null,"*","master_vif_0",ahb_if);
			$display("i am in top ahb interface is %p",ahb_if);
			uvm_config_db #(virtual slave_interface)::set(null,"*","slave_vif0",apb_if);
			$display("i am in top apb interface is %p",apb_if);
			//by run_test() method starting all the phases and initiate the test.
			run_test();
		end
		
		
		property STABLE_SIGNALS;
			@(posedge clock) ~(ahb_if.HREADYout) |=> $stable(ahb_if.HADDR) && $stable(ahb_if.HSIZE) && $stable(ahb_if.HWDATA) && $stable(ahb_if.HWRITE);
		endproperty
		
		property PSELx;
			@(posedge clock) apb_if.PSELx |-> $stable(apb_if.PSELx == 4'b0001) || $stable(apb_if.PSELx == 4'b0010) || $stable(apb_if.PSELx == 4'b0100) || $stable(apb_if.PSELx == 4'b1000);
		endproperty
		
		A1: assert property(STABLE_SIGNALS)
			$display("ASSERTION SUCCESS FOR STABLE_SIGNALS");
		else
			$display("ASSERTION FAILED FOR STABLE_SIGNALS");
			
		A11: cover property(STABLE_SIGNALS);
		
		A2: assert property(PSELx)
			$display("ASSERTION SUCCESS FOR PSELx");
		else
			$display("ASSERTION FAILED FOR PSELx");
			
		A22: cover property(PSELx);
endmodule