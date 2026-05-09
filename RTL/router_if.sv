

interface router_if(input bit clk);
  
logic [7:0] data_in;
logic [7:0] data_out;
logic rstn;
logic err;
logic busy;
logic vld_out;
bit read_enb; 
bit pkt_valid;
  

/********************************clocking Blocks and Modports***********************/
	//Write Driver clocking Block
	clocking wdr_cb @ (posedge clk);
		default input #1 output #1;
		output data_in;
                output pkt_valid;
                output rstn;
                input busy;
                input err;
	endclocking

	//Read Driver clocking Block
	clocking rdr_cb @ (posedge clk);
		default input #1 output #1;
		output read_enb;
		input vld_out;
	endclocking

	//Write Monitor clocking Block
	clocking wmon_cb @(posedge clk);
		default input #1 output #1;
		input data_in;
		input pkt_valid;
		input rstn;
                input err;
                input busy;
	endclocking

	//Read Monitor clocking Block
	clocking rmon_cb @(negedge clk);
		default input #1 output #1;
		input data_out;
		input read_enb;
	endclocking

	//Write Driver Modports clocking Block
	modport WDR_MP (clocking wdr_cb);

	//Read Driver Modports clocking Block
	modport RDR_MP (clocking rdr_cb);

	//Write Monitor Modports clocking Block
	modport WMON_MP (clocking wmon_cb);

	//Read Monitor Modports clocking Block
	modport RMON_MP (clocking rmon_cb);

endinterface : router_if