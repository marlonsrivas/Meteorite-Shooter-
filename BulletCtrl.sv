
module Ship_Bullet 
	#(parameter c_GameWidth = 40,
	  parameter c_GameHeight = 30)
	  
( input logic i_Clk,
  input logic i_GameActive, shoot,
  input logic [5:0] i_ColCountDiv,BullCounter,
  input logic [5:0] i_RowCountDiv,
  output logic o_DrawBull,
  output logic [5:0] o_BullX = 0,
  output logic [5:0] o_BullY = 0);
  
//Set the speed of the Bullet movement
// In this case the bullet will move one board game unit
// every 50 ms that the button is held down
parameter c_BullSpeed = 1250000;

logic [5:0] r_BullXPrev = 0;
logic [5:0] r_BullYPrev = 0;
logic [31:0] r_BullCount = 0;

logic[3:0] shotpress = 0;

//If button is pressed the bullet will leave its original position
always_ff @(posedge i_Clk)
begin

if(shoot == 1)

shotpress <=1;

else

shotpress <= 0;

end


always_ff @(posedge i_Clk)
begin
//if the game is not active the ball stays connected to the paddle

if(shoot == 1'b0)
begin
	o_BullX <= BullCounter + 2;
	o_BullY <= 28;
	r_BullXPrev <= c_GameWidth/2 + 1;
	r_BullYPrev <= c_GameHeight/2-1;	
end
// Update the ball counter continously. B movement update rate is 
//determined by input parameter. If ball counter is at its limit, update the ball
// position in both X and Y.
else 
	begin	
		if(r_BullCount < c_BullSpeed)
			r_BullCount <= r_BullCount + 1;
 else
  begin
	r_BullCount <= 0;
	
//Store prev ball location 
	r_BullXPrev <= o_BullX;
	r_BullYPrev <= o_BullY;

	
  if((r_BullYPrev < o_BullY && o_BullY == c_GameHeight -1) ||
     (r_BullYPrev > o_BullY && o_BullY != 0))
	 
	  o_BullY <= o_BullY - 1; // Up 
   else
     o_BullY <= o_BullY + 1;
end
end

end // End of flip flop


//Draw the ball if the X and Y position coincide with the column and row
always_ff @(posedge i_Clk)
begin
	if(i_ColCountDiv == o_BullX && i_RowCountDiv == o_BullY)
	
		o_DrawBull <= 1'b1;	
	else 
		o_DrawBull <= 1'b0;
end


endmodule // Ship_bullet Control













