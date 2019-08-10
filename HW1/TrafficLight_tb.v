`timescale 1ns/10ps
`include "TrafficLight.v"

module TrafficLight_tb();
	
	reg				clk;
	reg				rst;
	reg				auto;
	reg				modify;
	reg				timeup;
	reg				timedown;
	reg				phase_valid;
	wire	[9:0]	light;
	
	
	TrafficLight_CU CU(	
						.clk(clk),
						.rst(rst),
						.auto(auto),			// SW0 		開始電路自動運作
						.modify(modify),  		// SW1 		切換到時間調整模式的開關
						.timeup(timeup),			// KEY1		時間加1
						.timedown(timedown),		// KEY2		時間減1
						.phase_valid(phase_valid),	// KEY3		phase確定
						.manual(manual),         // KEY0     手動改變phase
						.light(light)			// LEDR0~LEDR9
						);
						
	integer		clock;
	
	initial begin
		$fsdbDumpfile("TrafficLight.fsdb");
		$fsdbDumpvars();
		rst = 1'b0;
		auto = 1'b0;
		clk = 1'b0;
		clock = 0;
		
		#62 	rst = 1'b1;
		#80 	rst = 1'b0;
		#61 	auto = 1'b1;
		#2000	$finish;
		
	end
	
	always begin
		#5 clk = ~clk;
		clock = clock + 5;
	end
	
endmodule
	