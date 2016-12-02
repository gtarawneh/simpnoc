
// routing table (router 0)

always @(table_addr[0]) case (table_addr[0])
	0          : table_data[0] = 0;
	1          : table_data[0] = 2;
	2          : table_data[0] = 1;
	3          : table_data[0] = 2;
	default    : table_data[0] = 0;
endcase

// routing table (router 1)

always @(table_addr[1]) case (table_addr[1])
	0          : table_data[1] = 4;
	1          : table_data[1] = 0;
	2          : table_data[1] = 4;
	3          : table_data[1] = 1;
	default    : table_data[1] = 0;
endcase

// routing table (router 2)

always @(table_addr[2]) case (table_addr[2])
	0          : table_data[2] = 3;
	1          : table_data[2] = 2;
	2          : table_data[2] = 0;
	3          : table_data[2] = 2;
	default    : table_data[2] = 0;
endcase

// routing table (router 3)

always @(table_addr[3]) case (table_addr[3])
	0          : table_data[3] = 4;
	1          : table_data[3] = 3;
	2          : table_data[3] = 4;
	3          : table_data[3] = 0;
	default    : table_data[3] = 0;
endcase
