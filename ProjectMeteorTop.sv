
module Project_MeteorTop
(input logic i_Clk,


// Buttons from the GoBoard
input logic i_Switch_1,
input logic i_Switch_2,
input logic i_Switch_3,
input logic i_Switch_4,

	//VGA Outputs
   output logic o_VGA_HSync,
   output logic o_VGA_VSync,
   output logic o_VGA_Red_0,
   output logic o_VGA_Red_1,
   output logic o_VGA_Red_2,
   output logic o_VGA_Grn_0,
   output logic o_VGA_Grn_1,
   output logic o_VGA_Grn_2,
   output logic o_VGA_Blu_0,
   output logic o_VGA_Blu_1,
   output logic o_VGA_Blu_2   
 );
 
 //Parameters for the screen
 parameter c_VideoWidth = 3;
 parameter c_TotalCols = 800;
 parameter c_TotalRows = 525;
 parameter c_ActiveCols = 640;
 parameter c_ActiveRows = 480;
 
 //RGB and porch signals from the game
 logic [c_VideoWidth-1:0] w_RedVideoMete, w_RedVideoPorch;
 logic [c_VideoWidth-1:0] w_GrnVideoMete, w_GrnVideoPorch;
 logic [c_VideoWidth-1:0] w_BluVideoMete, w_BluVideoPorch;
 
 
  // Generates Sync Pulses to run VGA
  VGA_Sync_Pulses #(.TOTAL_COLS(c_TotalCols),
                    .TOTAL_ROWS(c_TotalRows),
                    .ACTIVE_COLS(c_ActiveCols),
                    .ACTIVE_ROWS(c_ActiveRows)) VGA_Sync_Pulses_Inst 
  (.i_Clk(i_Clk),
   .o_HSync(w_HSync_VGA),
   .o_VSync(w_VSync_VGA),
   .o_Col_Count(),
   .o_Row_Count()
  );
  
// Debounce All Switches
Debounce_Switch Instance1 (
.i_Clk(i_Clk),
.i_Switch(i_Switch_1),
.o_Switch(w_Switch_1)
);

Debounce_Switch Instance2 (
.i_Clk(i_Clk),
.i_Switch(i_Switch_2),
.o_Switch(w_Switch_2)
);

Debounce_Switch Instance3 (
.i_Clk(i_Clk),
.i_Switch(i_Switch_3),
.o_Switch(w_Switch_3)
);

Debounce_Switch Instance4 (
.i_Clk(i_Clk),
.i_Switch(i_Switch_4),
.o_Switch(w_Switch_4)
);


//Main Game Code
Meteor_Top #( 
			.c_TotalCols(c_TotalCols),
		   .c_TotalRows(c_TotalRows),
		   .c_ActiveCols(c_ActiveCols),
		   .c_ActiveRows(c_ActiveRows)) Meteor_Inst
(.i_Clk(i_Clk),
 .i_HSync(w_HSync_VGA),
 .i_VSync(w_VSync_VGA),
 .i_GameStart(w_Switch_3),
 .i_PaddleRT(w_Switch_1),
 .i_PaddleLT(w_Switch_2),
 .shoot(w_Switch_4),
 .o_HSync(w_HSyncPong),
 .o_VSync(w_VSyncPong),
 .o_RedVideo(w_RedVideoMete),
 .o_GreenVideo(w_GrnVideoMete),
 .o_BluVideo(w_BluVideoMete));
 
 
   VGA_Sync_Porch  #(.VIDEO_WIDTH(c_VideoWidth),
                    .TOTAL_COLS(c_TotalCols),
                    .TOTAL_ROWS(c_TotalRows),
                    .ACTIVE_COLS(c_ActiveCols),
                    .ACTIVE_ROWS(c_ActiveRows))
  VGA_Sync_Porch_Inst
   (.i_Clk(i_Clk),
    .i_HSync(w_HSyncPong),
    .i_VSync(w_VSyncPong),
    .i_Red_Video(w_RedVideoMete),
    .i_Grn_Video(w_GrnVideoMete),
    .i_Blu_Video(w_BluVideoMete),
    .o_HSync(o_VGA_HSync),
    .o_VSync(o_VGA_VSync),
    .o_Red_Video(w_RedVideoPorch),
    .o_Grn_Video(w_GrnVideoPorch),
    .o_Blu_Video(w_BluVideoPorch));
	
	
//VGA outputs	
  assign o_VGA_Red_0 = w_RedVideoPorch[0];
  assign o_VGA_Red_1 = w_RedVideoPorch[1];
  assign o_VGA_Red_2 = w_RedVideoPorch[2];
   
  assign o_VGA_Grn_0 = w_GrnVideoPorch[0];
  assign o_VGA_Grn_1 = w_GrnVideoPorch[1];
  assign o_VGA_Grn_2 = w_GrnVideoPorch[2];
 
  assign o_VGA_Blu_0 = w_BluVideoPorch[0];
  assign o_VGA_Blu_1 = w_BluVideoPorch[1];
  assign o_VGA_Blu_2 = w_BluVideoPorch[2];
  
 endmodule
 