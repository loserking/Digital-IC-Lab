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
						.auto(auto),			// SW0 		�}�l�q���۰ʹB�@
						.modify(modify),  		// SW1 		������ɶ��վ�Ҧ����}��
						.timeup(timeup),			// KEY1		�ɶ��[1
						.timedown(timedown),		// KEY2		�ɶ���1
						.phase_valid(phase_valid),	// KEY3		phase�T�w
						.manual(manual),         // KEY0     ��ʧ���phase
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
	