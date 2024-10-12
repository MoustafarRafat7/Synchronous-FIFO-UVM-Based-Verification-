module FIFO_assertions(FIFO_Interface.DUT FIFO_if);

property wr_ack_p;
	@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) (FIFO_if.wr_en && !FIFO_if.full && !FIFO_if.rd_en) |=> 
																							FIFO_if.wr_ack ;
endproperty

wr_ack_a:assert property (wr_ack_p);
wr_ack_c:cover property (wr_ack_p);

property overflow_p;
@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) (FIFO_if.wr_en && FIFO_if.full) |=> FIFO_if.overflow;
endproperty

overflow_a:assert property (overflow_p);
overflow_c:cover property (overflow_p);

property underflow_p;
@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) (FIFO_if.rd_en && FIFO_if.empty) |=> FIFO_if.underflow;
endproperty

underflow_a:assert property (underflow_p);
underflow_c:cover property (underflow_p);


property wr_ptr_p;
@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) (FIFO_if.wr_en && !FIFO_if.full) |=> 
													(FIFO_DUT.wr_ptr == $past(FIFO_DUT.wr_ptr)+1'b1);
endproperty

wr_ptr_a:assert property(wr_ptr_p);
wr_ptr_c:cover property(wr_ptr_p);


property rd_ptr_p;
@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) (FIFO_if.rd_en && !FIFO_if.empty) |=> 
															(FIFO_DUT.rd_ptr == $past(FIFO_DUT.rd_ptr)+1'b1);
endproperty

rd_ptr_a:assert property(rd_ptr_p);
rd_ptr_c:cover property(rd_ptr_p);


property count_inc_p;
@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) (FIFO_if.wr_en   && !FIFO_if.rd_en && !FIFO_if.full) |=> 
															(FIFO_DUT.count == $past(FIFO_DUT.count)+1'b1);
endproperty

count_inc_a:assert property(count_inc_p);
count_inc_c:cover property(count_inc_p);

property count_dec_p;
@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) (!FIFO_if.wr_en   && FIFO_if.rd_en && !FIFO_if.empty) |=> 
															(FIFO_DUT.count == $past(FIFO_DUT.count)-1'b1);
endproperty

count_dec_a:assert property(count_dec_p);
count_dec_c:cover property(count_dec_p);


property count_no_change_p;
@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) (FIFO_if.wr_en && FIFO_if.rd_en && !FIFO_if.full && !FIFO_if.empty )  |=> 
																					(FIFO_DUT.count == $past(FIFO_DUT.count));
endproperty

count_no_change_a:assert property(count_no_change_p);
count_no_change_c:cover property(count_no_change_p);




always_comb begin : comb_outputs
	if(FIFO_if.rst_n) begin
		
		if(FIFO_DUT.count == FIFO_if.FIFO_DEPTH) begin
			full_check:assert(FIFO_if.full == 1'b1);
		end
		
		if(FIFO_DUT.count == FIFO_if.FIFO_DEPTH-1) begin
			almost_full_check:assert(FIFO_if.almostfull == 1'b1);
		end 

		if(FIFO_DUT.count == 0) begin
			empty_check:assert(FIFO_if.empty == 1'b1);
		end 
		
		if(FIFO_DUT.count == 1) begin
			almostempty_check:assert(FIFO_if.almostempty == 1'b1);
		end 
		

	end
	
end

always_comb begin :reset_outputs
	if(!FIFO_if.rst_n) 
		reset:assert final (FIFO_DUT.count == 0 && FIFO_DUT.wr_ptr == 0 && FIFO_DUT.rd_ptr == 0 && FIFO_if.empty == 1'b1 && FIFO_if.full == 0  && FIFO_if.almostempty == 0 && FIFO_if.almostfull == 0 && FIFO_if.wr_ack == 0  );
end


endmodule