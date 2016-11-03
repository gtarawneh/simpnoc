generate
	for (i=0; i<SINK_COUNT; i=i+1) begin
		sink2 #(
			.ID(i)
		) snk1 (
			.clk(clk),
			.reset(reset),
			.req(snk_req[i]),
			.ack(snk_ack[i]),
			.data(snk_data[i])
		);
	end
endgenerate
