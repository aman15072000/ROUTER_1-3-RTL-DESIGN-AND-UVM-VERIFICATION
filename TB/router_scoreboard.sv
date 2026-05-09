class router_scoreboard extends uvm_scoreboard;

    // Declare handles for uvm_tlm_analysis_fifos paroutereterized by read & write transactions as fifo_rdh & fifo_wrh respectively
	//    Hint:  uvm_tlm_analysis_fifo #(read_xtn) fifo_rdh;
	//           uvm_tlm_analysis_fifo #(write_xtn) fifo_wrh;
	
	uvm_tlm_analysis_fifo #(read_xtn) fifo_rdh[];
    uvm_tlm_analysis_fifo #(write_xtn) fifo_wrh[];

       
	// Factory registration
	 `uvm_component_utils(router_scoreboard)

         router_env_config m_cfg;

		write_xtn wr;
		read_xtn rd;

		write_xtn write_cov_data;
        read_xtn read_cov_data;


// LAB : write the covergroup router_fcov1 for write transactions
covergroup router_src;
//option.per_instance=1;
       //ADDRESS
     
        SRC_ADDR : coverpoint write_cov_data.header[1:0] {
					bins addr_0 = {2'b00};
					bins addr_1 = {2'b01};
					bins addr_2 = {2'b10};
					/*bins mid3 = {[1024:1535]};
					bins mid4 = {[1536:2047]};
					bins mid5 = {[2048:2559]};
					bins mid6 = {[2560:3071]};
					bins mid7 = {[3072:3583]};
					bins mid8 = {[3584:4094]};
					bins high = {[3996:4095]};*/
					}
    	     	     
        //DATA
        SRC_PAYLOAD_LENGHT : coverpoint write_cov_data.header[7:2] {
                   bins small_pkt  = {[1:14]};
		           bins medium_pkt = {[15:30]};
		           bins big_pkt  = {[31:63]};
		          // bins high = {[64'h0001_0000_0000_0000:64'h0000_ffff_ffff_ffff]};
                 }
    
        // WRITE
        ERROR : coverpoint write_cov_data.err {
                  bins error = {0};
				  //bins error1 = {1};

    	 }
    
    
        //Write Operation - Functional Coverage
        SRC_ADDR_x_SRC_PAYLOAD_LENGTH_x_ERROR : cross SRC_ADDR,SRC_PAYLOAD_LENGHT,ERROR;
          
    endgroup

//LAB : write the covergroup router_fcov2 for read transactions
    covergroup router_dst;
//option.per_instance=1;
       //ADDRESS
        DST_ADDR : coverpoint read_cov_data.header[1:0] {
					/*bins addr_0 = {2'b00};
					bins addr_1 = {2'b01};
					bins addr_2 = {2'b10};*/
					bins addr_4 = {[0:2]};
					}
       
        //DATA
        DST_PAYLOAD_LENGHT : coverpoint read_cov_data.header[7:2] {
                   bins small_pkt  = {[1:14]};
		           bins medium_pkt = {[15:30]};
		           bins big_pkt  = {[31:63]};
		          // bins high = {[64'h0001_0000_0000_0000:64'h0000_ffff_ffff_ffff]};
                     }
    
       /* // READ
        RD : coverpoint read_cov_data.read {
               bins rd_bin = {1};*/
    	
        
        //Read Operation - Functional Coverage
        DST_ADDR_x_DST_PAYLOAD_LENGTH : cross DST_ADDR,DST_PAYLOAD_LENGHT;
        
    endgroup


//------------------------------------------
// Methods
//------------------------------------------

// Standard UVM Methods:
extern function new(string name,uvm_component parent);
extern function void build_phase(uvm_phase phase);

extern task run_phase(uvm_phase phase);
extern task check_data(read_xtn r_data, write_xtn w_data);
//extern function void report_phase(uvm_phase phase);

endclass

//-----------------  constructor new method  -------------------//

       // Add Constructor function
           // Create instances of uvm_tlm_analysis fifos inside the constructor
           // using new("fifo_h", this)
    function router_scoreboard::new(string name,uvm_component parent);
		super.new(name,parent);
			 	router_src=new();
				router_dst=new();
	endfunction
	
	//-----------------  build phase method  -------------------//

    function void router_scoreboard::build_phase(uvm_phase phase);
        //super.build_phase(phase);

	//get configuration object router_env_config from database using uvm_config_db() 
	  if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",m_cfg))
		`uvm_fatal("SCOREBOARD_CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
		    wr =write_xtn::type_id::create("wr");
			rd =read_xtn::type_id::create("rd");
             fifo_wrh=new[m_cfg.no_of_write_agent];
			 fifo_rdh=new[m_cfg.no_of_read_agent]; 
			 
			 foreach(fifo_wrh[i])
		        fifo_wrh[i]=new($sformatf("fifo_wrh[%0d]",i),this);     
             foreach(fifo_rdh[i])
		        fifo_rdh[i]=new($sformatf("fifo_rdh[%0d]",i),this);
				
	    super.build_phase(phase);               
		endfunction



//-----------------  run() phase  -------------------//

       task router_scoreboard::run_phase(uvm_phase phase);
	   forever 
	    begin
        fork
// In forever loop
// get and print the write data using the tlm fifo
// Call the method mem_write
         begin
	      forever 
		    begin
            fifo_wrh[0].get(wr);
             //mem_write(wr);
             `uvm_info("WRITE SB","write data" , UVM_LOW)
              wr.print;
			  write_cov_data = wr;
// LAB : sample covergroup for write transactions
    	          router_src.sample();
			 end
		 end
// In forever loop
// get and print the read data using the tlm fifo
// Call the method check_data_data
          begin
           forever 
		      begin
			     fork
				   begin
                  fifo_rdh[0].get(rd);
                 `uvm_info("READ SB", "read data" , UVM_LOW)
                  rd.print;
                  //check_data_data(rd);
				  check_data(rd, wr);
				  read_cov_data = rd; 
    	          router_dst.sample();
				  end
				  
				    begin
                  fifo_rdh[1].get(rd);
                 `uvm_info("READ SB", "read data" , UVM_LOW)
                  rd.print;
                  //check_data_data(rd);
				  check_data(rd, wr);
				  read_cov_data = rd; 
    	          router_dst.sample();
				  end
				  
				    begin
                  fifo_rdh[2].get(rd);
                 `uvm_info("READ SB", "read data" , UVM_LOW)
                  rd.print;
                  //check_data_data(rd);
				  check_data(rd, wr);
				  read_cov_data = rd; 
    	          router_dst.sample();
				  end
				 join_any
				 disable fork;
				
			 end
			end 
         join
		 
		 end
       endtask

      	

	  //Explore method check_data_data 
       task router_scoreboard::check_data(read_xtn r_data, write_xtn w_data);
             if(r_data.header==w_data.header)
				$display("-----------------------HEADER:SUCCESSFULLY MATCHED------------------------");
			 else
			 begin
				$display("-----------------------HEADER:FAILED MATCHED------------------------");
				end
			 if(r_data.payload_data==w_data.payload_data)
        			 $display("-----------------------PAYLOAD:SUCCESSFULLY MATCHED------------------------");
			 else
			 begin
					 $display("----------------------- PAYLOAD:MISMATCHED------------------------");
					 end
			 if(r_data.parity==w_data.parity)
        			 $display("-----------------------PARITY:SUCCESSFULLY MATCHED------------------------");
			 else
			 begin
					 $display("----------------------- PARITY:MISMATCHED------------------------");
					 end
			
	endtask


   /* function void router_scoreboard::report_phase(uvm_phase phase);
   // Displays the final report of test using scoreboard stistics
   `uvm_info(get_type_name(), $sformatf("MSTB: Simulation Report from ScoreBoard \n Number of Read Transactions from Read agt_top : %0d \n Number of Write Transactions from write agt_top : %0d \n Number of Read Transactions Dropped : %0d \n Number of Read Transactions compared : %0d \n\n",rd_xtns_in, wr_xtns_in, xtns_dropped, xtns_compared), UVM_LOW)
 endfunction */