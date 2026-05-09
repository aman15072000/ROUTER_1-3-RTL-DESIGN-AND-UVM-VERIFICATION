module register_router(
input clk,rstn,pkt_valid,
input [7:0]data_in,
input fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state,
output reg [7:0]dout,
output reg parity_done,low_pkt_valid,err);

reg [7:0]header_byte,internal_parity,packet_parity_byte,fifo_full_state_byte;

//header byte
always@(posedge clk)
  begin
    if(!rstn)
      header_byte<=8'b0;
    else if(detect_add && pkt_valid && (data_in[1:0]!=3))
      header_byte<=data_in;
  end
  
//Internal parity logic
always@(posedge clk)
   begin
      if(!rstn)
       internal_parity<=8'b0;
      else if(detect_add)
        internal_parity<=8'b0;
      else if(lfd_state)
        internal_parity<=internal_parity^header_byte;
      else if(pkt_valid && ld_state && ~full_state)
        internal_parity<=internal_parity^data_in;
   end

//Packet parity logic
always@(posedge clk)
   begin
      if(!rstn)
        packet_parity_byte<=8'b0;
      else if(detect_add)
        packet_parity_byte<=8'b0;
      else if(~pkt_valid && ld_state)
        packet_parity_byte<=data_in;
     end

//Fifo full state logic
always@(posedge clk)
   begin
      if(!rstn)
       fifo_full_state_byte<=8'b0;
      else if(fifo_full && ld_state)
       fifo_full_state_byte<=data_in;
   end

//dout logic
always@(posedge clk)
   begin
      if(!rstn)
       dout<=8'b0;
      else  if(~(detect_add && pkt_valid && data_in[1:0]!=3))
            begin
               if(lfd_state)
                  dout<=header_byte;
               else 
                  begin
                    if(ld_state && ~fifo_full)
                       dout<=data_in;
                    else
                      begin
                        if(~(ld_state && fifo_full))
                          begin
                            if(laf_state)
                               dout<=fifo_full_state_byte;
                            else
                               dout<=dout;
                           end
                        end
                   end
            end
   end

//parity done logic
 always@(posedge clk)
   begin
      if(!rstn || detect_add)
        parity_done<=1'b0;
      else if((ld_state && ~fifo_full && ~pkt_valid) || (laf_state && low_pkt_valid && ~parity_done))
        parity_done<=1'b1;
      else
        parity_done<=parity_done;
   end

//error logic
 always@(posedge clk)
   begin
      if(!rstn)
        err<=1'b0;
      else 
       begin 
        if(parity_done)
          begin
             if(internal_parity!=packet_parity_byte)
                err<=1'b1;
             else
                err<=1'b0;
          end
			 err<=1'b0;
        end
    end

//low packet valid logic
always@(posedge clk)
   begin
      if(!rstn || rst_int_reg)
        low_pkt_valid<=1'b0;
      else 
       begin 
        if(ld_state && ~pkt_valid)
            low_pkt_valid<=1'b1;
        else
            low_pkt_valid<=1'b0;
       end
   end

endmodule
