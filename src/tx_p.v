`ifndef SIZE
	`define SIZE 8
`endif

// This module is an intermediate for two entities communicating through a two
// phase handshake. Signals with postfix 1 belong to the channel with the
// sending entity (i.e. req1 asks the module to transmit data1) and those with
// postfix 2 belong to the channel with the receiving entity (i.e. req2
// initiates a handshake with the item in data2).

module tx_p (clk, reset, req1, ack1, data1, req2, ack2, data2);

	parameter routerid=-1;

	parameter port="unknown";

	input clk, reset;

	// router-side port:

	input req1;

	input [`SIZE-1:0] data1;

	output ack1;

	// remote rx port:

	output req2;

	output [`SIZE-1:0] data2;

	input ack2;

	// state resiter

	reg req;
	reg ack;

	reg [`SIZE-1:0] data;

	// comb outputs

	assign req2 = req;
	assign ack1 = ack;
	assign data2 = data;

	always @(posedge clk or posedge reset) begin

		if (reset) begin

			req <= 0;
			ack <= 0;

		end else begin

			req <= req1;
			ack <= ack2;

			data <= (req1 ^ req) ? data1 : data;

		end

	end

endmodule
