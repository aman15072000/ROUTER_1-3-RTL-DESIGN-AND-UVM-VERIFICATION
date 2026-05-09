	class router_test extends uvm_test;

   // Factory Registration
	`uvm_component_utils(router_test)

  
         // Handles for router_env & router_env_config
    	 router_env env;
         router_env_config e_cfg;

         // LAB : Declare dynamic array of handles for router_wr_agt_config & router_rd_agt_config 
         //as wcfg[] & rcfg[]
        router_wr_agt_config wcfg[];
        router_rd_agt_config rcfg[];

	// Declare no_of_duts, has_ragent, has_wagent as int which are local
	// variables to this test class

          bit has_ragent=1;
          bit has_wagent=1;

         int no_of_read_agent = 3;
         int no_of_write_agent = 1;

//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
	extern function new(string name = "router_test" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void config_router();
        endclass

//-----------------  constructor new method  -------------------//
 // Define Constructor new() function
   	function router_test::new(string name = "router_test" , uvm_component parent);
		super.new(name,parent);
	endfunction

//-----------------  build() phase method  -------------------//

	function void router_test::build_phase(uvm_phase phase);
		// call super.build()
     		super.build();

                // create the config object using uvm_config_db 
	        e_cfg=router_env_config::type_id::create("e_cfg");
                if(has_wagent)
		// initialize the dynamic array of handles e_cfg.m_wr_agt_cfg & e_cfg.m_rd_agt_cfg to no_of_duts
                e_cfg.wr_agt_cfg = new[no_of_write_agent];

                if(has_ragent)
		// LAB :  initialize the dynamic array of handles for router_rd_agt_config equal to no_of_duts
                e_cfg.rd_agt_cfg = new[no_of_read_agent];

                // Call function config_router which configures all the paroutereters
                config_router(); 

		// set the env config object into UVM config DB  
	 	uvm_config_db #(router_env_config)::set(this,"*","router_env_config",e_cfg);

            uvm_top.print_topology();

		// create the instance for env handle
		env=router_env::type_id::create("env", this);
	endfunction



//----------------- function config_router()  -------------------//

	function void router_test::config_router();
 	   if (has_wagent) 
                begin
		// initialize the dynamic array of handles for router_wr_agt_config equal to no_of_write_agent
                wcfg = new[no_of_write_agent];
	
	        foreach(wcfg[i]) 
                    begin
      		// create the instance for router_wr_agt_config
                wcfg[i]=router_wr_agt_config::type_id::create($sformatf("wcfg[%0d]", i));
         	// for all the configuration objects, set the following paroutereters 
		// is_active to UVM_ACTIVE
		// Get the virtual interface from the config database
	  if(!uvm_config_db #(virtual router_if)::get(this,"","vif",wcfg[i].vif))
		`uvm_fatal("VIF CONFIG- WRITE","cannot get()interface vif from uvm_config_db. Have you set() it?") 

                wcfg[i].is_active = UVM_ACTIVE;

		// assign the router_wr_agt_config handle to the enviornment
                e_cfg.wr_agt_cfg[i] = wcfg[i];
                
                end
             end
		// read config object
 	   if (has_ragent) 
                begin
		// initialize the dynamic array of handles for router_rd_agt_config equal to no_of_read_agent
                rcfg = new[no_of_read_agent];
	
	        foreach(rcfg[i]) 
                    begin
      		// create the instance for router_rd_agt_config
                rcfg[i]=router_rd_agt_config::type_id::create($sformatf("rcfg[%0d]", i));
         	// for all the configuration objects, set the following paroutereters 
		// is_active to UVM_ACTIVE
		// Get the virtual interface from the config database
	  if(!uvm_config_db #(virtual router_if)::get(this,"", $sformatf("vif_%0d",i),rcfg[i].vif))
		`uvm_fatal("VIF CONFIG-READ","cannot get()interface vif from uvm_config_db. Have you set() it?") 

                rcfg[i].is_active = UVM_ACTIVE;

		// assign the router_wr_agt_config handle to the enviornment
                e_cfg.rd_agt_cfg[i] = rcfg[i];
                
                end
             end

                e_cfg.no_of_read_agent = no_of_read_agent;
                e_cfg.no_of_write_agent = no_of_write_agent;
                e_cfg.has_ragent = has_ragent;
                e_cfg.has_wagent = has_wagent;
            endfunction : config_router



	


//------------------------------------------
// CLASS DESCRIPTION
//------------------------------------------

   // Extend router_small_pkt_test from  router_test
	class router_small_pkt_test extends router_test;

  
   // Factory Registration
	`uvm_component_utils(router_small_pkt_test)

   // Declare the handle for  router_small_pkt virtual sequence
         //router_wxtns_small_pkt router_seqh;
		 //router_rxtns1 rd_seqh;
        // router_rxtns1 normal_seqh;
         router_small_pkt_vseq router_seqh;

//------------------------------------------
// METHODS
//------------------------------------------
             bit [1:0] addr;

// Standard UVM Methods:
 	extern function new(string name = "router_small_pkt_test" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

//-----------------  constructor new method  -------------------//

 // Define Constructor new() function
   	function router_small_pkt_test::new(string name = "router_small_pkt_test" , uvm_component parent);
		super.new(name,parent);
	endfunction


//-----------------  build() phase method  -------------------//
            
	function void router_small_pkt_test::build_phase(uvm_phase phase);
            super.build_phase(phase);
	endfunction


//-----------------  run() phase method  -------------------//
      	task router_small_pkt_test::run_phase(uvm_phase phase);
 //raise objection
         phase.raise_objection(this);
		
             begin
               //addr = {$random}%3;
			   addr = 2'b00;
               uvm_config_db #(bit[1:0])::set(this,"*","bit[1:0]",addr);

 //create instance for sequence
         // router_seqh=router_wxtns_small_pkt::type_id::create("router_seqh"); ////////////
          router_seqh=router_small_pkt_vseq::type_id::create("router_seqh");
		  //rd_seqh=router_rxtns1::type_id::create("rd_seqh"); ////////////
		  
		 /* fork
          router_seqh.start(env.wagt_top.agnth[0].seqrh);
          rd_seqh.start(env.ragt_top.agnth[addr].seqrh);
          join	*/	  
        //  normal_seqh=router_rxtns1::type_id::create("normal_seqh") ;   /////////////   
////////////
 //start the sequence wrt virtual sequencer////////////
//fork//////////////
//router_seqh.start()/////////
 //join////////////////
         //router_seqh.start(env.v_sequencer);////////////
          router_seqh.start(env.v_sequencer);///////////
         end
 //drop objection
         phase.drop_objection(this);
	endtask   
	
	

// CLASS DESCRIPTION
//------------------------------------------

   // Extend router_small_pkt_test from  router_test
	class router_small00_pkt_test extends router_test;
	`uvm_component_utils(router_small00_pkt_test)
         router_small_pkt_vseq router_seqh;
             bit [1:0] addr;

// Standard UVM Methods:
 	extern function new(string name = "router_small00_pkt_test" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

//-----------------  constructor new method  -------------------//

 // Define Constructor new() function
   	function router_small00_pkt_test::new(string name = "router_small00_pkt_test" , uvm_component parent);
		super.new(name,parent);
	endfunction


//-----------------  build() phase method  -------------------//
            
	function void router_small00_pkt_test::build_phase(uvm_phase phase);
            super.build_phase(phase);
	endfunction


//-----------------  run() phase method  -------------------//
      	task router_small00_pkt_test::run_phase(uvm_phase phase);
         phase.raise_objection(this);		
             begin
                //addr = {$random}%3;
			   addr = 2'b01;
               uvm_config_db #(bit[1:0])::set(this,"*","bit[1:0]",addr);
          router_seqh=router_small_pkt_vseq::type_id::create("router_seqh");
          router_seqh.start(env.v_sequencer);///////////
         end
         phase.drop_objection(this);
	endtask
	
	
	
	// CLASS DESCRIPTION
//------------------------------------------

   // Extend router_small_pkt_test from  router_test
	class router_small01_pkt_test extends router_test;
	`uvm_component_utils(router_small01_pkt_test)
         router_small_pkt_vseq router_seqh;
             bit [1:0] addr;

// Standard UVM Methods:
 	extern function new(string name = "router_small01_pkt_test" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

//-----------------  constructor new method  -------------------//

 // Define Constructor new() function
   	function router_small01_pkt_test::new(string name = "router_small01_pkt_test" , uvm_component parent);
		super.new(name,parent);
	endfunction


//-----------------  build() phase method  -------------------//
            
	function void router_small01_pkt_test::build_phase(uvm_phase phase);
            super.build_phase(phase);
	endfunction


//-----------------  run() phase method  -------------------//
      	task router_small01_pkt_test::run_phase(uvm_phase phase);
         phase.raise_objection(this);		
             begin
               //addr = {$random}%3;
			   addr = 2'b10;
               uvm_config_db #(bit[1:0])::set(this,"*","bit[1:0]",addr);
          router_seqh=router_small_pkt_vseq::type_id::create("router_seqh");
          router_seqh.start(env.v_sequencer);///////////
         end
         phase.drop_objection(this);
	endtask
	
	
	


//------------------------------------------
// CLASS DESCRIPTION
//------------------------------------------

   // Extend router_medium_test from router_test
	class router_medium_pkt_test extends router_test;

  
   // Factory Registration
	`uvm_component_utils(router_medium_pkt_test)

   // Declare the handle for  router_medium_pkt virtual sequence
         //router_wxtns_medium_pkt router_seqh;
		 router_medium_pkt_vseq router_seqh;
//------------------------------------------
// METHODS
//------------------------------------------
             bit [1:0] addr;

// Standard UVM Methods:
 	extern function new(string name = "router_medium_pkt_test" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

//-----------------  constructor new method  -------------------//

 // Define Constructor new() function
   	function router_medium_pkt_test::new(string name = "router_medium_pkt_test" , uvm_component parent);
		super.new(name,parent);
	endfunction


//-----------------  build() phase method  -------------------//
            
	function void router_medium_pkt_test::build_phase(uvm_phase phase);
            super.build_phase(phase);
	endfunction


//-----------------  run() phase method  -------------------//
      	task router_medium_pkt_test::run_phase(uvm_phase phase);
 //raise objection
         phase.raise_objection(this);
		
             begin
              //addr = {$random}%3;
			   addr = 2'b00;
               uvm_config_db #(bit[1:0])::set(this,"*","bit[1:0]",addr);

 //create instance for sequence
          //router_seqh=router_wxtns_medium_pkt::type_id::create("router_seqh");
		  router_seqh=router_medium_pkt_vseq::type_id::create("router_seqh");
          //router_seqh.start(env.wagt_top.agnth[0].seqrh);
            router_seqh.start(env.v_sequencer);
 //start the sequence wrt virtual sequencer
        // router_seqh.start(env.v_sequencer);
 end
 //drop objection
         phase.drop_objection(this);
	endtask   
	
	
	
	//------------------------------------------
// CLASS DESCRIPTION
//------------------------------------------

   // Extend router_medium_test from router_test
	class router_medium00_pkt_test extends router_test;
	`uvm_component_utils(router_medium00_pkt_test)
		 router_medium_pkt_vseq router_seqh;
             bit [1:0] addr;
 	extern function new(string name = "router_medium00_pkt_test" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass
//-----------------  constructor new method  -------------------//
   	function router_medium00_pkt_test::new(string name = "router_medium00_pkt_test" , uvm_component parent);
		super.new(name,parent);
	endfunction
//-----------------  build() phase method  -------------------//          
	function void router_medium00_pkt_test::build_phase(uvm_phase phase);
            super.build_phase(phase);
	endfunction
//-----------------  run() phase method  -------------------//
      	task router_medium00_pkt_test::run_phase(uvm_phase phase);

         phase.raise_objection(this);		
             begin
              //addr = {$random}%3;
			   addr = 2'b01;
               uvm_config_db #(bit[1:0])::set(this,"*","bit[1:0]",addr);
		  router_seqh=router_medium_pkt_vseq::type_id::create("router_seqh");
            router_seqh.start(env.v_sequencer);
 end
         phase.drop_objection(this);
	endtask  


	//------------------------------------------
// CLASS DESCRIPTION
//------------------------------------------

   // Extend router_medium_test from router_test
	class router_medium01_pkt_test extends router_test;
	`uvm_component_utils(router_medium01_pkt_test)
		 router_medium_pkt_vseq router_seqh;
             bit [1:0] addr;
 	extern function new(string name = "router_medium01_pkt_test" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass
//-----------------  constructor new method  -------------------//
   	function router_medium01_pkt_test::new(string name = "router_medium01_pkt_test" , uvm_component parent);
		super.new(name,parent);
	endfunction
//-----------------  build() phase method  -------------------//          
	function void router_medium01_pkt_test::build_phase(uvm_phase phase);
            super.build_phase(phase);
	endfunction
//-----------------  run() phase method  -------------------//
      	task router_medium01_pkt_test::run_phase(uvm_phase phase);

         phase.raise_objection(this);		
             begin
              //addr = {$random}%3;
			   addr = 2'b10;
               uvm_config_db #(bit[1:0])::set(this,"*","bit[1:0]",addr);
		  router_seqh=router_medium_pkt_vseq::type_id::create("router_seqh");
            router_seqh.start(env.v_sequencer);
 end
         phase.drop_objection(this);
	endtask


//------------------------------------------
// CLASS DESCRIPTION
//------------------------------------------

	class router_big_pkt_test extends router_test;

  
   // Factory Registration
	`uvm_component_utils(router_big_pkt_test)

   // Declare the handle for  router_big_pkt virtual sequence
         //router_wxtns_big_pkt router_seqh;
		 router_big_pkt_vseq router_seqh;
//------------------------------------------
// METHODS
//------------------------------------------
             bit [1:0] addr;

// Standard UVM Methods:
 	extern function new(string name = "router_big_pkt_test" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

//-----------------  constructor new method  -------------------//

 // Define Constructor new() function
   	function router_big_pkt_test::new(string name = "router_big_pkt_test" , uvm_component parent);
		super.new(name,parent);
	endfunction


//-----------------  build() phase method  -------------------//
            
	function void router_big_pkt_test::build_phase(uvm_phase phase);
            super.build_phase(phase);
	endfunction


//-----------------  run() phase method  -------------------//
      	task router_big_pkt_test::run_phase(uvm_phase phase); 
 //raise objection
         phase.raise_objection(this);
		
             begin
              //addr = {$random}%3;
			   addr = 2'b00;
               uvm_config_db #(bit[1:0])::set(this,"*","bit[1:0]",addr);

 //create instance for sequence
          //router_seqh=router_wxtns_big_pkt::type_id::create("router_seqh");
		  router_seqh=router_big_pkt_vseq::type_id::create("router_seqh");
          //router_seqh.start(env.wagt_top.agnth[0].seqrh);
           router_seqh.start(env.v_sequencer);
 //start the sequence wrt virtual sequencer
       //   router_seqh.start(env.v_sequencer);
end
 //drop objection
         phase.drop_objection(this);
	endtask   


//------------------------------------------
// CLASS DESCRIPTION
//------------------------------------------

	class router_big00_pkt_test extends router_test;
	`uvm_component_utils(router_big00_pkt_test)
		 router_big_pkt_vseq router_seqh;
             bit [1:0] addr;
 	extern function new(string name = "router_big00_pkt_test" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass
//-----------------  constructor new method  -------------------//
   	function router_big00_pkt_test::new(string name = "router_big00_pkt_test" , uvm_component parent);
		super.new(name,parent);
	endfunction
//-----------------  build() phase method  -------------------//           
	function void router_big00_pkt_test::build_phase(uvm_phase phase);
            super.build_phase(phase);
	endfunction
//-----------------  run() phase method  -------------------//
      	task router_big00_pkt_test::run_phase(uvm_phase phase); 
         phase.raise_objection(this);		
             begin
              //addr = {$random}%3;
			   addr = 2'b01;
               uvm_config_db #(bit[1:0])::set(this,"*","bit[1:0]",addr);
		  router_seqh=router_big_pkt_vseq::type_id::create("router_seqh");

           router_seqh.start(env.v_sequencer);
end
         phase.drop_objection(this);
	endtask   



// CLASS DESCRIPTION
//------------------------------------------

	class router_big01_pkt_test extends router_test;
	`uvm_component_utils(router_big01_pkt_test)
		 router_big_pkt_vseq router_seqh;
             bit [1:0] addr;
 	extern function new(string name = "router_big01_pkt_test" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass
//-----------------  constructor new method  -------------------//
   	function router_big01_pkt_test::new(string name = "router_big01_pkt_test" , uvm_component parent);
		super.new(name,parent);
	endfunction
//-----------------  build() phase method  -------------------//           
	function void router_big01_pkt_test::build_phase(uvm_phase phase);
            super.build_phase(phase);
	endfunction
//-----------------  run() phase method  -------------------//
      	task router_big01_pkt_test::run_phase(uvm_phase phase); 
         phase.raise_objection(this);		
             begin
              //addr = {$random}%3;
			   addr = 2'b10;
               uvm_config_db #(bit[1:0])::set(this,"*","bit[1:0]",addr);
		  router_seqh=router_big_pkt_vseq::type_id::create("router_seqh");

           router_seqh.start(env.v_sequencer);
end
         phase.drop_objection(this);
	endtask  

