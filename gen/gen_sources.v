// sources

generate
	for (i=0; i<1; i=i+1) begin
		source2 #(
			.ID(i),
			.DESTINATION(100 + i),
			.MAX_FLITS(1),
			.SIZE(SIZE),
			.PAYLOAD(10+i)
		) src1 (
			.clk(clk),
			.reset(reset),
			.req(src_req[i]),
			.ack(src_ack[i]),
			.data(src_data[i])
		);
	end
endgenerate