`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/22/2024 11:31:05 AM
// Design Name: 
// Module Name: digit_to_segment
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


module digit_to_segment(digit, segment);

input wire [3:0] digit; 
output reg [6:0] segment; 

always @ (*) begin
    case(digit)
        4'b0000: begin
            segment <= 7'b0000001; //0
        end
        4'b0001: begin
            segment <= 7'b1001111; //1
        end
        4'b0010: begin
            segment <= 7'b0010010; //2
        end
        4'b0011: begin
            segment <= 7'b0000110; //3
        end
        4'b0100: begin
            segment <= 7'b1001100; //4
        end
        4'b0101: begin
            segment <= 7'b0100100; //5
        end
        4'b0110: begin
            segment <= 7'b0100000; //6
        end
        4'b0111: begin
            segment <= 7'b0001111; //7
        end
        4'b1000: begin
            segment <= 7'b0000000; //8
        end
        4'b1001: begin
            segment <= 7'b0000100; //9
        end
        default: begin 
            segment <= 7'b1111111; 
        end
    endcase
end

endmodule
