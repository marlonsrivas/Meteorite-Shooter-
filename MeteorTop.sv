module Meteor_Top 
	#(parameter VIDEO_WIDTH = 3,
	  parameter c_TotalCols = 800,
	  parameter c_TotalRows = 525,
	  parameter c_ActiveCols = 640,
	  parameter c_ActiveRows = 480)
	  
(input logic i_Clk,i_HSync,i_VSync,
// Game Start Button
input logic i_GameStart,shoot,
// Player control paddles
input logic i_PaddleRT,i_PaddleLT,

//output Video
output logic o_HSync,o_VSync,
output logic[3:0] o_RedVideo,o_GreenVideo,o_BluVideo 	 
);

parameter c_GameWidth = 40;
parameter c_GameHeight = 30;
parameter c_ScoreLimit = 9;

//Paddle size and vertical position
parameter c_PaddleHeight = 6;
parameter c_PaddleColP1 = 29; 


// State machine parameters
parameter IDLE = 3'b000;
parameter RUNNINGLEVEL1 = 3'b001;
parameter PLAYERWIN = 3'b010;
parameter CLEANUP = 3'b011;

//State machine and its first state
logic [2:0] r_SM_Main = IDLE;

logic w_HSync, w_VSync;
// Columns and rows on the screen
logic [9:0] w_ColCount,w_RowCount;

//Draw paddle and bullet
logic w_DrawPaddleP1;
logic[5:0] w_PaddleYP1;
logic w_DrawBall, w_DrawAny;
logic[5:0] w_BullX, w_BullY;
logic [5:0] Bulletcounter; 
logic Bulletdest, BulletOn;


//RGB patterns
  logic [VIDEO_WIDTH-1:0] Pattern_Red, pattern;
  logic [VIDEO_WIDTH-1:0] Pattern_Grn;
  logic [VIDEO_WIDTH-1:0] Pattern_Blu;

//Divided Version of the Rw/Col Counters
// Allows us to make the board 40x30
logic [5:0] w_ColCountDiv, w_RowCountDiv;


  Sync_To_Count #(.TOTAL_COLS(c_TotalCols),
                  .TOTAL_ROWS(c_TotalRows)) Sync_To_Count_inst 
  (.i_Clk      (i_Clk),
   .i_HSync    (i_HSync),
   .i_VSync    (i_VSync),
   .o_HSync    (w_HSync),
   .o_VSync    (w_VSync),
   .o_Col_Count(w_ColCount),
   .o_Row_Count(w_RowCount));
  
//Register syncs to align output data
  always_ff @(posedge i_Clk)
  begin
	o_HSync <= w_HSync;
	o_VSync <= w_VSync;
  end
  
// Drop 4 LSBs which effectively divides by 16
assign w_ColCountDiv = w_ColCount[9:4];
assign w_RowCountDiv = w_RowCount[9:4];

//Instantiation of Paddle Control + Draw for Player 
 Paddle_Ctrl #(.c_PlayerPaddleX(c_PaddleColP1),
				   .c_GameHeight(c_GameHeight + 10)) P1_Inst 
(.i_Clk(i_Clk),
 .i_PaddleRight(i_PaddleRT),
 .i_PaddleLeft(i_PaddleLT),
 .i_ColCountDiv(w_ColCountDiv),
 .i_RowCountDiv(w_RowCountDiv),  
 .o_DrawPaddle(w_DrawPaddleP1),
 .o_PaddleY(w_PaddleYP1));


// Instantiation of Bullet Control + Draw Bullet
Ship_Bullet #(.c_GameWidth(c_GameWidth ),
			.c_GameHeight(c_GameHeight)) Bullet_Inst
			
(.i_Clk(i_Clk),
 .BullCounter(Bulletcounter),
 .i_GameActive(i_GameActive),
 .shoot(shoot),
 .i_ColCountDiv(w_ColCountDiv),
 .i_RowCountDiv(w_RowCountDiv),
 .o_DrawBull(w_DrawBull),
 .o_BullX(w_BullX),
 .o_BullY(w_BullY)
);

	

//Draw Meteorites and RGB colors
logic w_DrawMets,w_DrawMets1,w_DrawMets2,w_DrawMets3,w_DrawMets4,w_DrawMets5,w_DrawMets6,w_DrawMets7;
logic w_DrawMete1,w_DrawMete2,w_DrawMete3,w_DrawMete4,w_DrawMete5,w_DrawMete6,w_DrawMete7,w_DrawMete8;
logic [5:0] M_MeteX,M_BAAX, M_Mete3X, M_Mete4X,M_Mete5X,M_Mete6X,M_Mete7X,M_Mete8X;
logic [5:0] M_MeteY,M_BAAY, M_Mete3Y, M_Mete4Y,M_Mete5Y,M_Mete6Y,M_Mete7Y,M_Mete8Y;

//Speed Control for meteorites now its moving 
parameter speed1 = 12000000; //Move one board game unit every 0.48 Seconds
parameter speed2 = 11000000; // Move one board game unit every 0.44 seconds

//Parameter to turn metorites ON or OFF
logic aliendest, aliendest3,aliendest4,aliendest5;
logic aliendest1 ,aliendest2,aliendest6,aliendest7;


//Meteorites instantiation and Draw single meteorites
meteorite #(.c_GameWidth(5),
			.c_GameHeight(5),
			.c_MeteoriteSpeed(speed1)) 
mete1			
(
.i_Clk(i_Clk),
 .i_GameActive(w_GameActive),
 .M_ColCountDiv(w_ColCountDiv),
 .M_RowCountDiv(w_RowCountDiv),
 .o_DrawMet(w_DrawMete1),
 .M_MeteX(M_MeteX),
 .M_MeteY(M_MeteY)
);


meteorite #(.c_GameWidth(15),
			.c_GameHeight(5),
			.c_MeteoriteSpeed(speed2)) 
mete2		
(
.i_Clk(i_Clk),
 .i_GameActive(w_GameActive),
 .M_ColCountDiv(w_ColCountDiv),
 .M_RowCountDiv(w_RowCountDiv),
 .o_DrawMet(w_DrawMete2),
 .M_MeteX(M_BAAX),
 .M_MeteY(M_BAAY)
);


meteorite #(.c_GameWidth(25),
			.c_GameHeight(5),
			.c_MeteoriteSpeed(speed1)) 
mete3			
(
.i_Clk(i_Clk),
 .i_GameActive(w_GameActive),
 .M_ColCountDiv(w_ColCountDiv),
 .M_RowCountDiv(w_RowCountDiv),
 .o_DrawMet(w_DrawMete3),
 .M_MeteX(M_Mete3X),
 .M_MeteY(M_Mete3Y)
);


meteorite #(.c_GameWidth(30),
			.c_GameHeight(2),
			.c_MeteoriteSpeed(speed2)) 
mete4		
(
.i_Clk(i_Clk),
 .i_GameActive(w_GameActive),
 .M_ColCountDiv(w_ColCountDiv),
 .M_RowCountDiv(w_RowCountDiv),
 .o_DrawMet(w_DrawMete4),
 .M_MeteX(M_Mete4X),
 .M_MeteY(M_Mete4Y)
);

meteorite #(.c_GameWidth(10),
			.c_GameHeight(2),
			.c_MeteoriteSpeed(speed1)) 
mete5			
(
.i_Clk(i_Clk),
 .i_GameActive(w_GameActive),
 .M_ColCountDiv(w_ColCountDiv),
 .M_RowCountDiv(w_RowCountDiv),
 .o_DrawMet(w_DrawMete5),
 .M_MeteX(M_Mete5X),
 .M_MeteY(M_Mete5Y)
);


meteorite #(.c_GameWidth(20),
			.c_GameHeight(2),
			.c_MeteoriteSpeed(speed2)) 
mete6		
(
.i_Clk(i_Clk),
 .i_GameActive(w_GameActive),
 .M_ColCountDiv(w_ColCountDiv),
 .M_RowCountDiv(w_RowCountDiv),
 .o_DrawMet(w_DrawMete6),
 .M_MeteX(M_Mete6X),
 .M_MeteY(M_Mete6Y)
);

/*
meteorite #(.c_GameWidth(33),
			.c_GameHeight(2),
			.c_MeteoriteSpeed(speed1)) 
mete7			
(
.i_Clk(i_Clk),
 .i_GameActive(w_GameActive),
 .M_ColCountDiv(w_ColCountDiv),
 .M_RowCountDiv(w_RowCountDiv),
 .o_DrawMet(w_DrawMete7),
 .M_MeteX(M_Mete7X),
 .M_MeteY(M_Mete7Y)
);

/*
meteorite #(.c_GameWidth(35),
			.c_GameHeight(5),
			.c_MeteoriteSpeed(speed2)) 
mete8		
(
.i_Clk(i_Clk),
 .i_GameActive(w_GameActive),
 .M_ColCountDiv(w_ColCountDiv),
 .M_RowCountDiv(w_RowCountDiv),
 .o_DrawMet(w_DrawMete8),
 .M_MeteX(M_Mete8X),
 .M_MeteY(M_Mete8Y)
);
*/


// Counter that keeps bullet attached to the position of the paddle (move at the same time)
always_ff @(posedge i_Clk)
begin
Bulletcounter <= w_PaddleYP1;
end



// State machine that controls the game
always_ff @(posedge i_Clk)
begin
 case(r_SM_Main)
 
//Stay in this state until game start button is hit
	IDLE:
	begin
		if(i_GameStart == 1'b1)
		begin
			aliendest <= 0;
			aliendest1 <= 0;
			aliendest2 <= 0;
			aliendest3 <= 0;
			aliendest4 <= 0;
			BulletOn <= 0;
			aliendest5 <= 0;
			aliendest6 <= 0;
			aliendest7 <= 0;
			r_SM_Main <= RUNNINGLEVEL1;
			end
		else
			r_SM_Main <= IDLE;
	end
	
//Running Level 
	RUNNINGLEVEL1:
	begin 
	// If Bullet goes to the top or each meteorite touches the bottom of the screen GameOver
		if((w_BullY == 1 || (M_MeteY == 28 && aliendest == 0) || (M_BAAY == 28 && aliendest1 == 0 )|| (M_Mete3Y == 28 && aliendest3 == 0) || (M_Mete4Y == 28 && aliendest4 == 0) 
		|| (M_Mete5Y == 28 && aliendest5 == 0) || M_Mete6Y == 28 && aliendest6 == 0))
		begin
			BulletOn <= 1;
			r_SM_Main <= CLEANUP;
		end
//Individual case to create contact points for meteorites and bullet
		else if((w_BullY == M_MeteY && w_BullX == M_MeteX))
		begin
		aliendest <= 1;
		r_SM_Main <= RUNNINGLEVEL1;
		end
		
		else if ((w_BullY == M_BAAY && w_BullX == M_BAAX))
		begin
		aliendest1 <= 1;
		r_SM_Main <= RUNNINGLEVEL1;
		end
		
		else if ((w_BullY == M_Mete3Y && w_BullX == M_Mete3X))
		begin
		aliendest2 <= 1;
		r_SM_Main <= RUNNINGLEVEL1;
		end
		
		else if ((w_BullY == M_Mete4Y && w_BullX == M_Mete4X))
		begin
		aliendest3 <= 1;
		r_SM_Main <= RUNNINGLEVEL1;
		end
		
		else if ((w_BullY == M_Mete5Y && w_BullX == M_Mete5X))
		begin
		aliendest4 <= 1;
		r_SM_Main <= RUNNINGLEVEL1;
		end
		
		
		else if ((w_BullY == M_Mete6Y && w_BullX == M_Mete6X))
		begin
		aliendest5 <= 1;
		r_SM_Main <= RUNNINGLEVEL1;
		end
		
		else if ((w_BullY == M_Mete7Y && w_BullX == M_Mete7X))
		begin
		aliendest6 <= 1;
		r_SM_Main <= RUNNINGLEVEL1;
		end
		
		else if ((w_BullY == M_Mete8Y && w_BullX == M_Mete8X))
		begin
		aliendest7 <= 1;
		r_SM_Main <= RUNNINGLEVEL1;
		end
		// If all Meteorites are destroyed Player Wins
		else if (aliendest  && aliendest1 && aliendest2 &&aliendest3 &&aliendest4 &&aliendest5)
		begin
		r_SM_Main <= PLAYERWIN;
		end
		
	end //End Running
	
	PLAYERWIN:
	begin 
// If player wins turn OFF all the Meteorites and go back to Idle state
			aliendest <=  1;
			aliendest1 <= 1;
			aliendest2 <= 1;
			aliendest3 <= 1;
			aliendest4 <= 1;
			aliendest5 <= 1;
			aliendest6 <= 1;
			aliendest7 <= 1;
			
		if (w_BullY == 1)
		r_SM_Main <= IDLE;
		else
		r_SM_Main <= PLAYERWIN;
	end

	CLEANUP:
	begin
//If the Player loses turn ON all the meteorites and put them back in their original position and go back to IDLE
			aliendest <=  0;
			aliendest1 <= 0;
			aliendest2 <= 0;
			aliendest3 <= 0;
			aliendest4 <= 0;
			aliendest5 <= 0;
			aliendest6 <= 0;
			aliendest7 <= 0;
		r_SM_Main <= IDLE;
		
	end
		
 endcase

end


// Conditional Assignment based on State Machine State That helps control the Bullet
assign w_GameActive = (r_SM_Main == RUNNINGLEVEL1) ? 1'b1 : 1'b0;



//Conditional Statement that turns the meteorite on or off depending STATE Machine
assign w_DrawAny = w_DrawPaddleP1;
assign Bulletdest = (BulletOn    == 0) ? w_DrawBull   : 1'b0;
assign w_DrawMets = (aliendest   == 0) ? w_DrawMete1 : 1'b0;
assign w_DrawMets1 = (aliendest1 == 0) ? w_DrawMete2 : 1'b0;
assign w_DrawMets2 = (aliendest2 == 0) ? w_DrawMete3 : 1'b0;
assign w_DrawMets3 = (aliendest3 == 0) ? w_DrawMete4 : 1'b0;
assign w_DrawMets4 = (aliendest4 == 0) ? w_DrawMete5 : 1'b0;
assign w_DrawMets5 = (aliendest5 == 0) ? w_DrawMete6 : 1'b0;
assign w_DrawMets6 = (aliendest6 == 0) ? w_DrawMete7 : 1'b0;
assign w_DrawMets7 = (aliendest7 == 0) ? w_DrawMete8 : 1'b0;







//Assigns color to the background, set to Green and Blue 
//Using logical AND to select each pixel after 30 on the row and column side and turn it ON
//If it was changed for a logical OR then a grid would be created instead of the "Stars in the background"
assign Pattern_Red= 0;
assign Pattern_Grn = (((w_ColCount & 30) == 0 ) && ((w_RowCount & 30) == 0 )) ? {VIDEO_WIDTH{1'b1}} : 0;
assign Pattern_Blu = (((w_ColCount & 30) == 0 ) && ((w_RowCount & 30) == 0 )) ? {VIDEO_WIDTH{1'b1}} : 0;

//Turn Each Bits ON or OFF into the Corresponding RGB color (Meteorites Yellow) Player & bullet (Turqouise)
assign o_RedVideo =   (w_DrawMets ? 4'b1111 : 4'b0000)|(w_DrawMets1 ? 4'b1111 : 4'b0000)|(w_DrawMets2 ? 4'b1111 : 4'b0000)|(w_DrawMets3 ? 4'b1111 : 4'b0000)|
(w_DrawMets4 ? 4'b1111 : 4'b0000)|(w_DrawMets5 ? 4'b1111 : 4'b0000)|(w_DrawMets6 ? 4'b1111 : 4'b0000)|(w_DrawMets7 ? 4'b1111 : 4'b0000); ; // went from logical OR to bitwise OR

assign o_GreenVideo = Pattern_Grn|(Bulletdest ? 4'b1111 : 4'b0000) | (w_DrawAny ? 4'b1111 : 4'b0000)|  (w_DrawMets ? 4'b1111 : 4'b0000)|(w_DrawMets1 ? 4'b1111 : 4'b0000)|
(w_DrawMets2 ? 4'b1111 : 4'b0000)|(w_DrawMets3 ? 4'b1111 : 4'b0000)|(w_DrawMets4 ? 4'b1111 : 4'b0000)|(w_DrawMets5 ? 4'b1111 : 4'b0000)|(w_DrawMets6 ? 4'b1111 : 4'b0000)|(w_DrawMets7 ? 4'b1111 : 4'b0000);

assign o_BluVideo = Pattern_Blu | (w_DrawAny ? 4'b1111 : 4'b0000) | (Bulletdest ? 4'b1111 : 4'b0000);

endmodule // Meteorite Game


  
  
 
  
  
  
  
  
  