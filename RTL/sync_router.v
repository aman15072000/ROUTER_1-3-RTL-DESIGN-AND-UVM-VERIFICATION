module sync_router(clk,rstn,detect_add,write_enb_reg,data_in,read_enb_0,read_enb_1,read_enb_2,empty_0,empty_1,empty_2,full_0,full_1,full_2,write_enb,vld_out_0,vld_out_1,vld_out_2,sft_rst_0,sft_rst_1,sft_rst_2,fifo_full);
input clk,rstn,detect_add,write_enb_reg;
input [1:0]data_in;
input read_enb_0,read_enb_1,read_enb_2;
input empty_0,empty_1,empty_2;
input full_0,full_1,full_2;
output reg [2:0]write_enb;
output vld_out_0,vld_out_1,vld_out_2;
output reg sft_rst_0,sft_rst_1,sft_rst_2;
output reg fifo_full;

reg [1:0]int_addr_reg;
reg timer_0,timer_1,timer_2;

//internal address logic
always@(posedge clk)
  begin
     if(!rstn)
	    int_addr_reg<=0;
	 else if(detect_add)
	    int_addr_reg<=data_in;
	 else
	    int_addr_reg<=int_addr_reg;	    
  end
  
//write enable logic
always@(*)
  begin
  // write_enb=3'b000;
    if(write_enb_reg)
	   begin
	     case(int_addr_reg)
		   2'b00:write_enb=3'b001;
		   2'b01:write_enb=3'b010;
		   2'b10:write_enb=3'b100;
		   default:write_enb=3'b000;
		 endcase
		end
	else
      write_enb=3'b000;
  end
	
		
//fifo full logic
always@(*)
  begin
	case(int_addr_reg)
	  2'b00:fifo_full=full_0;
	  2'b01:fifo_full=full_1;
	  2'b10:fifo_full=full_2;
	  default:fifo_full=1'b0;
    endcase
  end
		

//soft reset logic with internal counter/timer 0 for reseting the fifo
always@(posedge clk)
  begin
     if(!rstn)
	   begin
	     timer_0<=0;
		 sft_rst_0<=0;
	   end
	 else if(vld_out_0)
	   begin
	     if(!read_enb_0)
		   begin
		     if(timer_0==5'd29)
			   begin
			     sft_rst_0<=1'b1;
				 timer_0<=1'b0;
			   end
			 else
			   begin
			     sft_rst_0<=01'b0;
				 timer_0<=timer_0+1'b1;
			   end
			end
		 else
		   sft_rst_0<=1'b0;
		   timer_0<=1'b0;
	  end
	 else
	    sft_rst_0<=1'b0;
		timer_0<=1'b0;	    
  end
  
//soft reset logic with internal counter/timer 1 for reseting the fifo
always@(posedge clk)
  begin
     if(!rstn)
	   begin
	     timer_1<=0;
		 sft_rst_1<=0;
	   end
	 else if(vld_out_1)
	   begin
	     if(!read_enb_1)
		   begin
		     if(timer_1==5'd29)
			   begin
			     sft_rst_1<=1'b1;
				 timer_1<=1'b0;
			   end
			 else
			   begin
			     sft_rst_1<=1'b0;
				 timer_1<=timer_1+1'b1;
			   end
			end
		 else
		   sft_rst_1<=1'b0;
		   timer_1<=1'b0;
	  end
	 else
	    sft_rst_1<=1'b0;
		timer_1<=1'b0;	    
  end
		
//soft reset logic with internal counter/timer 2 for reseting the fifo
always@(posedge clk)
  begin
     if(!rstn)
	   begin
	     timer_2<=0;
		 sft_rst_2<=0;
	   end
	 else if(vld_out_2)
	   begin
	     if(!read_enb_2)
		   begin
		     if(timer_2==5'd29)
			   begin
			     sft_rst_2<=1'b1;
				 timer_2<=1'b0;
			   end
			 else
			   begin
			     sft_rst_2<=1'b0;
				 timer_2<=timer_2+1'b1;
			   end
			end
		 else
		   sft_rst_2<=1'b0;
		   timer_2<=1'b0;
	  end
	 else
	    sft_rst_2<=1'b0;
		timer_2<=1'b0;	    
  end	
  
assign vld_out_0=~empty_0;
assign vld_out_1=~empty_1;
assign vld_out_2=~empty_2;
endmodule
