class write_xtn extends uvm_sequence_item;
  
	// UVM Factory Registration Macro
	`uvm_object_utils(write_xtn)

	//------------------------------------------
	// header MEMBERS (Outputs non-rand, inputs rand)
	//------------------------------------------

	 
		
	// Add the rand fields - header (7:0), payload_data[](7:0),declared in tb_defs.sv
	// write (type bit) 

	rand bit[7:0] header;   //[1:0]addresss 
	rand bit[7:0] payload_data[];  //header will decide the payload length from header[7:2]
	bit [7:0]parity;
        bit err;

  	//------------------------------------------
	// CONSTRAINTS
	//------------------------------------------
	 

	constraint c1{header[1:0] != 3;} //for not getting 'd3
	constraint c2{payload_data.size==header[7:2];} //for p[ayload size decided by header [7:2]
	constraint c3{payload_data.size!=0;} //for payload_data should not be equal to zero

		    
	//------------------------------------------
	// METHODS
	//------------------------------------------

	// Standard UVM Methods like constructor,do_print,post_randomize
	extern function new(string name = "write_xtn");
	extern function void post_randomize();
	extern function void do_print(uvm_printer printer);

endclass:write_xtn

	//-----------------  constructor new method  -------------------//
	//Add code for new()

function write_xtn::new(string name = "write_xtn");
	super.new(name);
endfunction:new


function void write_xtn::post_randomize(); //to calculate parity
    parity=0^header;
        foreach(payload_data[i])
              begin
                  parity=parity^payload_data[i];
               end
endfunction : post_randomize


//-----------------  do_print method  -------------------//

function void  write_xtn::do_print (uvm_printer printer);
	super.do_print(printer);

   
    //              	  srting name   		        bitstream value            size            radix for printing
    printer.print_field( "header", 			          this.header, 	    	    8,		        UVM_BIN		);
    foreach(payload_data[i])
                begin
    printer.print_field( $sformatf("payload_data[0%d]",i),        this.payload_data[i],     8,		        UVM_DEC		);
                 end
    printer.print_field( "parity", 			          this.parity, 	            8,		        UVM_DEC		);

endfunction:do_print
    

    

