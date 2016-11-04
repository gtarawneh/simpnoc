`ifndef _inc_connector_
`define _inc_connector_

module connector(tx_req, tx_ack, tx_data, rx_req, rx_ack, rx_data);

	parameter SIZE = 8; // data bits
	parameter TX_PORT_COUNT = 3; // number of ports (tx)
	parameter RX_PORT_COUNT = 3; // number of ports (rx)
	parameter TX_PORT = 0; // index of tx port to connect
	parameter RX_PORT = 0; // index of rx port to connect

	inout [TX_PORT_COUNT-1:0] tx_req;
	inout [TX_PORT_COUNT-1:0] tx_ack;
	inout [TX_PORT_COUNT*SIZE-1:0] tx_data;

	inout [RX_PORT_COUNT-1:0] rx_req;
	inout [RX_PORT_COUNT-1:0] rx_ack;
	inout [RX_PORT_COUNT*SIZE-1:0] rx_data;

	localparam TX_LSB = TX_PORT * SIZE;
	localparam TX_MSB = (TX_PORT+1) * SIZE - 1;

	localparam RX_LSB = RX_PORT * SIZE;
	localparam RX_MSB = (RX_PORT+1) * SIZE - 1;

	assign rx_data[RX_MSB:RX_LSB] = tx_data[TX_MSB:TX_LSB];
	assign rx_req[RX_PORT] = tx_req[TX_PORT];
	assign tx_ack[TX_PORT] = rx_ack[RX_PORT];

endmodule

`endif
