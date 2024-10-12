package FIFO_sequence_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import FIFO_sequence_item_pkg::*;

class  FIFO_reset_sequence extends uvm_sequence;
`uvm_object_utils(FIFO_reset_sequence)
FIFO_sequence_item seq_item;

function new ( string name = "FIFO_reset_sequence");

super.new(name);

endfunction


task body ;

seq_item = FIFO_sequence_item::type_id::create("seq_item");
start_item(seq_item);
seq_item.rst_n = 1'b0 ;
seq_item.data_in =16'b0 ;
seq_item.wr_en = 1'b0 ;
seq_item.rd_en = 1'b0 ;
finish_item(seq_item);;

endtask

endclass

class  FIFO_write_sequence extends uvm_sequence;
`uvm_object_utils(FIFO_write_sequence);
FIFO_sequence_item seq_item;

function new ( string name = "FIFO_write_sequence");

super.new(name);

endfunction

task body ;
repeat(1000) begin
seq_item = FIFO_sequence_item::type_id::create("seq_item");
start_item(seq_item);
seq_item.constraint_mode(0);
seq_item.write_only.constraint_mode(1);
assert(seq_item.randomize());
finish_item(seq_item);;

end

endtask

endclass


class FIFO_read_sequence  extends uvm_sequence;
`uvm_object_utils(FIFO_read_sequence);
FIFO_sequence_item seq_item;

function new ( string name = "FIFO_read_sequence");

super.new(name);

endfunction

task body ;
repeat(1000) begin
seq_item = FIFO_sequence_item::type_id::create("seq_item");
start_item(seq_item);
seq_item.constraint_mode(0);
seq_item.read_only.constraint_mode(1);
assert(seq_item.randomize());
finish_item(seq_item);;
end
endtask

endclass


class FIFO_write_read_sequence extends uvm_sequence;
`uvm_object_utils(FIFO_write_read_sequence);
FIFO_sequence_item seq_item;

function new ( string name = "FIFO_write_read_sequence");

super.new(name);

endfunction


task body ;
repeat(10000) begin
seq_item = FIFO_sequence_item::type_id::create("seq_item");
start_item(seq_item);
seq_item.constraint_mode(1);
seq_item.write_only.constraint_mode(0);
seq_item.read_only.constraint_mode(0);
assert(seq_item.randomize());
finish_item(seq_item);;
end
endtask

endclass




endpackage