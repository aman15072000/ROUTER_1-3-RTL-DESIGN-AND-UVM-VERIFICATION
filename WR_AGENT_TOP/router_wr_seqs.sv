class router_wr_seq extends uvm_sequence #(write_xtn);  
	
  // Factory registration using `uvm_object_utils

	`uvm_object_utils(router_wr_seq)  
	//------------------------------------------
	// METHODS
	//------------------------------------------

	// Standard UVM Methods:
    extern function new(string name ="router_wr_seq");
	
endclass

//-----------------  constructor new method  -------------------//
function router_wr_seq::new(string name ="router_wr_seq");
	super.new(name);
endfunction

//------------------------------------------------------------------------------
//
// SEQUENCE: Random Write Transactions - Use with write_rand_xtn  
//
//------------------------------------------------------------------------------


//------------------------------------------
// CLASS DESCRIPTION
//------------------------------------------


//Extend router_wxtns_small_pkt from router_wr_seq;
class router_wxtns_small_pkt extends router_wr_seq;

  	// Factory registration using `uvm_object_utils
	`uvm_object_utils(router_wxtns_small_pkt)

         bit [1:0]addr;
	//------------------------------------------
	// METHODS
	//------------------------------i------------

	// Standard UVM Methods:
    extern function new(string name ="router_wxtns_small_pkt");
    extern task body();
	
endclass
//-----------------  constructor new method  -------------------//
function router_wxtns_small_pkt::new(string name = "router_wxtns_small_pkt");
	super.new(name);
endfunction

//-----------------  task body method  -------------------//
//Generate 10 transactions of type write_xtn 
//create req instance
//start_item(req)
//assert for randomization
//finish_item(req)

task router_wxtns_small_pkt::body();
 if(!uvm_config_db #(bit[1:0])::get(null,get_full_name,"bit[1:0]",addr))  //getting from test class
      `uvm_fatal(get_full_name(),"cannot get() addr from uvm_config_db. Have you set() it?")

		req=write_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {header [7:2] inside {[6:16]} && header[1:0]==addr;});
              `uvm_info("ROUTR_WR_SEQUENCE", $sformatf("printing from sequence \n %s", req.sprint()), UVM_HIGH)
		finish_item(req); 

endtask


// CLASS DESCRIPTION
//------------------------------------------


class router_wxtns_medium_pkt extends router_wr_seq;

  	// Factory registration using `uvm_object_utils
	`uvm_object_utils(router_wxtns_medium_pkt)

         bit [1:0]addr;
	//------------------------------------------
	// METHODS
	//------------------------------i------------

	// Standard UVM Methods:
    extern function new(string name ="router_wxtns_medium_pkt");
    extern task body();
	
endclass
//-----------------  constructor new method  -------------------//
function router_wxtns_medium_pkt::new(string name = "router_wxtns_medium_pkt");
	super.new(name);
endfunction

//-----------------  task body method  -------------------//
//Generate 10 transactions of type write_xtn 
//create req instance
//start_item(req)
//assert for randomization
//finish_item(req)

task router_wxtns_medium_pkt::body();
 if(!uvm_config_db #(bit[1:0])::get(null,get_full_name,"bit[1:0]",addr))  //getting from test class
      `uvm_fatal(get_full_name(),"cannot get() addr from uvm_config_db. Have you set() it?")

		req=write_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {header [7:2] inside {[16:30]} && header[1:0]==addr;});
              `uvm_info("ROUTR_WR_SEQUENCE", $sformatf("printing from sequence \n %s", req.sprint()), UVM_HIGH)
		finish_item(req); 
		
	
endtask


//------------------------------------------
// CLASS DESCRIPTION
//------------------------------------------


class router_wxtns_big_pkt extends router_wr_seq;

  	// Factory registration using `uvm_object_utils
	`uvm_object_utils(router_wxtns_big_pkt)

         bit [1:0]addr;
	//------------------------------------------
	// METHODS
	//------------------------------i------------

	// Standard UVM Methods:
    extern function new(string name ="router_wxtns_big_pkt");
    extern task body();
	
endclass
//-----------------  constructor new method  -------------------//
function router_wxtns_big_pkt::new(string name = "router_wxtns_big_pkt");
	super.new(name);
endfunction

//-----------------  task body method  -------------------//
//Generate 10 transactions of type write_xtn 
//create req instance
//start_item(req)
//assert for randomization
//finish_item(req)

task router_wxtns_big_pkt::body();
 if(!uvm_config_db #(bit[1:0])::get(null,get_full_name,"bit[1:0]",addr))  //getting from test class
      `uvm_fatal(get_full_name(),"cannot get() addr from uvm_config_db. Have you set() it?")

		req=write_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {header [7:2] inside {[31:63]} && header[1:0]==addr;});
              `uvm_info("ROUTR_WR_SEQUENCE", $sformatf("printing from sequence \n %s", req.sprint()), UVM_HIGH)
		finish_item(req); 

	
endtask
