
module source_from_memory (clk, reset, data, req, busy, send);

	parameter id = -1;
	
	parameter dests = 1;
	
	parameter pir=16;
	
	parameter traffic_file = "";

	input clk, reset, busy, send;
	
	output req;
	
	output [`PAYLOAD_SIZE+`ADDR_BITS-1:0] data;
	
	reg [`PAYLOAD_SIZE+`ADDR_BITS-1:0] data;
	
	reg counter;
	
	reg req;
	
	reg pause;
	
	reg done;
	
	reg fire; 
	
	reg [3:0] index;

	reg [7:0] rand;
	
	reg [`ADDR_BITS-1:0] memory [`NUM_NODES-1:0];
	
// 	reg can_send;
	
	initial $readmemh(traffic_file, memory, 0, dests-1) ;
	
	wire [`ADDR_BITS-1:0] dest;
	
	assign dest=memory[index];
	
	wire can_send;
	
	assign can_send =!(pause | busy);
	
	
	
	always @(posedge clk or posedge reset) begin
	
		if (reset) begin
			
			data <= 0;
			
			fire<=1; 
			
			req <= 0;
			
			counter <= 1;
			
			index <= 0;
			
			done <= 0;
			
			pause <= 0 ;
			
		end 
		else begin
		      
		      if (pause) pause <=0;  // disable paused from previous send
		      
		      rand<=$random;
		      
		      if (/*counter == 0*/1) begin

			      
      //  		if (!busy & send & !done) begin
			      if (can_send & send) begin
				      
				      if (fire) begin			
						if (id==0) begin
// 						if (id != dest) begin
						      
						      data[`ADDR_BITS-1:0] <= dest;

						      data[`PAYLOAD_SIZE+`ADDR_BITS-1:`ADDR_BITS]<=id;
						
						      req <= 1;
						      
						      pause <= 1;
						      
      						      if (id != -1) $display ("##,tx,%d,%d",id,dest);
      						      
      						      //if (id != -1) $display ("source %d -> %d  -->>", id, dest);

						end
												      
						counter <= counter + 1;
						      
						index <= index + 1;
						
						if (index == dests-1) begin
							done <= 1;
							index <=0;
						end
					      
				      end
					      
			      end // can_send
			      else begin

				  req <= 0;
			      end

		      end else begin
			  counter <= counter + 1;
		      end  //counter
			  fire <= 1; //(rand < pir);
			
		end //else reset
	
	end // always

endmodule
