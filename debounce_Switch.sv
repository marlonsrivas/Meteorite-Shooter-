// Marlon Rivas Laboratory 1
	
module Debounce_Switch (

input logic i_Clk,
input logic i_Switch,
output logic o_Switch);

logic c_DEBOUNCE_LIMIT = 250000; // 10ms at 25MHz

logic r_State = 1'b0;
logic [17:0] r_Count = 0; // 2^18 so that counter has enough bits

always_ff @(posedge i_Clk)
begin
	
if(i_Switch !== r_State && r_Count < c_DEBOUNCE_LIMIT)

begin
			
r_Count <= r_Count +1; 
			
end
	
else if (r_Count == c_DEBOUNCE_LIMIT)
begin 
r_Count <=0;
r_State <= i_Switch;
end
		
else
begin	
r_Count <=0;			
end
end
	
assign o_Switch = r_State;
	
endmodule 




