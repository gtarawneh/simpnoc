
localparam SEED = 5;
localparam PORTS = 5;
localparam PORT_BITS = 8;
localparam SIZE = 8; // flit bits
localparam SRC_PACKETS = 10; // packets per source
localparam DEST_BITS = SIZE - 1; // bits to designate requested destination
localparam DESTS = 2 ** DEST_BITS;
localparam ROUTER_COUNT = 4;
localparam SINK_COUNT = 12;
localparam SOURCE_COUNT = 12;
