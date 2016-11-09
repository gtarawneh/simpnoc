`ifndef _inc_debug_tasks_
`define _inc_debug_tasks_

module DebugTasks();

	task printPrefix;
		input [800:0] modName; // max chars = 100
		input [7:0] ID;
		begin
			$write("#%3d", $time);
			$write(", ");
			$write("%15s [%1d] : ", modName, ID);
		end
	endtask

endmodule

`endif
