package FIFO_sequence_item_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import shared_pkg::*;
class FIFO_sequence_item extends uvm_sequence_item ;
`uvm_object_utils(FIFO_sequence_item)

rand bit rst_n;
rand bit [FIFO_WIDTH-1 :0] data_in;
rand bit wr_en,rd_en;
logic [FIFO_WIDTH-1 :0] data_out;
logic almostfull,full;
logic almostempty,empty;
logic overflow,underflow;
logic wr_ack;
int RD_EN_ON_DIST , WR_EN_ON_DIST;

// Constraints // 

constraint Assert_reset_less_often {
                    rst_n dist {1:=98 ,0:=2};
} 


constraint WRITE_ENABLE{
                        wr_en dist {1:=WR_EN_ON_DIST , 0:=100-WR_EN_ON_DIST};
}

constraint READ_ENABLE{
                        rd_en dist {1:=RD_EN_ON_DIST , 0:=100-RD_EN_ON_DIST};
}


constraint write_only {
            wr_en == 1;
            rd_en == 0;
            rst_n == 1;
}

constraint read_only {
            wr_en == 0;
            rd_en == 1;
            rst_n == 1;
}


function new ( string name = "FIFO_sequence_item" ,int RD_EN_ON_DIST = 30 , int WR_EN_ON_DIST = 70  );
  super.new(name);
  this.RD_EN_ON_DIST=RD_EN_ON_DIST;
  this.WR_EN_ON_DIST=WR_EN_ON_DIST;

endfunction

function string convert2string ();
return $sformatf("%s rst_n = 0b%0b, wr_en = 0b%0b, rd_en = 0b%0b, data_in = 0b%0b, data_out = 0b%0b, almostfull = 0b%0b, full = 0b%0b,almostempty = 0b%0b, empty = 0b%0b, overflow = 0b%0b, underflow = 0b%0b, wr_ack = 0b%0b",super.convert2string(),rst_n, wr_en, rd_en, data_in, data_out, almostfull, full,almostempty, empty, overflow, underflow, wr_ack);
endfunction

function string convert2string_stimulus ();
return $sformatf("rst_n = 0b%0b, wr_en = 0b%0b, rd_en = 0b%0b, data_in = 0b%0b",rst_n, wr_en, rd_en, data_in);
endfunction



endclass


endpackage