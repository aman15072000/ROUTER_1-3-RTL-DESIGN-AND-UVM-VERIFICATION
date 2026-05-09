class router_rd_seq extends uvm_sequence #(read_xtn);  
	
  // Factory registration using `uvm_object_utils

	`uvm_object_utils(router_rd_seq)  
	//------------------------------------------
	// METHODS
	//------------------------------------------

	// Standard UVM Methods:
    extern function new(string name ="router_rd_seq");
	
endclass

//-----------------  constructor new method  -------------------//
function router_rd_seq::new(string name ="router_rd_seq");
	super.new(name);
endfunction

//------------------------------------------------------------------------------
//
// SEQUENCE: Random read Transactions - Use with read_rand_xtn  
//
//------------------------------------------------------------------------------


//------------------------------------------
// CLASS DESCRIPTION
//------------------------------------------


//Extend router_rxtns1 from router_rd_seq;
class router_rxtns1 extends router_rd_seq;

  	// Factory registration using `uvm_object_utils
	`uvm_object_utils(router_rxtns1)

         //bit [1:0]addr;
	//------------------------------------------
	// METHODS
	//------------------------------i------------

	// Standard UVM Methods:
    extern function new(string name ="router_rxtns1");
    extern task body();
	
endclass
//-----------------  constructor new method  -------------------//
function router_rxtns1::new(string name = "router_rxtns1");
	super.new(name);
endfunction

//-----------------  task body method  -------------------//
//Generate 10 transactions of type read_xtn 
//create req instance
//start_item(req)
//assert for randomization
//finish_item(req)

task router_rxtns1::body();

		req=read_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {no_of_cycles inside{[1:29]};});
              `uvm_info("ROUTR_RD_SEQUENCE", $sformatf("printing from sequence \n %s", req.sprint()), UVM_HIGH)
		finish_item(req); 	

endtask


// CLASS DESCRIPTION
//------------------------------------------


class router_rxtns2 extends router_rd_seq;

  	// Factory registration using `uvm_object_utils
	`uvm_object_utils(router_rxtns2)

         //bit [1:0]addr;
	//------------------------------------------
	// METHODS
	//------------------------------i------------

	// Standard UVM Methods:
    extern function new(string name ="router_rxtns2");
    extern task body();
	
endclass
//-----------------  constructor new method  -------------------//
function router_rxtns2::new(string name = "router_rxtns2");
	super.new(name);
endfunction

//-----------------  task body method  -------------------//
//Generate 10 transactions of type read_xtn 
//create req instance
//start_item(req)
//assert for randomization
//finish_item(req)

task router_rxtns2::body();

		req=read_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {no_of_cycles inside {[30:63]};});
              `uvm_info("ROUTR_RD_SEQUENCE", $sformatf("printing from sequence \n %s", req.sprint()), UVM_HIGH)
		finish_item(req);

endtask
