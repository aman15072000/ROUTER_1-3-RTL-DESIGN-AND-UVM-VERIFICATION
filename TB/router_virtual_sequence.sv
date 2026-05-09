class router_virtual_sequence extends uvm_sequence #(uvm_sequence_item);

	
  // Factory registration
	`uvm_object_utils(router_virtual_sequence)  
  // LAB : Declare dynamic array of handles for router_wr_sequencer and router_rd_sequencer as wr_seqrh[] & rd_seqrh[]
                     router_wr_sequencer wr_seqrh[];
                     router_rd_sequencer rd_seqrh[];

  // Declare handle for virtual sequencer
        router_virtual_sequencer vsqrh;
  // Declare Handles for all the sequences
/*	router_single_addr_wr_xtns wrtns;
	router_single_addr_rd_xtns single_rxtns;

	router_ten_wr_xtns ten_wxtns;
	router_ten_rd_xtns ten_rxtns;

	router_even_wr_xtns even_wxtns;
	router_even_rd_xtns even_rxtns;

	router_odd_wr_xtns odd_wxtns;
	router_odd_rd_xtns odd_rxtns;*/

  // LAB :  Declare handle for router_env_config
	   router_env_config m_cfg;



//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
 	extern function new(string name = "router_virtual_sequence");
	extern task body();
	endclass : router_virtual_sequence  
//-----------------  constructor new method  -------------------//

// Add constructor 
	function router_virtual_sequence::new(string name ="router_virtual_sequence");
		super.new(name);
	endfunction
//--------------------task body()------------------//
task router_virtual_sequence::body();
// get the config object router_env_config from database using uvm_config_db 
	  if(!uvm_config_db #(router_env_config)::get(null, get_full_name(), "router_env_config",m_cfg))
         `uvm_fatal("CONFIG", "cannot get() m_cfg from  uvm_config_db. Have you set() it?")
// initialize the dynamic arrays for write & read sequencers to m_cfg.no_of_agent
         wr_seqrh = new[m_cfg.no_of_write_agent];
         rd_seqrh = new[m_cfg.no_of_read_agent];
  

  assert($cast(vsqrh,m_sequencer)) 
    else 
	    begin
           `uvm_error("BODY", "Error in $cast of virtual sequencer")
  end
// Assign router_wr_sequencer & router_rd_sequencer handles to virtual sequencer's 
// router_wr_sequencer & router_rd_sequencer handles
// Hint : use foreach loop
         foreach(wr_seqrh[i])
               wr_seqrh[i]=vsqrh.wr_seqrh[i];
         foreach(rd_seqrh[i])
               rd_seqrh[i]=vsqrh.rd_seqrh[i];
endtask: body

//------------------------------------------------------------------------------
//               small packet sequence

//------------------------------------------------------------------------------
// Extend router_small_pkt_vseq from router_virtual_sequence
	class router_small_pkt_vseq extends router_virtual_sequence;

     // Define Constructor new() function
	`uvm_object_utils(router_small_pkt_vseq)
          bit [1:0] addr;
		  router_wxtns_small_pkt wrtns;
		  router_rxtns1 rdtns;
//--------------1----------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
 	extern function new(string name = "router_small_pkt_vseq");
	extern task body();
	endclass : router_small_pkt_vseq  
//-----------------  constructor new method  -------------------//

// Add constructor 
	function router_small_pkt_vseq::new(string name ="router_small_pkt_vseq");
		super.new(name);
	endfunction
//-----------------  task body() method  -------------------//

		task router_small_pkt_vseq::body();
                 super.body();
				 
				 if(!uvm_config_db #(bit [1:0])::get(null,get_full_name(),"bit[1:0]", addr))
				        `uvm_fatal(get_full_name(), "Cannot get() addr from uvm_config_db. Have you set() it?")
                 // LAB : create the instances for router_single_addr_wr_xtns & router_single_addr_rd_xtns
                           // single_rxtns=router_single_addr_rd_xtns::type_id::create("single_rxtns");                 

                    if(m_cfg.has_wagent) 
					  begin
                            wrtns=router_wxtns_small_pkt::type_id::create("wrtns");
                       end

                   if(m_cfg.has_ragent) 
				     begin
                            rdtns=router_rxtns1::type_id::create("rdtns");
                    end 

          fork
		        begin
				     wrtns.start(wr_seqrh[0]);
			    end 
				     begin 
					     if(addr==2'b00)
						     rdtns.start(rd_seqrh[0]);
					     if(addr==2'b01)
						     rdtns.start(rd_seqrh[1]);
					     if(addr==2'b10)
						     rdtns.start(rd_seqrh[2]);
                    end							 
		  join
       endtask

//------------------------------------------------------------------------------
//                medium packet sequence

//------------------------------------------------------------------------------
// Extend router_small_pkt_vseq from router_virtual_sequence
	class router_medium_pkt_vseq extends router_virtual_sequence;

     // Define Constructor new() function
	`uvm_object_utils(router_medium_pkt_vseq)
          bit [1:0] addr;
		  router_wxtns_medium_pkt wrtns;
		  router_rxtns1 rdtns;
//--------------1----------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
 	extern function new(string name = "router_medium_pkt_vseq");
	extern task body();
	endclass : router_medium_pkt_vseq  
//-----------------  constructor new method  -------------------//

// Add constructor 
	function router_medium_pkt_vseq::new(string name ="router_medium_pkt_vseq");
		super.new(name);
	endfunction
//-----------------  task body() method  -------------------//

		task router_medium_pkt_vseq::body();
                 super.body();
				 
				 if(!uvm_config_db #(bit [1:0])::get(null,get_full_name(),"bit[1:0]", addr))
				        `uvm_fatal(get_full_name(), "Cannot get() addr from uvm_config_db. Have you set() it?")
                 // LAB : create the instances for router_single_addr_wr_xtns & router_single_addr_rd_xtns
                           // single_rxtns=router_single_addr_rd_xtns::type_id::create("single_rxtns");                 

                    if(m_cfg.has_wagent) 
					  begin
                            wrtns=router_wxtns_medium_pkt::type_id::create("wrtns");
                       end

                   if(m_cfg.has_ragent) 
				     begin
                            rdtns=router_rxtns1::type_id::create("rdtns");
                    end 

          fork
		        begin
				     wrtns.start(wr_seqrh[0]);
			    end 
				     begin 
					     if(addr==2'b00)
						     rdtns.start(rd_seqrh[0]);
					     if(addr==2'b01)
						     rdtns.start(rd_seqrh[1]);
					     if(addr==2'b10)
						     rdtns.start(rd_seqrh[2]);
                    end							 
		  join
       endtask
	   
	   
//------------------------------------------------------------------------------
//                big packet sequence

//------------------------------------------------------------------------------
// Extend router_small_pkt_vseq from router_virtual_sequence
	class router_big_pkt_vseq extends router_virtual_sequence;

     // Define Constructor new() function
	`uvm_object_utils(router_big_pkt_vseq)
          bit [1:0] addr;
		  router_wxtns_big_pkt wrtns;
		  router_rxtns1 rdtns;
//--------------1----------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
 	extern function new(string name = "router_big_pkt_vseq");
	extern task body();
	endclass : router_big_pkt_vseq  
//-----------------  constructor new method  -------------------//

// Add constructor 
	function router_big_pkt_vseq::new(string name ="router_big_pkt_vseq");
		super.new(name);
	endfunction
//-----------------  task body() method  -------------------//

		task router_big_pkt_vseq::body();
                 super.body();
				 
				 if(!uvm_config_db #(bit [1:0])::get(null,get_full_name(),"bit[1:0]", addr))
				        `uvm_fatal(get_full_name(), "Cannot get() addr from uvm_config_db. Have you set() it?")
                 // LAB : create the instances for router_single_addr_wr_xtns & router_single_addr_rd_xtns
                            //single_rxtns=router_single_addr_rd_xtns::type_id::create("single_rxtns");                 

                    if(m_cfg.has_wagent) 
					  begin
                            wrtns=router_wxtns_big_pkt::type_id::create("wrtns");
                       end

                   if(m_cfg.has_ragent) 
				     begin
                            rdtns=router_rxtns1::type_id::create("rdtns");
                    end 

          fork
		        begin
				     wrtns.start(wr_seqrh[0]);
			    end 
				     begin 
					     if(addr==2'b00)
						     rdtns.start(rd_seqrh[0]);
					     if(addr==2'b01)
						     rdtns.start(rd_seqrh[1]);
					     if(addr==2'b10)
						     rdtns.start(rd_seqrh[2]);
                    end							 
		  join
       endtask
