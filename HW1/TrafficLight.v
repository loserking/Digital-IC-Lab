module TrafficLight_CU(
						clk,
						rst,
						auto,			// SW0 		開始電路自動運作
						modify,  		// SW1 		切換到時間調整模式的開關
						timeup,			// KEY1		時間加1
						timedown,		// KEY2		時間減1
						phase_valid,	// KEY3		phase確定
						manual,         // KEY0     手動改變phase
						light,			// LEDR0~LEDR9
						test_light		// test
						);
						
   input 		clk, rst;
   input	  	auto;
   input 		modify;
   input 		timeup, timedown;
   input 		phase_valid;
   input 		manual;
   output [9:0] light;
   output		test_light;
   
   parameter IDLE 	= 4'd0;
   parameter P1   	= 4'd1;
   parameter P2   	= 4'd2;
   parameter P3   	= 4'd3;
   parameter P4   	= 4'd4;   
   parameter P5  	= 4'd5;   
   parameter P6   	= 4'd6;   
   parameter P7   	= 4'd7;   
   parameter P8   	= 4'd8;   
   parameter P9   	= 4'd9;   
   parameter P10   	= 4'd10;      
   
   reg	[3:0] 	state;
   reg 	[3:0] 	next_state;
   reg		 	add_1s;
   reg		 	sub_1s;
   reg	[3:0] 	access_state;
   reg	[6:0]	access_time;
   reg	[32:0] 	flash_count;
   reg	[32:0]	next_flash_count;
   reg	[25:0]	auto_count;
   reg	[25:0]	next_auto_count;
   reg	[32:0]	count;
   reg	[32:0]	next_count;
   reg	[9:0]	light;
   reg			had_push;
   reg			clk2;

	reg		[6:0]	rest_time;
	reg		[6:0]	next_rest_time;
   
	reg		[6:0]	P1_time;
	reg		[6:0]	P2_time;
	reg		[6:0]	P3_time;
	reg		[6:0]	P4_time;
	reg		[6:0]	P5_time;
	reg		[6:0]	P6_time;
	reg		[6:0]	P7_time;
	reg		[6:0]	P8_time;
	reg		[6:0]	P9_time;
	reg		[6:0]	P10_time;
	
	reg		[6:0]	P1_time_buf;
	reg		[6:0]	P2_time_buf;
	reg		[6:0]	P3_time_buf;
	reg		[6:0]	P4_time_buf;
	reg		[6:0]	P5_time_buf;
	reg		[6:0]	P6_time_buf;
	reg		[6:0]	P7_time_buf;
	reg		[6:0]	P8_time_buf;
	reg		[6:0]	P9_time_buf;
	reg		[6:0]	P10_time_buf;
/*   
   always@(posedge clk) begin
		if(KEY == 1'b0) begin
			if(had_push == 1'b1)
				LED <= LED;
			else
				LED <= 1'b1;
		end
		else begin
			LED <= 1'b0;
		end
   end*/
   assign test_light = clk2;
   
   always@(*) begin  
		next_flash_count = flash_count + 1;
		next_auto_count = auto_count + 1;
		case(state)
			IDLE: begin
			    light = 10'd0;
				next_state = P1;
				next_rest_time = P1_time;
			end			     
			P1: begin
			    light = 10'b0010110010;		
				next_state = P2;
				next_rest_time = P2_time;
			end
			P2: begin
			    light[9:6] = 4'b0010;
				light[5] = clk2;
				light[4:0] = 5'b10010;	
				next_state = P3;
				next_rest_time = P3_time;
			end
			P3: begin
				light = 10'b0011010010;	
				next_state = P4;
				next_rest_time = P4_time;
			end
			P4: begin
			    light = 10'b0101010010;	
				next_state = P5;
				next_rest_time = P5_time;
			end
			P5: begin
			    light = 10'b1001010010;	
				next_state = P6;
				next_rest_time = P6_time;
			end
			P6: begin
			    light = 10'b1001000101;	
				next_state = P7;
				next_rest_time = P7_time;
			end
			P7: begin
			    light[9:1] = 9'b100100010;
				light[0] = clk2;
				next_state = P8;
				next_rest_time = P8_time;
			end			
			P8: begin
			    light = 10'b1001000110;	
				next_state = P9;
				next_rest_time = P9_time;
			end			
			P9: begin
				light = 10'b1001001010;	
				next_state = P10;
				next_rest_time = P10_time;
			end			
			P10: begin
				light = 10'b1001010010;	
				next_state = P1;
				next_rest_time = P1_time;
			end			
			default: begin
				light = 10'd0;
				next_state = IDLE;
			end		
		endcase
   end
	
	always@(posedge clk) begin
		if(rst == 1'b1) begin
			clk2 <= 1'b1;
			flash_count <= 33'd0;
		end
		else begin
			if(flash_count == 33'd1) begin
				clk2 <= ~clk2;	
				flash_count <= 33'd0;
			end
			else begin
				clk2 <= clk2;
				flash_count <= next_flash_count;
			end
		end
	end
   
	always@(posedge clk) begin
		if(rst == 1'b0) begin
			if(auto == 1'b1) begin
				if(auto_count == 26'd3)
					auto_count <= 26'd0;
				else
					auto_count <= next_auto_count;
			end
			else begin
				auto_count <= auto_count;
			end
		end
		else begin
			auto_count <= 26'd0;
		end
	end
	
	always@(posedge clk) begin
		if(rst == 1'b1) begin   // or negedge manual
			P1_time 	<= 7'd2;
			P2_time 	<= 7'd2;
			P3_time 	<= 7'd2;
			P4_time 	<= 7'd2;
			P5_time 	<= 7'd2;
			P6_time 	<= 7'd2;
			P7_time 	<= 7'd2;
			P8_time 	<= 7'd2;
			P9_time 	<= 7'd2;
			P10_time 	<= 7'd2;
			state 		<= IDLE;
		end
		else begin
			if(auto == 1'b1) begin
				if(rest_time != 6'd0) begin
					state <= state;
						if(auto_count == 26'd0)
							rest_time <= rest_time - 1;
						else
							rest_time <= rest_time;
				end
				else begin
					state <= next_state;
					rest_time <= next_rest_time;
				end
			end
			else begin
				if(manual == 1'b0) begin
					if(had_push == 1'b0) begin
						state <= next_state;
						rest_time <= next_rest_time;
						had_push <= 1'b1;
					end
					else begin
						state <= state;
						rest_time <= rest_time;
						had_push <= had_push;
					end
				end
				else begin
					state <= state;
					rest_time <= rest_time;
					had_push <= 1'b0;
				end
			end
		end
	end						
endmodule						