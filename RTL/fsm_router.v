module fsm_router(
input clk,rstn,pkt_valid,parity_done,
input [1:0]data_in,
input sft_rst_0,sft_rst_1,sft_rst_2,
input fifo_full,low_pkt_valid,
input fifo_empty_0,fifo_empty_1,fifo_empty_2,
output write_enb_reg,rst_int_reg,detect_add,busy,
output ld_state,laf_state,full_state,lfd_state);

parameter   DECODE_ADDRESS    =3'b000,
            LOAD_FIRST_DATA   =3'b001,
	    LOAD_DATA         =3'b010,
	    FIFO_FULL_STATE   =3'b011,
	    LOAD_AFTER_FULL   =3'b100,
            LOAD_PARITY       =3'b101,
            CHECK_PARITY_ERROR=3'b110,
	    WAIT_TILL_EMPTY   =3'b111;

reg [1:0]addr;    //internal address declaration
reg [2:0]present_state, next_state;

//internal address Logic
always@(posedge clk)
    begin
      if(!rstn)
         addr<=2'b0;
    //  else 
    //   if((sft_rst_0 && data_in==2'b00)||(sft_rst_1 && data_in==2'b01)||(sft_rst_2 && data_in==2'b10))
     //    addr<=2'b0;
       else if(detect_add)
         addr<=data_in;
		
		 else
		   addr<=addr;
     end

// for present state logic
always@(posedge clk)
  begin
     if(!rstn)
	   present_state<=DECODE_ADDRESS;
	   else
             if((sft_rst_0 && data_in==2'b00)||(sft_rst_1 && data_in==2'b01)||(sft_rst_2 && data_in==2'b10))
	        present_state<=DECODE_ADDRESS;
             else
                present_state<=next_state; 
  end
  
// for next state
always@(*)
  begin
    next_state=present_state;
      begin
         case(present_state)
	   DECODE_ADDRESS     :   if((pkt_valid && (addr==2'b0) && fifo_empty_0) || (pkt_valid && (addr==2'b01) && fifo_empty_1) || (pkt_valid && (addr==2'b10) && fifo_empty_2))
	                          next_state=LOAD_FIRST_DATA;
		                  else if((pkt_valid && (addr==2'b0) && ~fifo_empty_0) || (pkt_valid && (addr==2'b01) && ~fifo_empty_1) || (pkt_valid && (addr==2'b10) && ~fifo_empty_2))		  
                                  next_state=WAIT_TILL_EMPTY;
                                  else
		                  next_state=DECODE_ADDRESS;

	   LOAD_FIRST_DATA    :   next_state=LOAD_DATA;

	   LOAD_DATA          :   if(fifo_full)
	                          next_state=FIFO_FULL_STATE;
		                  else if(~fifo_full && ~pkt_valid)
                                  next_state=LOAD_PARITY;
                               	  else
                                  next_state=LOAD_DATA;

           FIFO_FULL_STATE    :   if(~fifo_full)
                                  next_state=LOAD_AFTER_FULL;
                                  else if(fifo_full)             //is it necessary to keep condition here
                                  next_state=FIFO_FULL_STATE;


     
           LOAD_PARITY        :   next_state=CHECK_PARITY_ERROR;

           CHECK_PARITY_ERROR :   if(~fifo_full)
                                  next_state=FIFO_FULL_STATE;

           LOAD_AFTER_FULL    :   if(~parity_done && low_pkt_valid)
                                  next_state=LOAD_PARITY;
                                  else if(~parity_done && ~low_pkt_valid)
                                  next_state=LOAD_DATA;
                                  else if(parity_done)
                                  next_state=DECODE_ADDRESS;

           WAIT_TILL_EMPTY    :   if((fifo_empty_0 && (addr==00)) || (fifo_empty_1 && (addr==01)) || (fifo_empty_2 && (addr==10)))
                                  next_state=LOAD_FIRST_DATA;
		                  else
                                  next_state=WAIT_TILL_EMPTY;

	        default            :   next_state=DECODE_ADDRESS;
        endcase
      end
    end
  
//output logic
  assign detect_add=(present_state==DECODE_ADDRESS)?1'b1:1'b0;
  assign lfd_state=(present_state==LOAD_FIRST_DATA)?1'b1:1'b0;
  assign ld_state=(present_state==LOAD_DATA)?1'b1:1'b0;
  assign full_state=(present_state==FIFO_FULL_STATE)?1'b1:1'b0;
  assign laf_state=(present_state==LOAD_AFTER_FULL)?1'b1:1'b0;
  assign rst_int_reg=(present_state==CHECK_PARITY_ERROR)?1'b1:1'b0;
  assign write_enb_reg=((present_state==LOAD_DATA)||(present_state==LOAD_PARITY) || (present_state==LOAD_AFTER_FULL) )?1'b1:1'b0;

  assign busy=((present_state==LOAD_FIRST_DATA) || (present_state==FIFO_FULL_STATE) || (present_state==LOAD_AFTER_FULL) || (present_state==LOAD_PARITY) || (present_state==CHECK_PARITY_ERROR) || (present_state==WAIT_TILL_EMPTY))?1'b1:1'b0;

endmodule
