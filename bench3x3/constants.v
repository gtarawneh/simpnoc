// ----- Constants File-------

`define DIRECTIONS	5 
`define BITS_DIR	3
 
`define NORTH	0
`define EAST	1
`define SOUTH	2
`define WEST	3
`define LOCAL	4
	

`define X_DIM		3
`define Y_DIM		3
`define NUM_NODES     	9

`define ADDR_BITS	4 			// 2^ADDR_BITS is the NUM_NODES 
`define X_BITS		2 			// 2^X_BITS is the X_DIM 
`define Y_BITS		2 			// 2^Y_BITS is the Y_DIM
`define RT_BITS		`ADRR_BITS
`define NUM_DESTS	9

`define TBL_DEPTH	`NUM_NODES 		//The routing table size
`define FIFO_LOG2	 6
// `define FIFO_DEPTH	 2^(`FIFO_LOG2)
`define PAYLOAD_SIZE	 32

`define NOT_VALID	-1
`define NOT_RESERVED 	-2


`define ROUTER_ID 	 4
