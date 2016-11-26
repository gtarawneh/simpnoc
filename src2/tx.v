`ifndef _inc_tx_
`define _inc_tx_

`include "debug_tasks.v"

module tx (
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

	parameter SIZE = 8; // flit size (bits)
	parameter CHANNEL_BITS = 3; // bits to designate requested output channel
	parameter BUFF_BITS = 3; // buffer address bits

	// inputs:

	input clk, reset;

	// channel interface:

	output reg ch_req;
	output reg [SIZE-1:0] ch_flit;
	input ch_ack;

	// switch interface:

	input sw_req;
	input [CHANNEL_BITS-1:0] sw_chnl;
	output reg sw_gnt;

	// buffer interface:

	output [BUFF_BITS-1:0] buf_addr;
	input [SIZE-1:0] buf_data;

	// state definitions:

	localparam ST_IDLE = 3'b000;
	localparam ST_SENDING  = 3'b001;

	// state registers

	reg [2:0] state;

	// data registers

	reg [SIZE-1:0] REG_FLIT;
	reg [BUFF_BITS-1:0] flit_counter;

	assign buf_addr = flit_counter;

	// individual flip-flops:

	reg ch_ack_old;

	// internal nets:

	wire ack = (ch_ack ^ ch_ack_old);

	// main body:

	always @(posedge clk or posedge reset) begin

		if (reset) begin

			state        <= ST_IDLE;
			REG_FLIT     <= 0;
			flit_counter <= 0;
			ch_req       <= 0;

		end else begin

			if (state == ST_IDLE) begin

				if (sw_req) begin

					state <= ST_SENDING;
					flit_counter <= 0;
					sw_gnt <= 1;
					DT.printPrefix("TX", 0);
					$display("received a request to send, transmitting ...");
					// initiate first handshake
					REG_FLIT <= buf_data;
					ch_req <= ~ch_req;
					DT.printPrefix("TX", 0);
					$display("sending flit %g <%g>", flit_counter, buf_data);

				end

			end else if (state == ST_SENDING) begin

				if (ack) begin

					if (flit_counter < 7) begin

						flit_counter = flit_counter + 1;
						REG_FLIT <= buf_data;
						ch_req <= ~ch_req;
						DT.printPrefix("TX", 0);
						$display("sending flit %g <%g>", flit_counter, buf_data);
						// DT.printPrefix("TX", 0);
						// $display("buf_addr = %g, buff_data = %g", buf_addr, buf_data);

					end else begin

						flit_counter = 0;
						state <= ST_IDLE;
						sw_gnt <= 0;
						DT.printPrefix("TX", 0);
						$display("end of transmitting, returning to idle");

					end

				end

			end

		end

	end

	// house keeping

	always @(posedge clk or posedge reset) begin

		if (reset) begin

			ch_ack_old <= 0;

		end else begin

			ch_ack_old <= ch_ack;

		end

	end

endmodule

`endif
