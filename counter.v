`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/22/2024 11:24:42 AM
// Design Name: 
// Module Name: counter
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


module counter(rst, ps, adj, select, clk, clk_adj, sec1, sec0, min1, min0);

input wire rst;
input wire ps;
input wire [1:0] adj;
input wire select;
input wire clk; 
input wire clk_adj;

output wire [3:0] sec1;
output wire [3:0] sec0;
output wire [3:0] min1;
output wire [3:0] min0;


reg clk_reg;
wire clock;

// select clock based on adjust value
always@(*) begin
    if(adj == 0) begin
        clk_reg = clk;
    end
    else begin
        clk_reg = clk_adj;
    end
end

assign clock = clk_reg;

// pause 
reg pause = 0;
always @(posedge clk or posedge ps) begin
    if(ps) begin
        pause <= ~pause;
    end
    else begin 
        pause <= pause;
    end 
end


// reset the counters 
reg [3:0] counter_sec1;
reg [3:0] counter_sec0;
reg [3:0] counter_min1;
reg [3:0] counter_min0;

always @(posedge clock or posedge rst) begin
    if(rst == 1'b1) begin
        counter_sec1 <= 4'b0000;
        counter_sec0 <= 4'b0000;
        counter_min1 <= 4'b0000;
        counter_min0 <= 4'b0000;
    end
    
    else if(adj == 0 && ~pause) begin
        // change seconds when adjust = 0
        if (counter_sec1 == 9 && counter_sec0 == 5) begin
            //if 59 seconds, need to increment minutes
            counter_sec1 <= 4'b0;
            counter_sec0 <= 4'b0;
            
            if(counter_min1 == 9 && counter_min0 == 5) begin
                //if 59 minutes, need to reset to 00:00
                counter_min1 <= 4'b0;
                counter_min0 <= 4'b0;
            end 
            else if (counter_min1 == 9) begin
                //increment 10s place for minutes
                counter_min1 <= 4'b0;
                counter_min0 <= counter_min0 + 4'b1;
            end 
            else begin
                counter_min1 <= counter_min1 + 4'b1;
            end
        end 
        else if (counter_sec1 == 9) begin
            //increment 10s place for seconds
            counter_sec1 <= 4'b0;
            counter_sec0 <= counter_sec0 + 4'b1;
        end
        else begin
            counter_sec1 <= counter_sec1 + 4'b1;
        end 
        
    end
    else if(adj == 1 && ~pause && select) begin
        // change seconds when adjust = 1 and select 
         if (counter_sec1 == 9 && counter_sec0 == 5) begin
            //if 59 seconds, need to increment minutes
            counter_sec1 <= 4'b0;
            counter_sec0 <= 4'b0;
         end
         else if (counter_sec1 == 9) begin
            //increment 10s place for seconds
            counter_sec1 <= 4'b0;
            counter_sec0 <= counter_sec0 + 4'b1;
         end
         else begin
             counter_sec1 <= counter_sec1 + 4'b1;
         end 
    end
    else if(adj == 1 && ~pause && ~select) begin
        // change minutes when adjust = 1 and not select 
      if (counter_min1 == 9 && counter_min0 == 5) begin
        //if 59 seconds, need to increment minutes
        counter_min1 <= 4'b0;
        counter_min0 <= 4'b0;
      end
      else if (counter_min1 == 9) begin
        //increment 10s place for seconds
        counter_min1 <= 4'b0;
        counter_min0 <= counter_min0 + 4'b1;
      end
      else begin
        counter_min1 <= counter_min1 + 4'b1;
      end 
    end
end

assign sec1 = counter_sec1;
assign sec0 = counter_sec0;
assign min1 = counter_min1;
assign min0 = counter_min0;

endmodule
