module edge_detect(input_signal, clk, output_pulse); // i might need a reset?
	input input_signal, clk;
	
	output output_pulse;
	
	logic signal_delay;
	
	always_ff @(posedge clk)
	begin
		signal_delay <= input_signal;
	end
	
	assign output_pulse = input_signal & ~signal_delay;

endmodule