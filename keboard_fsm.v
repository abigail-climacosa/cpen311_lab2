module keyboard_fsm(key_data, clk, forward_backward, play_stop, restart, state);

	input [7:0] key_data;		//in simple_ipod_solution.v : kbd_received_ascii_code
	input clk;

	output reg forward_backward, play_stop, restart;

	output reg [3:0] state; // 5 states
	reg [3:0] prev_state;
	logic restart_pushed;

	// Keys:			Key on keyboard:
	// Play				E	
	// Stop				D
	// Backward 		B				Note: end -> beginning
	// Forward			F					  beginning -> end
	// Restart			R					  if R is pushed but the song is going backward, the song has to start at the END, not at the BEGINNING

	// STATE: order of bits are: extra bit, forward(0)/backward(1), play(1)/pause(0), restart  
	parameter FORWARD_PLAY =	4'b0010;
	parameter FORWARD_STOP = 	4'b0000;	
	parameter BACKWARD_PLAY = 	4'b0110;
	parameter BACKWARD_STOP =	4'b0100;

	//Uppercase Letters 
	parameter character_B = 8'h42;
	parameter BACKWARD =	8'h42;
	parameter character_D = 8'h44;
	parameter STOP =		8'h44;
	parameter character_E = 8'h45;
	parameter PLAY =		8'h45;
	parameter character_F = 8'h46;
	parameter FORWARD =		8'h46;
	parameter character_R = 8'h52;


	// combinational logic for outputs
	assign forward_backward = state[2];
	assign play_stop = state[1];
//	assign restart = state[0];
//	assign restart = rst;
	
	// combinational logic for RESTART
//	always_comb
//	begin
//	case(key_data)
//		character_B: restart_pushed = 1'b0;
//		character_D: restart_pushed = 1'b0;
//		character_E: restart_pushed = 1'b0;
//		character_F: restart_pushed = 1'b0;
//		character_R: restart_pushed = 1'b1;
//		default: restart_pushed = 1'b0;
//	endcase
//	end
	
	
	// sequential logic for state
	always_ff @(posedge clk)
	begin
	
	case (key_data)
		character_B: restart_pushed <= 1'b0;
		character_D: restart_pushed <= 1'b0;
		character_E: restart_pushed <= 1'b0;
		character_F: restart_pushed <= 1'b0;
		character_R: restart_pushed <= 1'b1;
		default: begin 
			restart_pushed = 1'b0;
			restart = 1'b0;
			end
	endcase
		
	if (restart_pushed) 
		restart = 1'b0;
	else if (!restart_pushed & (key_data == character_R))
		restart = 1'b1;
	
	case (state)
		FORWARD_PLAY: begin
			if (key_data == STOP) state <= FORWARD_STOP;
			else if (key_data == BACKWARD) state <= BACKWARD_PLAY;
			else state <= FORWARD_PLAY;
			end
		FORWARD_STOP: begin
			if (key_data == STOP) state <= FORWARD_STOP;
			else if (key_data == BACKWARD) state <= BACKWARD_STOP;
			else state <= FORWARD_PLAY;
			end
		BACKWARD_PLAY: begin
			if (key_data == STOP) state <= BACKWARD_STOP;
			else if (key_data == BACKWARD) state <= BACKWARD_PLAY;
			else state <= FORWARD_PLAY;
			end
		BACKWARD_STOP: begin
			if (key_data == STOP) state <= BACKWARD_STOP;
			else if (key_data == BACKWARD) state <= BACKWARD_STOP;
			else state <= FORWARD_STOP;
			end
		default: state <= FORWARD_PLAY;
	endcase
	end

	
endmodule
