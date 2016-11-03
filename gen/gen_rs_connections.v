assign snk_data[0] = tx_data[2][SIZE-1:0];
assign snk_req[0] = tx_req[2][0];
assign tx_ack[2][0] = snk_ack[0];
