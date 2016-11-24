`ifndef _inc_rx_
`define _inc_rx_

module rx (
		clk,
		reset,
		ch_req,
		ch_flit,
		ch_ack,
		sw_req,
		sw_chnl,
		sw_gnt,
		buf_addr,
		buf_data
	);

	// parameters:

	parameter SIZE = 8; // flit size (bits)
	parameter CHANNEL_BITS = 3; // bits to designate requested output channel
	parameter BUFF_BITS = 3; // buffer address bits

	// inputs:

	input clk, reset;

	// channel interface:

	input ch_req;
	input [SIZE-1:0] ch_flit;
	output reg ch_ack;

	// switch interface:

	output reg sw_req;
	output reg [CHANNEL_BITS-1:0] sw_chnl;
	input sw_gnt;

	// buffer interface:

	input [BUFF_BITS-1:0] buf_addr;
	output [SIZE-1:0] buf_data;

	// state definitions:

	localparam ST_IDLE    = 3'b000;
	localparam ST_LATCHED = 3'b001;
	localparam ST_RC      = 3'b011;
	localparam ST_BUF     = 3'b101;
	localparam ST_CH_WAIT = 3'b100;
	localparam ST_SEND    = 3'b111;

	// state register

	reg [2:0] state;

	// data registers

	reg [SIZE-1:0] REG_FLIT;
	reg [CHANNEL_BITS-1:0] REG_OUT_CHANNEL;
	reg [7:0] flit_counter;

	// individual flip-flops:

	reg ch_req_old;

	// internal nets:

	wire req = (ch_req ^ ch_req_old);

	// flit parts (internal nets):

	wire head_flit = REG_FLIT[SIZE-1];
	wire destination = REG_FLIT[SIZE-2:SIZE-2-CHANNEL_BITS];

	// main body:

	always @(posedge clk or posedge reset) begin

		if (reset) begin

			state <= ST_IDLE;
			flit_counter <= 0;
			sw_req <= 0;
			ch_ack <= 0;
			$display("rx initialized");

		end else begin

			if (state == ST_IDLE && req) begin

				state <= ST_LATCHED;
				REG_FLIT <= ch_flit;
				sw_chnl <= 0;
				$display("req arrived, latched flit");

			end else if (state == ST_LATCHED) begin

				if (head_flit) begin
					$display("flit decoded: head");
				end else begin
					$display("flit decoded: body");
				end

				state <= head_flit ? ST_RC : ST_BUF;

			end else if (state == ST_RC) begin

				REG_OUT_CHANNEL <= 0; //LUT[destination];
				state <= ST_BUF;

				$display("fetched routing information");

			end else if (state == ST_BUF) begin

				if (flit_counter == 8) begin

					sw_chnl <= destination;
					sw_req <= 1;
					state <= ST_CH_WAIT;

					$display("packet assembly complete, requesting outgoing channel");

				end else begin

					state <= ST_IDLE;
					ch_ack <= ~ch_ack;
					flit_counter <= flit_counter + 1;

					$display("added flit %g to buffer", flit_counter);

				end

			end else if (state == ST_CH_WAIT) begin

				if (sw_gnt) begin

					state <= ST_SEND;
					$display("granted outgoing channel, sending ..");

				end

			end else if (state == ST_SEND) begin

				if (~sw_gnt) begin

					$display("sending complete");
					state <= ST_IDLE;
					ch_ack <= ~ch_ack;
					flit_counter <= 0;

				end

			end

		end

	end

	// house keeping:

	always @(posedge clk or posedge reset) begin

		if (reset) begin

			ch_req_old <= 0;

		end else begin

			ch_req_old <= ch_req;

		end

	end

endmodule

`endif