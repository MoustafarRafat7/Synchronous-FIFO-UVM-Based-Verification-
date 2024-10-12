package FIFO_driver_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import FIFO_sequence_item_pkg::*;

class FIFO_driver extends uvm_driver #(FIFO_sequence_item) ;
`uvm_component_utils(FIFO_driver)
FIFO_sequence_item driver_seq_item;
virtual FIFO_Interface FIFO_vif;

function new ( string name = "FIFO_driver" , uvm_component parent = null );

super.new(name,parent);

endfunction

task run_phase (uvm_phase phase);
super.run_phase(phase);
forever begin
    driver_seq_item = FIFO_sequence_item::type_id::create("driver_seq_item");
    seq_item_port.get_next_item(driver_seq_item);
    FIFO_vif.rst_n = driver_seq_item.rst_n ;
    FIFO_vif.wr_en = driver_seq_item.wr_en ;
    FIFO_vif.rd_en = driver_seq_item.rd_en ;
    FIFO_vif.data_in = driver_seq_item.data_in ;
    @(negedge FIFO_vif.clk);
    seq_item_port.item_done();
    `uvm_info("run_phase",driver_seq_item.convert2string(),UVM_HIGH);
end
endtask

endclass

endpackage