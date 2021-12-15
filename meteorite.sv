module meteorite 
	#(parameter c_GameWidth = 40,
	  parameter c_GameHeight = 30,
	  parameter c_MeteoriteSpeed = 4000000)
	  
( input logic i_Clk,
  input logic i_GameActive,
  input logic [5:0] M_ColCountDiv,
  input logic [5:0] M_RowCountDiv,
  output logic o_DrawMet,
  output logic [5:0] M_MeteX = 0,
  output logic [5:0] M_MeteY = 0);
  

logic [5:0] r_BallXPrev = 0;
logic [5:0] r_BallYPrev = 0;
logic [31:0] r_PositionCount = 0;



always_ff @(posedge i_Clk)
begin

//If the game is not active the Meteorites will stay in their original position
if(i_GameActive == 1'b0)
begin
	M_MeteX <= c_GameWidth;
	M_MeteY <= c_GameHeight;
	r_BallXPrev <= c_GameWidth/2 + 1;
	r_BallYPrev <= c_GameHeight/2+1;	
end

// Update the meteorite counter continously. so movement update rate is 
//determined by input parameter. If Meteorite counter is at its limit, update the ball
// position in both X and Y.
else
	begin	
		if(r_PositionCount < c_MeteoriteSpeed)
		begin
			r_PositionCount <= r_PositionCount + 1;
		end
			
 else if (r_PositionCount == c_MeteoriteSpeed)
  begin
	M_MeteY <= M_MeteY + 1;
	r_PositionCount <= 0;
//Store prev Meteorite location 
	r_BallYPrev <= M_MeteY;
	end   
	
  if (r_PositionCount == c_MeteoriteSpeed/2)
  begin
  M_MeteX <= M_MeteX -1;
  end
  else if (r_PositionCount == c_MeteoriteSpeed/4)
  begin
  M_MeteX <= M_MeteX + 1;
  end
end    
end

// Meteorite Will draw if both Column and Row are equal to meteorite location
always_ff @(posedge i_Clk)
begin
	if(M_ColCountDiv == M_MeteX && M_RowCountDiv == M_MeteY)
	
		o_DrawMet <= 1'b1;	
	else 
		o_DrawMet <= 1'b0;
end


endmodule // Meteorite Control