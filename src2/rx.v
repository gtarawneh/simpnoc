`ifndef _inc_rx_
`define _inc_rx_

`include "debug_tasks.v"

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

	DebugTasks DT();

	// parameters:

	parameter ID = 0;
	parameter MOD_NAME = "RX";
	parameter SINK_PACKETS = 0;
	parameter SIZE = 8; // flit size (bits)
	parameter CHANNEL_BITS = 3; // bits to designate requested output channel
	parameter BUFF_BITS = 3; // buffer address bits

	localparam FLIT_COUNT = 2 ** BUFF_BITS;

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

	assign buf_data = MEM_BUF[buf_addr];

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
	reg [SIZE-1:0] MEM_BUF [FLIT_COUNT-1:0];

	// individual flip-flops:

	reg ch_req_old;

	// internal nets:

	wire req = (ch_req ^ ch_req_old);

	// flit parts (internal nets):

	wire head_flit = REG_FLIT[SIZE-1];
	wire destination = REG_FLIT[SIZE-2:SIZE-2-CHANNEL_BITS];

	// main body:

	integer i;

	always @(posedge clk or posedge reset) begin

		if (reset) begin

			state <= ST_IDLE;
			flit_counter <= 0;
			sw_req <= 0;
			ch_ack <= 0;
			for (i=0; i<FLIT_COUNT; i=i+1)
				MEM_BUF[i] <= 0;

		end else begin

			if (state == ST_IDLE && req) begin

				state <= ST_LATCHED;
				REG_FLIT <= ch_flit;
				sw_chnl <= 0;
				DT.printPrefix(MOD_NAME, ID);
				$display("req arrived, latched flit <0x%h>", ch_flit);

			end else if (state == ST_LATCHED) begin

				if (head_flit) begin
					DT.printPrefix(MOD_NAME, ID);
					$display("flit decoded: head");
				end else begin
					DT.printPrefix(MOD_NAME, ID);
					$display("flit decoded: body");
				end

				state <= head_flit ? ST_RC : ST_BUF;

			end else if (state == ST_RC) begin

				REG_OUT_CHANNEL <= 0; //LUT[destination];
				state <= ST_BUF;

				DT.printPrefix(MOD_NAME, ID);
				$display("fetched routing information");

			end else if (state == ST_BUF) begin

				state <= ST_IDLE;
				ch_ack <= ~ch_ack;
				flit_counter <= flit_counter + 1;
				MEM_BUF[flit_counter] = REG_FLIT;
				DT.printPrefix(MOD_NAME, ID);
				$display("stored flit in buffer[%g]", flit_counter);

				if (flit_counter == 7) begin

					if (SINK_PACKETS) begin

						state <= ST_IDLE;
						flit_counter <= 0;

						DT.printPrefix(MOD_NAME, ID);
						$display("consumed packet <0x%h>", {
							MEM_BUF[7],
							MEM_BUF[6],
							MEM_BUF[5],
							MEM_BUF[4],
							MEM_BUF[3],
							MEM_BUF[2],
							MEM_BUF[1],
							MEM_BUF[0]
						});

					end else begin

						sw_chnl <= destination;
						sw_req <= 1;
						state <= ST_CH_WAIT;

						DT.printPrefix(MOD_NAME, ID);
						$display("assembled packet <0x%h>", {
							MEM_BUF[7],
							MEM_BUF[6],
							MEM_BUF[5],
							MEM_BUF[4],
							MEM_BUF[3],
							MEM_BUF[2],
							MEM_BUF[1],
							MEM_BUF[0]
						});

						DT.printPrefix(MOD_NAME, ID);
						$display("requesting outgoing channel");

					end

				end

			end else if (state == ST_CH_WAIT) begin

				if (sw_gnt) begin

					sw_req <= 0;
					state <= ST_SEND;
					DT.printPrefix(MOD_NAME, ID);
					$display("granted outgoing channel");

				end

			end else if (state == ST_SEND) begin

				if (~sw_gnt) begin

					state <= ST_IDLE;
					ch_ack <= ~ch_ack;
					flit_counter <= 0;
					DT.printPrefix(MOD_NAME, ID);
					$display("sending complete");

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
