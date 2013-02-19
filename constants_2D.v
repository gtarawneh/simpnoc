// ----- Constants File-------

`define DIRECTIONS 	    5 
`define BITS_DIR 	       3
 
`define DIR_NORTH  		 0
`define DIR_EAST  		 1
`define DIR_SOUTH  		 2
`define DIR_WEST    		 3
`define DIR_LOCAL 		 4

`define THRESHOLD	 	 	 10
`define X_DIM		 	 	 4
`define Y_DIM		 	 	 4
`define NUM_NODES     	 16

`define SIZE		 	 	 4 			// 2^SIZE is the NUM_NODES 
`define SIZE_X		 	 	 2 			// 2^SIZE_X is the X_DIM 
`define SIZE_Y		 	 	 2 			// 2^SIZE_Y is the Y_DIM
`define BITS_RT			 `SIZE


`define TBL_DEPTH	 	    `NUM_NODES // The routing table depth

`define NOT_VALID 	 	 -1
`define NOT_RESERVED 	 -2

`define HIGH_COST 	  	  0

//  Convergence coutnter parameters
`define CONV_COUNTER	 	 4			// Cconvergence counter width
`define CONV_PER	 	    12 			// Cconvergence counter MAX

// Thermal sensor paarameters
`define SENSOR_COUNTER_WIDTH 15
