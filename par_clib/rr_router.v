module rr_router (clk, reset, rx_busy, rx_data, tx_busy, tx_data, flit_counter);

	parameter routerid=-1;
	
	parameter table_file ="";
	
	// Ports:
	// -----------------------------------------------------------------
	
	// the follow are all bitfield ports with the following format
	// bit 0 : north
	// bit 1 : east
	// bit 2 : south
	// bit 3 : west
	// bit 4 : local
	
	output [`DIRECTIONS-1:0] rx_busy;
	input  [`DIRECTIONS-1:0] rx_data;
	input  [`DIRECTIONS-1:0] tx_busy;
	output [`DIRECTIONS-1:0] tx_data;
	
	assign rx_busy = {rx_l_busy, rx_w_busy,  rx_s_busy, rx_e_busy, rx_n_busy};
	
	assign rx_n_data = rx_data[`NORTH];
	assign rx_e_data = rx_data[`EAST ];
	assign rx_s_data = rx_data[`SOUTH];
	assign rx_w_data = rx_data[`WEST ];
	assign rx_l_data = rx_data[`LOCAL];
	
	assign tx_n_busy = tx_busy[`NORTH];
	assign tx_e_busy = tx_busy[`EAST ];
	assign tx_s_busy = tx_busy[`SOUTH];
	assign tx_w_busy = tx_busy[`WEST ];
	assign tx_l_busy = tx_busy[`LOCAL];
	
	assign tx_data = {tx_l_data, tx_w_data, tx_s_data, tx_e_data, tx_n_data};	
	
	// Interface and internal nets:
	// -----------------------------------------------------------------
	
	input clk, reset;
	
	//output  link_tx_n_data;
	
	output [`ADDR_BITS-1:0] table_addr;
	
	input [`BITS_DIR-1:0] table_data;
	
	
	wire [`PAYLOAD_SIZE+`ADDR_BITS-1:0] fifo_item_in[`DIRECTIONS-1:0];
	
	wire [`PAYLOAD_SIZE+`ADDR_BITS-1:0] fifo_item_out[`DIRECTIONS-1:0];
	
	wire [`PAYLOAD_SIZE+`ADDR_BITS-1:0] item[`DIRECTIONS-1:0];

	wire [`PAYLOAD_SIZE+`ADDR_BITS-1:0] rr_item_out[`DIRECTIONS-1:0];

	
	wire tx_active [`DIRECTIONS-1:0];
	
	wire read[`DIRECTIONS-1:0]; //  fifo pop signal (routing_logic -> fifo)

	wire item_read[`DIRECTIONS-1:0];  //  Read ack (ch_rx_logic -> rx)
	
	wire write[`DIRECTIONS-1:0];
	
	wire full[`DIRECTIONS-1:0];
	
	wire empty[`DIRECTIONS-1:0];	
	
	wire valid[`DIRECTIONS-1:0];	
	

	output [19:0] flit_counter;
	
	reg [9:0]  sampler;
	reg [19:0] running_flit_counter;
	reg [19:0] flit_counter;
	
	
	// RX :
	// -----------------------------------------------------------------

	
	rx #(routerid,"north") rx_n
	(
		.clk(clk), .reset(reset),
		.channel_busy(rx_n_busy), .serial_in (rx_n_data),
		.valid(valid[`NORTH]), .parallel_out(item[`NORTH]), .item_read(item_read[`NORTH])
	);
		 
 
	rx #(routerid,"east") rx_e
	(
		.clk(clk), .reset(reset),
		.channel_busy(rx_e_busy), .serial_in (rx_e_data),
		.valid(valid[`EAST]), .parallel_out(item[`EAST]), .item_read(item_read[`EAST])
	);
	
	rx #(routerid,"south") rx_s
	(
		.clk(clk), .reset(reset),
		.channel_busy(rx_s_busy), .serial_in (rx_s_data),
		.valid(valid[`SOUTH]), .parallel_out(item[`SOUTH]), .item_read(item_read[`SOUTH])
	);
			 
	
	rx #(routerid,"west") rx_w
	(
		.clk(clk), .reset(reset),
		.channel_busy(rx_w_busy), .serial_in (rx_w_data),
		.valid(valid[`WEST]), .parallel_out(item[`WEST]), .item_read(item_read[`WEST])
	);	
		 
	rx #(routerid,"local") rx_l
	(
		.clk(clk), .reset(reset),
		.channel_busy(rx_l_busy), .serial_in (rx_l_data),
		.valid(valid[`LOCAL]), .parallel_out(item[`LOCAL]), .item_read(item_read[`LOCAL])
	);		 	 	 		 
	
	

	
	// -----------------------------------------------------------------
	// rx logic for each channel
	// -----------------------------------------------------------------
	
	generate
	genvar channel;
	    for (channel = 0; channel < `DIRECTIONS; channel = channel + 1) begin: ch_rx_logics
		ch_rx_logic rx_logic(
			.item_out(fifo_item_in[channel]), .write(write[channel]), .full(full[channel]), 
			.valid(valid[channel]), .item_in(item[channel]), .item_read(item_read[channel])  
		);
	    end
	
	
	// -----------------------------------------------------------------
	// rx fifo for each channel
	// -----------------------------------------------------------------
	

	    for (channel = 0; channel < `DIRECTIONS; channel = channel + 1) begin: fifos
		  fifo #(routerid) myfifo(
		  
			.clk(clk), .reset(reset),
			.full(full[channel]), .empty(empty[channel]),
			.item_in(fifo_item_in[channel]), .item_out(fifo_item_out[channel]),
			.write (write[channel]), .read(read[channel])
		  
		  );	    
	    end
	endgenerate
	

	

	
	
	//wire n_ena, n_busy, s_ena, s_busy, e_ena, e_busy, w_ena, w_busy, l_ena, l_busy;
	
// 	tx_logic tx_logic1 
// 	(
// 		.item_in(fifo_item_out), .read(read), .empty(empty),
// 		.table_addr(table_addr), .table_data(table_data),
// 		.item_out(tx_item_out),
// 		.n_ena(n_ena), .n_busy(n_busy),
// 		.s_ena(s_ena), .s_busy(s_busy),
// 		.e_ena(e_ena), .e_busy(e_busy),
// 		.w_ena(w_ena), .w_busy(w_busy),
// 		.l_ena(l_ena), .l_busy(l_busy)
// 	);

	

       routing_logic #(routerid,table_file) rr_routing_logic(
		.clk(clk), .reset(reset),
		.n_item_in(fifo_item_out[`NORTH]), .n_read(read[`NORTH]), .n_empty(empty[`NORTH]), .n_item_out(rr_item_out[`NORTH]), .n_ena(n_ena), .n_busy(n_busy),
		.e_item_in(fifo_item_out[`EAST ]), .e_read(read[`EAST ]), .e_empty(empty[`EAST ]), .e_item_out(rr_item_out[`EAST ]), .e_ena(e_ena), .e_busy(e_busy),
		.s_item_in(fifo_item_out[`SOUTH]), .s_read(read[`SOUTH]), .s_empty(empty[`SOUTH]), .s_item_out(rr_item_out[`SOUTH]), .s_ena(s_ena), .s_busy(s_busy),
		.w_item_in(fifo_item_out[`WEST ]), .w_read(read[`WEST ]), .w_empty(empty[`WEST ]), .w_item_out(rr_item_out[`WEST ]), .w_ena(w_ena), .w_busy(w_busy),
		.l_item_in(fifo_item_out[`LOCAL]), .l_read(read[`LOCAL]), .l_empty(empty[`LOCAL]), .l_item_out(rr_item_out[`LOCAL]), .l_ena(l_ena), .l_busy(l_busy)
		);
		
			
	// TX :
	// -----------------------------------------------------------------	
	
	tx #(routerid,"north") tx_n
	(
		.clk(clk), .reset(reset), .tx_active(tx_active[`NORTH]),
		.req(n_ena), .tx_busy(n_busy),
		.channel_busy(tx_n_busy), .serial_out(tx_n_data),
		.parallel_in(rr_item_out[`NORTH])
	);
	

	tx #(routerid,"east") tx_e
	(
		.clk(clk), .reset(reset),.tx_active(tx_active[`EAST]),
		.req(e_ena), .tx_busy(e_busy),
		.channel_busy(tx_e_busy), .serial_out(tx_e_data),
		.parallel_in(rr_item_out[`EAST])
	);
	
	tx #(routerid,"south") tx_s
	(
		.clk(clk), .reset(reset),.tx_active(tx_active[`SOUTH]),
		.req(s_ena), .tx_busy(s_busy),
		.channel_busy(tx_s_busy), .serial_out(tx_s_data),
		.parallel_in(rr_item_out[`SOUTH])
	);
	
	tx #(routerid,"west") tx_w
	(
		.clk(clk), .reset(reset), .tx_active(tx_active[`WEST]),
		.req(w_ena), .tx_busy(w_busy),
		.channel_busy(tx_w_busy), .serial_out(tx_w_data),
		.parallel_in(rr_item_out[`WEST])
	);
	
	tx #(routerid,"local") tx_l
	(
		.clk(clk), .reset(reset),
		.req(l_ena), .tx_busy(l_busy),.tx_active(tx_active[`LOCAL]),
		.channel_busy(tx_l_busy), .serial_out(tx_l_data),
		.parallel_in(rr_item_out[`LOCAL])
	);
	
// Router activity :
	wire [2:0] written_flits;
	
	assign written_flits=(write[`NORTH]+write[`EAST]+write[`SOUTH]+write[`WEST]+write[`LOCAL]);
	
	
	always @(posedge clk or posedge reset) begin
		if (reset) begin
			sampler <= 0;
			running_flit_counter <= 0;
			flit_counter <= 0;
		end 
		else begin
			if (&(sampler))
			begin
				flit_counter <= running_flit_counter;

				running_flit_counter <= 0;
				
				sampler <= 0;
			end   //sampler
			else begin
				running_flit_counter <= running_flit_counter + (written_flits);
				
				sampler <=sampler+1;
			end //!sampler
		end //!reset


	end // always

endmodule
