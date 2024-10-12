package FIFO_scoreboard_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import FIFO_sequence_item_pkg::*;
import FIFO_config_obj_pkg::*;
import shared_pkg::*;
class FIFO_scoreboard extends uvm_scoreboard;
`uvm_component_utils(FIFO_scoreboard)

FIFO_sequence_item scoreboard_seq_item;

bit [FIFO_WIDTH-1:0] mem [$];
bit [FIFO_WIDTH-1:0] data_out_ref;
int correct_count=0;
int error_count = 0;
int count=0;

uvm_analysis_export #(FIFO_sequence_item) scoreboard_export;
uvm_tlm_analysis_fifo #(FIFO_sequence_item) scoreboard_fifo;

function new ( string name = "FIFO_scoreboard" , uvm_component parent = null );

super.new(name,parent);

endfunction

function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    scoreboard_export = new("scoreboard_export",this);
    scoreboard_fifo = new("scoreboard_fifo",this);
endfunction

function void connect_phase (uvm_phase phase);
    super.connect_phase(phase);
    scoreboard_export.connect(scoreboard_fifo.analysis_export);
endfunction

task run_phase (uvm_phase phase);
    super.run_phase(phase);
    forever begin
        scoreboard_fifo.get(scoreboard_seq_item);
        check_data(scoreboard_seq_item);
    end
endtask


task reference_model (FIFO_sequence_item sb_seq_item) ;
if(sb_seq_item.rst_n) begin
    if(sb_seq_item.wr_en &&!sb_seq_item.rd_en && count < 8) begin
        mem.push_front(sb_seq_item.data_in);
        count++;
    end
    else if(!sb_seq_item.wr_en && sb_seq_item.rd_en && count !=0 ) begin
        data_out_ref=mem.pop_back;
         count--;
    end

    else if(sb_seq_item.wr_en && sb_seq_item.rd_en && count > 0 && count < 8) begin
         mem.push_front(sb_seq_item.data_in);
         data_out_ref=mem.pop_back;
         count=count;
          
    end
    else if (sb_seq_item.wr_en && sb_seq_item.rd_en && count == 8) begin
         data_out_ref=mem.pop_back;
          count--;
    end
     else if (sb_seq_item.wr_en && sb_seq_item.rd_en && count == 0) begin
            mem.push_front(sb_seq_item.data_in);
            count++;
    end
end
else if(!sb_seq_item.rst_n) begin
    mem.delete;
    count = 0;
end

endtask

task check_data (FIFO_sequence_item sb_seq_item) ;
reference_model(sb_seq_item);
if(data_out_ref == sb_seq_item.data_out) begin
    correct_count = correct_count + 1;
end
else begin
    error_count = error_count + 1;
    $display("Error: at %0t ns  Expected data_out = 0x%0h  ,data_out = 0x%0h ", $time, data_out_ref, sb_seq_item.data_out);
    $display("Transaction details at %0t ns: rst_n = %0b, wr_en = %0b, rd_en = %0b, data_in = 0x%0h, data_out = 0x%0h, full = %0b, empty = %0b, wr_ack = %0b",
             $time, sb_seq_item.rst_n, sb_seq_item.wr_en, sb_seq_item.rd_en, sb_seq_item.data_in, sb_seq_item.data_out, sb_seq_item.full, sb_seq_item.empty, sb_seq_item.wr_ack);
end


endtask

function void report_phase (uvm_phase phase);

super.report_phase(phase);
`uvm_info("report_phase",$sformatf("Total Number of Successful Transactions = %0d",correct_count),UVM_MEDIUM);
`uvm_info("report_phase",$sformatf("Total Number of Failed Transactions = %0d",error_count),UVM_MEDIUM);
endfunction


endclass

endpackage