	module Paddle_Ctrl 
	#(parameter c_PlayerPaddleX = 0,
	  parameter c_PaddleHeight = 4,
	  parameter c_GameHeight = 40)
	  
	(input logic i_Clk,i_PaddleRight,i_PaddleLeft,
	 input logic [5:0] i_ColCountDiv,
	 input logic [5:0] i_RowCountDiv,
	 output logic [5:0] o_PaddleY,
	 output logic o_DrawPaddle
	);
	
//Set the speed of the paddle movement
// In this case the paddle wil move one board game unit
// Every 50 ms that the btn is pressed down
parameter c_PaddleSpeed = 1250000;

logic [31:0] r_PaddleCount = 0;

logic w_PaddleCountEn;

// Only allow paddles to move if btn is pressed
// ^ is an XOR operation
	assign w_PaddleCountEn = i_PaddleRight ^ i_PaddleLeft;
	
always_ff @(posedge i_Clk)
begin
if(w_PaddleCountEn == 1'b1)
	begin
	if(r_PaddleCount == c_PaddleSpeed)
	
		r_PaddleCount <= 0;
	else
		r_PaddleCount <= r_PaddleCount +1;
	end


//Update the paddle location slowly. Only allowed when the Paddle
// count reaches its limit. dont update if paddle is at the right or left side
	if(i_PaddleRight == 1'b1 && r_PaddleCount == c_PaddleSpeed && o_PaddleY != 0)
	
		o_PaddleY <= o_PaddleY - 1;
		
	else if(i_PaddleLeft == 1'b1 && r_PaddleCount == c_PaddleSpeed && o_PaddleY !== c_GameHeight - c_PaddleHeight - 1)
	
		o_PaddleY <= o_PaddleY + 1;
		
end

// Draws the paddles as determined by input parameter 
// c_PlayerPaddleX as a o_PaddleY
always_ff @(posedge i_Clk)
begin

//Draws the paddle in a single row for each of the paddles. 
//Range of rows is determined by c_PaddleHeight

if(i_RowCountDiv == c_PlayerPaddleX && i_ColCountDiv >= o_PaddleY && i_ColCountDiv <= o_PaddleY + c_PaddleHeight)

	o_DrawPaddle <= 1'b1;
else
	o_DrawPaddle <= 1'b0;

end

endmodule // Meteorite Game paddle control
