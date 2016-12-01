`ifndef _inc_debug_tasks_
`define _inc_debug_tasks_

module DebugTasks();

	task printPrefix;
		input [800:0] modName; // max chars = 100
		input [7:0] ID;
		begin
			$write("#%6d", $time);
			$write(", ");
			$write("%15s [%1d] : ", modName, ID);
		end
	endtask

	task printPrefixSub;
		input [800:0] modName; // max chars = 100
		input [7:0] ID;
		input [7:0] SUBID;
		begin
			$write("#%6d", $time);
			$write(", ");
			$write("%11s [%1d] [%1d] : ", modName, ID, SUBID);
		end
	endtask

endmodule

`endif
