	class router_env extends uvm_env;

        
        // Factory Registration
     	`uvm_component_utils(router_env)

	
	// LAB : Declare dynamic array of handles for router_wr_agt_top, router_rd_agt_top  as wagt_top,ragt_top and respectively
	router_wr_agt_top wagt_top;
        router_rd_agt_top ragt_top;
	
// Declare handle for router_virtual_sequencer as  v_sequencer
		router_virtual_sequencer v_sequencer;

// LAB :  Declare dynamic array of handles for router scoreboard as sb
		router_scoreboard sb;

// Declare handle for router_env_config class as m_cfg
                router_env_config m_cfg;
//------------------------------------------
// Methods
//------------------------------------------

// Standard UVM Methods:
extern function new(string name = "router_env", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);

endclass: router_env
	
//-----------------  constructor new method  -------------------//
// Define Constructor new() function
	function router_env::new(string name = "router_env", uvm_component parent);
		super.new(name,parent);
	endfunction

//-----------------  build phase method  -------------------//

        	function void router_env::build_phase(uvm_phase phase);
        	super.build_phase(phase);

	//get configuration object router_env_config from database using uvm_config_db() 
	  if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",m_cfg))
		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")

                if(m_cfg.has_wagent) 
                        begin
		// LAB :Create the instances of wagt_top handles
                wagt_top=router_wr_agt_top::type_id::create("wagt_top",this);	          

              end

                if(m_cfg.has_ragent) 
                          begin
		// LAB : Create the instances of ragt_top[i]
                ragt_top=router_rd_agt_top::type_id::create("ragt_top",this);	
                end

               if(m_cfg.has_virtual_sequencer)
	// Create the instance of v_sequencer handle 
                   begin
	                v_sequencer=router_virtual_sequencer::type_id::create("v_sequencer",this);
                   end

               if(m_cfg.has_scoreboard)
                        begin
	// LAB : Create the instances of router_scoreboard
                sb=router_scoreboard::type_id::create("sb",this);	          
               end 

		endfunction

///-----------------  connect phase method  -------------------//
	// In connect phase
	    // Connect virtual sequencer's sub sequencers to the envirnoment's
	    // write & read sequencers
	    	//  Inside a foreach loops for *agt_top[i]
		// Hint : v_sequencer.wr_seqrh[i] = wagt_top[i].agnth
		// 	  v_sequencer.rd_seqrh[i] = ragt_top[i].agnth
 
   		function void router_env::connect_phase(uvm_phase phase);
                      if(m_cfg.has_virtual_sequencer) 
                        begin
					  
                        if(m_cfg.has_wagent)
                                        begin
										  for(int i=0; i<m_cfg.no_of_write_agent;i++)
										    begin
                                              v_sequencer.wr_seqrh[i] = wagt_top.agnth[i].seqrh;
                                           end
										end
                        if(m_cfg.has_ragent)
                                       begin
										  for(int i=0; i<m_cfg.no_of_read_agent;i++)
										    begin
                                              v_sequencer.rd_seqrh[i] = ragt_top.agnth[i].seqrh;
                                           end
										end

                      end
       

   		     if(m_cfg.has_scoreboard) 
                                        begin
										  for(int i=0; i<m_cfg.no_of_write_agent;i++)
										    begin
                                              wagt_top.agnth[i].monh.monitor_port.connect(sb.fifo_wrh[i].analysis_export);
                                              //v_sequencer.wr_seqrh[i] = wagt_top.agnth[i].seqrh;
                                           end
										end
                                          //wagt_top.agnth[i].monh.monitor_port.connect(sb.fifo_wrh.analysis_export);
                                        begin
										  for(int i=0; i<m_cfg.no_of_read_agent;i++)
										    begin
                                              ragt_top.agnth[i].monh.monitor_port.connect(sb.fifo_rdh[i].analysis_export);
					                        end
										end
			endfunction


