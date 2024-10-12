package FIFO_test_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import FIFO_sequence_item_pkg::*;
import FIFO_sequence_pkg::*;
import FIFO_env_pkg::*;
import FIFO_config_obj_pkg::*;

class FIFO_test extends uvm_test;
`uvm_component_utils(FIFO_test)

FIFO_config_obj FIFO_cfg;
FIFO_env env;
FIFO_reset_sequence rst_seq;
FIFO_write_sequence wr_seq;
FIFO_read_sequence rd_seq;
FIFO_write_read_sequence wr_rd_seq;

function new (string name = "FIFO_test" , uvm_component parent = null);
    super.new(name,parent);
endfunction

function void build_phase (uvm_phase phase);
super.build_phase(phase);
env = FIFO_env::type_id::create("env",this);
FIFO_cfg = FIFO_config_obj::type_id::create("FIFO_cfg");
wr_seq = FIFO_write_sequence::type_id::create("wr_seq");
rd_seq = FIFO_read_sequence::type_id::create("rd_seq");
wr_rd_seq = FIFO_write_read_sequence::type_id::create("wr_rd_seq");
rst_seq = FIFO_reset_sequence::type_id::create("rst_seq");

if(! uvm_config_db #(virtual FIFO_Interface)::get(this,"","FIFO_IF",FIFO_cfg.FIFO_vif)) begin
    `uvm_fatal("build_phase","Test faild to get the virtual interface from configuration database");
end

uvm_config_db #(FIFO_config_obj)::set(this , "*" , "cfg" ,FIFO_cfg);

endfunction

task run_phase(uvm_phase phase);
super.run_phase(phase);
phase.raise_objection(this);

// Reset Sequence //
`uvm_info("run_phase","Reset Asserted",UVM_LOW);
rst_seq.start(env.agent.sqr);
`uvm_info("run_phase","Reset Deasserted",UVM_LOW);

// Write Read Sequence  // 
`uvm_info("run_phase","Write Read Sequence has Started",UVM_LOW);
wr_rd_seq.start(env.agent.sqr);
`uvm_info("run_phase","Write Read Sequence has Ended",UVM_LOW);

// Write only Sequence //
`uvm_info("run_phase","Write only Sequence has Started",UVM_LOW);
wr_seq.start(env.agent.sqr);
`uvm_info("run_phase","Write only Sequence has Ended",UVM_LOW);

// Read only Sequence //
`uvm_info("run_phase","Read only Sequence has Started",UVM_LOW);
rd_seq.start(env.agent.sqr);
`uvm_info("run_phase","Read only Sequence has Ended",UVM_LOW);

phase.drop_objection(this);


endtask



endclass

endpackage