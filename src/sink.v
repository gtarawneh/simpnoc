`ifndef _inc_rx_
	`define _inc_rx_
	`include "rx.v"
`endif

module serial_sink (clk, reset, channel_busy, serial_in, througput);

	input clk, reset, serial_in;

	output wire [25:0]througput;
	output channel_busy;

	wire [`SIZE-1:0] data;

	sink s1 (.clk(clk), .reset(reset), .data(data), .req(req), .busy(busy), .througput(througput));

	rx rx1 (.clk(clk), .reset(reset), .valid(req), .channel_busy(channel_busy), .item_read(!busy), .serial_in(serial_in), .parallel_out(data) );

endmodule

module sink (clk, reset, data, req, busy, througput);
/*
	input clk, reset, req;

	output busy; assign busy = 0;

	input [`SIZE-1:0] data;

	reg [`SIZE-1:0] register;

	always @(posedge clk or posedge reset) begin

		if (reset) begin
			register <= 0;
		end else begin
			if (req) register <= data;
		end

	end
*/
	input clk, reset, req;

	output busy;

	output reg [25:0]througput;

	reg [25:0]running_througput;

	reg [9:0]sampler;

	input [`SIZE-1:0] data;

	reg [`SIZE-1:0] register;

	reg busy;

	//reg [7:0] rand;

	always @(posedge clk or posedge reset) begin

		if (reset) begin
			register <= 0;
			busy <= 1;
			sampler<=0;
			//rand <= 0;
		end else begin
			//rand <= $random;
			if (&(sampler)) begin
				througput<=running_througput;
				sampler<=0;
				running_througput<=0;
			end
			else begin
				sampler<=sampler+1;
				running_througput <= running_througput + (req);
			end

			if (req) begin
				register <= data;
				$display ("sinked flit  : ", data);
			end
			//busy <= (rand > 50);
			busy <= 0;
		end

	end

endmodule
