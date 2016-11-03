`ifndef _inc_fifo_
`define _inc_fifo_

module fifo(clk, reset, full, empty, item_in, item_out, write, read);

	parameter ID = -1;
	parameter SIZE = 8;
	parameter DEPTH_LOG2 = 4;

	localparam DEPTH = 1 ** DEPTH_LOG2;

	input clk, reset, write, read;

	output full, empty;

	reg [SIZE-1:0] memory [DEPTH-1:0];

	reg [DEPTH_LOG2-1:0] read_ptr;

	reg [DEPTH_LOG2-1:0] write_ptr;

	wire [DEPTH_LOG2-1:0] read_ptr_p1; assign read_ptr_p1 = read_ptr + 1;

	wire [DEPTH_LOG2-1:0] write_ptr_p1; assign write_ptr_p1 = write_ptr + 1;

	input [SIZE-1:0] item_in;

	output [SIZE-1:0] item_out;

	reg full, empty;

	integer i;

	always @(posedge clk or posedge reset) begin

		if (reset) begin

			read_ptr <= 0;

			write_ptr <= 0;

			empty <= 1;

			full <= 0;

			for (i=0; i<DEPTH; i=i+1) begin
				memory[i] <= 0;
			end

		end else begin

			if (read & !empty) begin

				full <= 0;

				read_ptr <= read_ptr_p1;

				if (read_ptr_p1 == write_ptr) empty <= 1;

				$display("#%3d, %10s [%1d] : popped (read_ptr = %g, write_ptr = %g, empty = %g)", $time, "FIFO", ID, read_ptr_p1, write_ptr, read_ptr_p1 == write_ptr);

			end

			if (write & !full) begin

				memory [write_ptr] <= item_in;

				empty <= 0;

				write_ptr <= write_ptr_p1;

				if (read_ptr == write_ptr_p1) full <= 1;

				$display("#%3d, %10s [%1d] : pushed <%g> (read_ptr = %g, write_ptr = %g, full = %g)", $time, "FIFO", ID, item_in, read_ptr, write_ptr_p1, read_ptr == write_ptr_p1);

			end

		end

	end

	assign item_out = memory [read_ptr];

endmodule

`endif
