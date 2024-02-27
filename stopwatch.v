`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/08/2024 11:17:57 AM
// Design Name: 
// Module Name: stopwatch
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


module stopwatch(clk, btnR, btnC, sw, seg, an);
    
    input wire clk; //clock
    input wire btnR; //reset
    input wire btnC; //pause
    input wire [1:0] sw; //select, adjust
    
    output reg[6:0] seg;
    output reg[3:0] an; 
    
    wire [3:0] sec1;
    wire [3:0] sec0;
    wire [3:0] min1;
    wire [3:0] min0;
    
    wire [6:0] sec1_seg;
    wire [6:0] sec0_seg;
    wire [6:0] min1_seg;
    wire [6:0] min0_seg;
    
    wire clk_2hz;
    wire clk_1hz;
    wire clk_fast;
    wire clk_blink;
    
    wire btnR_st;
    wire btnC_st;
    
    debouncer reset(.btn(btnR), .clk(clk), .btn_state(btnR_st));
    debouncer pause(.btn(btnC), .clk(clk), .btn_state(btnC_st));

    
    clocks clk_wires(.clk(clk), .rst(btnR_st), .clk_2hz(clk_2hz), .clk_1hz(clk_1hz), .clk_fast(clk_fast), .clk_blink(clk_blink));
    
    counter decide_digits(.rst(btnR_st), .ps(btnC_st), .adj(sw[1]), .select(sw[0]), .clk(clk_1hz), .clk_adj(clk_2hz), .sec1(sec1), .sec0(sec0), .min1(min1), .min0(min0));
    
    //display the 4 digits
    digit_to_segment display_sec1(.digit(sec1), .segment(sec1_seg));
    digit_to_segment display_sec0(.digit(sec0), .segment(sec0_seg));
    digit_to_segment display_min1(.digit(min1), .segment(min1_seg));
    digit_to_segment display_min0(.digit(min0), .segment(min0_seg));
    
    reg[1:0] dig_counter = 2'b00;
    
    reg blink_sec = 1'b0;
    reg blink_min = 1'b0;
    
    always @(posedge clk_fast) begin
        if (sw[1] == 1'b0) begin //if adjust = 0 (normal mode)
            case(dig_counter)
                2'b00: begin
                    seg <= sec1_seg;
                    an <= 4'b1110;
                end
                2'b01: begin
                    seg <= sec0_seg;
                    an <= 4'b1101;
                end
                2'b10: begin
                    seg <= min1_seg;
                    an <= 4'b1011;
                end
                2'b11: begin
                    seg <= min0_seg;
                    an <= 4'b0111;
                end
                default: begin 
                    seg <= 7'b1111111; //off
                    an <= 4'b1111;
                end
            endcase
            
            // loop through the anodes to display all digits
            if(dig_counter == 2'b11) begin
                dig_counter <= 2'b00;
            end
            else begin
                dig_counter <= dig_counter + 2'b01;
            end
        end
        if (sw[1] == 1'b1) begin // if adjust = 1 
            if (sw[0] == 1'b0) begin //if select = 0
                //blink minutes
                if (dig_counter == 2'b00) begin
                    an <= 4'b0111;
                    if (clk_blink) begin
                        seg <= min0_seg;
                    end
                    else begin
                        seg <= 7'b1111111; //off
                    end 
                    dig_counter <= dig_counter + 2'b01;
                end 
                else if (dig_counter == 2'b01) begin
                    an <= 4'b1011;
                    if (clk_blink) begin
                        seg <= min1_seg;
                    end
                    else begin
                        seg <= 7'b1111111; //off
                    end 
                    dig_counter <= dig_counter + 2'b01;
                end
                else if (dig_counter == 2'b10) begin
                    an <= 4'b1101;
                    seg <= sec0_seg;
                    dig_counter <= dig_counter + 2'b01;
               end
               else if (dig_counter == 2'b11) begin
                    an <= 4'b1110;
                    seg <= sec1_seg;
                    dig_counter <= dig_counter + 2'b01;
               end
            end 
            
            if(sw[0] == 1'b1) begin // if select = 1
                // blink seconds
                if (dig_counter == 2'b00) begin
                    an <= 4'b0111;
                    seg <= min0_seg; //off 
                    dig_counter <= dig_counter + 2'b01;
                end 
                else if (dig_counter == 2'b01) begin
                    an <= 4'b1011;
                    seg <= min1_seg;
                    dig_counter <= dig_counter + 2'b01;
                end
                else if (dig_counter == 2'b10) begin
                    an <= 4'b1101;
                    if (clk_blink) begin
                        seg <= sec0_seg;
                    end
                    else begin
                        seg <= 7'b1111111; //off
                    end 
                    dig_counter <= dig_counter + 2'b01;
               end
               else if (dig_counter == 2'b11) begin
                    an <= 4'b1110;
                    if (clk_blink) begin
                        seg <= sec1_seg;
                    end
                    else begin
                        seg <= 7'b1111111; //off
                    end 
                    dig_counter <= dig_counter + 2'b01;
               end                
            end 
           
        end
        
    end

endmodule
