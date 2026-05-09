module top;
   	
	// import router_pkg
    	import router_pkg::*;
   
	// import uvm_pkg.sv
	import uvm_pkg::*;

   	// Generate clk signal
	bit clk;  
	always 
		#10 clk=!clk;     

   	// Instantiate 4 router_if interface instances in0,in1,in2,in3 with clk as input
            router_if in(clk);  //src
            router_if in0(clk);  //dst0
            router_if in1(clk);  //dst1
            router_if in2(clk);  //dst2

       
   	 // Instantiate 4 router duv instances in0,in1,in2,in3 with interface as input
    		router DUV(.clk(clk), .rstn(in.rstn), .pkt_valid(in.pkt_valid), .data_in(in.data_in), .err(in.err), .busy(in.busy),
                           .read_enb_0(in0.read_enb), .vld_out_0(in0.vld_out), .data_out_0(in0.data_out),
                            .read_enb_1(in1.read_enb), .vld_out_1(in1.vld_out), .data_out_1(in1.data_out),
                             .read_enb_2(in2.read_enb), .vld_out_2(in2.vld_out), .data_out_2(in2.data_out));


   	// In initial block
       	initial
		 begin
			
			`ifdef VCS
         		$fsdbDumpvars(0, top);
        		`endif
			
			//set the virtual interface instances as strings vif,vif_0,vif_1,vif_2 using the uvm_config_db 
  			uvm_config_db #(virtual router_if)::set(null,"*","vif",in);
  			uvm_config_db #(virtual router_if)::set(null,"*","vif_0",in0);
  			uvm_config_db #(virtual router_if)::set(null,"*","vif_1",in1);
  			uvm_config_db #(virtual router_if)::set(null,"*","vif_2",in2);


			// Call run_test
			
			run_test();
		end

 property pkt_valid;
         @(posedge clk)
           $rose(in.pkt_valid) |=> in.busy;
endproperty
PKT_VALID: assert property(pkt_valid);


			 
property read_enb0;
         @(posedge clk)
           $rose(in0.vld_out) |=> ##[0:29]in0.read_enb;
endproperty
READ_ENABLE_0: assert property(read_enb0);

			 
			 
property read_enb1;
         @(posedge clk)
           $rose(in1.vld_out) |=> ##[0:29]in1.read_enb;
endproperty
READ_ENABLE_1: assert property(read_enb1);

			 
			 

property read_enb2;
         @(posedge clk)
           $rose(in2.vld_out) |=> ##[0:29]in2.read_enb;
endproperty
READ_ENABLE_2: assert property(read_enb2);

			 
/*			 
property read_enb00;
         @(posedge clk)
           $fell(in0.vld_out) |=> $fell(in0.read_enb);
endproperty
READ_ENABLE_00: assert property(read_enb00);

			 
			 

property read_enb01;
         @(posedge clk)
           $fell(in1.vld_out) |=> $fell(in1.read_enb);
endproperty
READ_ENABLE_01: assert property(read_enb01);

			 
			 
property read_enb02;
         @(posedge clk)
           $fell(in2.vld_out) |=> $fell(in2.read_enb);
endproperty
READ_ENABLE_02: assert property(read_enb02);
*/
			 	
endmodule