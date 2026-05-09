module router(
input clk,rstn,pkt_valid,
input [7:0]data_in,
input read_enb_0,read_enb_1,read_enb_2,            //from destination network
output vld_out_0,vld_out_1,vld_out_2,              //to destination network
output err,busy,                                   //to source network
output [7:0]data_out_0,data_out_1,data_out_2);     //to destination network


wire [2:0]write_enb;
wire fifo_full,write_enb_reg,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state,parity_done,low_pkt_valid;
wire empty_0,empty_1,empty_2;
wire full_0,full_1,full_2;
wire sft_rst_0,sft_rst_1,sft_rst_2;
wire [7:0]dout;

register_router R1(clk,rstn,pkt_valid,data_in,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state,dout,parity_done,low_pkt_valid,err);

sync_router  S1(clk,rstn,detect_add,write_enb_reg,data_in[1:0],read_enb_0,read_enb_1,read_enb_2,empty_0,empty_1,empty_2,full_0,full_1,full_2,write_enb,vld_out_0,vld_out_1,vld_out_2,sft_rst_0,sft_rst_1,sft_rst_2,fifo_full);

fsm_router FS1(clk,rstn,pkt_valid,parity_done,data_in[1:0],sft_rst_0,sft_rst_1,sft_rst_2,fifo_full,low_pkt_valid,empty_0,empty_1,empty_2,write_enb_reg,rst_int_reg,detect_add,busy,ld_state,laf_state,full_state,lfd_state);

fifo_router FF1(clk,rstn,sft_rst_0,dout,write_enb[0],read_enb_0,lfd_state,data_out_0,empty_0,full_0);
fifo_router FF2(clk,rstn,sft_rst_1,dout,write_enb[1],read_enb_1,lfd_state,data_out_1,empty_1,full_1);
fifo_router FF3(clk,rstn,sft_rst_2,dout,write_enb[2],read_enb_2,lfd_state,data_out_2,empty_2,full_2);

endmodule

