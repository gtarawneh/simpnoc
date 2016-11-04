`include "generator.v"
`include "router2.v"
`include "source2.v"
`include "sink2.v"
`include "connector.v"

module noc (input clk, input reset);

	`include "gen_params.v"
	`include "wires.v"
	`include "gen_routers.v"
	`include "gen_sources.v"
	`include "gen_sinks.v"
	`include "gen_rr_connections.v"
	`include "gen_rs_connections.v"
	`include "gen_sr_connections.v"

endmodule
