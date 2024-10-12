import uvm_pkg::*;
`include "uvm_macros.svh"
import FIFO_test_pkg::*;
module FIFO_top();

bit clk ;

always  begin
    clk = 1'b1;
    #1;
    clk = 1'b0;
    #1;
end

FIFO_Interface FIFO_if(clk);

FIFO FIFO_DUT (FIFO_if);

bind FIFO FIFO_assertions FIFO_SVA (FIFO_if);

initial begin
    uvm_config_db#(virtual FIFO_Interface)::set(null, "*", "FIFO_IF", FIFO_if);
    run_test("FIFO_test");
end



endmodule