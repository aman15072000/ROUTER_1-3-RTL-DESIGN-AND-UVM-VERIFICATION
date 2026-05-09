module fifo_router #(parameter width=9,
                               depth=16,
                               addr_size=4)
(input clk,rstn,sft_rst,
input [width-2:0]data_in,
input write_enb,read_enb,lfd_state,
output reg [width-2:0]data_out,
output empty,full); 
	
integer i;
	
reg [addr_size:0]rd_pt;
reg [addr_size:0]wr_pt;
reg [width-2:0]fifo_counter;     //Internal Counter

reg [width-1:0]FIFO[0:depth-1];  //Fifo Declaration
reg temp;

//for making delay in lfd_state by one clk cycle
/* always@(posedge clk)
  begin
    if(!rstn)
       temp<=0;
    else
       temp<=lfd_state;
   end */

// Write Operation
always@(posedge clk)
   begin
       if(!rstn)
	   begin
	     wr_pt<=5'b0;
	     for(i=0;i<depth;i=i+1)
	         FIFO[i]<=0;
	   end
       else if(sft_rst)
           begin
	     wr_pt<=5'b0;
	     for(i=0;i<depth;i=i+1)
	         FIFO[i]<=0;
	   end
	else if(write_enb && !full)
           begin
             FIFO[wr_pt[3:0]]<={lfd_state,data_in};
	     wr_pt<=wr_pt+1'b1;
	   end
        else
            wr_pt<=wr_pt;
    end

// Fifo Downcounter Logic
always@(posedge clk)
   begin
       if(!rstn)
	     fifo_counter<=5'b0;
       else if(sft_rst)
             fifo_counter<=5'b0;	
       else if(read_enb && !empty)
           begin
               if(FIFO[rd_pt[3:0]][8]==1'b1)
                 fifo_counter<=FIFO[rd_pt[3:0]][7:2] + 1'b1;
               else if(fifo_counter!=0)
                 fifo_counter<=fifo_counter - 1'b1;
	   end
    end

//Read Operation	
always@(posedge clk)
   begin
      if(!rstn)
          begin
	     rd_pt<=5'b0;
	     data_out<=8'b0;	
	  end 
       else if(sft_rst)
           begin
	     rd_pt<=5'b0;
	     data_out<=8'bz;
	   end
/*      else if(fifo_counter==0)
	  begin
              data_out<=8'dz;
	  end*/
      else if(read_enb && !empty)
	  begin
              data_out<=FIFO[rd_pt[3:0]];
	      rd_pt<=rd_pt+1'b1;
	  end
	    else if(fifo_counter==0)
	  begin
              data_out<=8'dz;
	  end
      else
            rd_pt<=rd_pt;
   end

//Empty and Full logic
assign empty=(wr_pt==rd_pt)?1'b1:1'b0;
assign full=(wr_pt==5'b10000 && rd_pt==00000)?1'b1:1'b0;
endmodule
	   
