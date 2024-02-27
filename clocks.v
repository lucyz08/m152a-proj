`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/20/2024 11:44:54 AM
// Design Name: 
// Module Name: clocks
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


module clocks(clk, rst, clk_2hz, clk_1hz, clk_fast, clk_blink);

input wire clk; //100HZ
input wire rst;

output wire clk_2hz;
output wire clk_1hz; 
output wire clk_fast;
output wire clk_blink;

reg clk_2hz_reg;
reg clk_1hz_reg; 
reg clk_fast_reg;
reg clk_blink_reg;

reg [31:0] clk_2hz_counter;
reg [31:0] clk_1hz_counter; 
reg [31:0] clk_fast_counter;
reg [31:0] clk_blink_counter;

localparam TWO_HZ_MAX = 25000000;
localparam ONE_HZ_MAX = 50000000;
localparam FAST_MAX = 50000;
localparam BLINK_MAX = 12500000;

//2hz clk
always @(posedge(clk) or posedge(rst)) begin

    if(rst == 1'b1) begin
        clk_2hz_counter <= 32'b0; 
        clk_2hz_reg <= 1'b0;
    end
    else if (clk_2hz_counter == TWO_HZ_MAX - 1) begin
        clk_2hz_counter <= 32'b0; 
        clk_2hz_reg <= ~clk_2hz;
    end
    else begin
        clk_2hz_counter <= clk_2hz_counter + 32'b1; 
        clk_2hz_reg <= clk_2hz;
    end
        
end

//1hz clk
always @(posedge(clk) or posedge(rst)) begin

    if(rst == 1'b1) begin
        clk_1hz_counter <= 32'b0; 
        clk_1hz_reg <= 1'b0;
    end
    else if (clk_1hz_counter == ONE_HZ_MAX - 1) begin
        clk_1hz_counter <= 32'b0; 
        clk_1hz_reg <= ~clk_1hz;
    end
    else begin
        clk_1hz_counter <= clk_1hz_counter + 32'b1; 
        clk_1hz_reg <= clk_1hz;
    end
        
end

//fast clk
always @(posedge(clk) or posedge(rst)) begin

    if(rst == 1'b1) begin
        clk_fast_counter <= 32'b0; 
        clk_fast_reg <= 1'b0;
    end
    else if (clk_fast_counter == FAST_MAX - 1) begin
        clk_fast_counter <= 32'b0; 
        clk_fast_reg <= ~clk_fast;
    end
    else begin
        clk_fast_counter <= clk_fast_counter + 32'b1; 
        clk_fast_reg <= clk_fast;
    end
        
end

//blink clk
always @(posedge(clk) or posedge(rst)) begin

    if(rst == 1'b1) begin
        clk_blink_counter <= 32'b0; 
        clk_blink_reg <= 1'b0;
    end
    else if (clk_blink_counter == BLINK_MAX - 1) begin
        clk_blink_counter <= 32'b0; 
        clk_blink_reg <= ~clk_blink;
    end
    else begin
        clk_blink_counter <= clk_blink_counter + 32'b1; 
        clk_blink_reg <= clk_blink;
    end
        
end

assign clk_2hz = clk_2hz_reg;
assign clk_1hz = clk_1hz_reg;
assign clk_fast = clk_fast_reg;
assign clk_blink = clk_blink_reg;
endmodule
