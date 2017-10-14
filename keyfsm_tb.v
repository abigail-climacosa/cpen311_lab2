module keyfsm_tb;

	logic [7:0] key_data;		//in simple_ipod_solution.v : kbd_received_ascii_code
	logic clk;

	logic forward_backward, play_stop, restart;
	
	logic [3:0] state;
	
	keyboard_fsm DUT(key_data, clk, forward_backward, play_stop, restart, state);
	
	
	initial begin	
		clk=1'b1;
		forever begin
			#5 clk=~clk;
		end
	end
	
		//Uppercase Letters 
	parameter character_B =8'h42; // backward
	parameter character_D =8'h44; // stop
	parameter character_E =8'h45; // play
	parameter character_F =8'h46; // forward	
	
	initial begin
		key_data=8'h45; //E Start
		
		#20;
		
		key_data=8'h44; // D Stop
		
		#20;
		
		key_data=8'h45; // E start
		
		#5;
		key_data=8'h42; // B backward
		
		#30;
		
		key_data=8'h46; //F forward
		
		#10;
		
		key_data=8'h45; //E START
		
		#10;
		
		key_data=8'h44; // D stop
		
		#30;
		
		key_data=8'h45; // E start
		
		#20;	
	end

endmodule