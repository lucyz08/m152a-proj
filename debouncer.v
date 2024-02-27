`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2024 11:18:29 AM
// Design Name: 
// Module Name: debouncer
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module debouncer(btn, clk, btn_state);
    
    input btn;
    input clk;
    output btn_state;
    
    reg btn_state_reg = 0;
    reg [15:0] count;
    
    always @ (posedge clk)
    begin
        if(btn == 0) begin
            count <= 0;
            btn_state_reg <= 0;
        end
        else begin
            count <= count + 1'b1;
            if(count == 16'hffff) begin // maxxed out
                btn_state_reg <= 1;
                count <= 0;
            end
        end
    end
    
    assign btn_state = btn_state_reg;
            
         
endmodule
