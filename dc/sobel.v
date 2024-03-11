`timescale 1ns / 1ns

module sobel (out_x, out_y, state, n_state, data, clk, rst);
    output [7:0] out_x, out_y;
    output [1:0] state, n_state;
    input [7:0] data;
    input clk, rst;

    //parameter INT = 8;
    reg [7:0] line_buffer [(482*2+3)-1:0];
    reg [1:0] state, n_state;
    reg [31:0] counter, counter_x;
    wire [9:0] sum_x, sum_y;
    integer i;

    assign sum_x = -line_buffer[0]-2*line_buffer[482]-line_buffer[964]+line_buffer[2]+2*line_buffer[484]+line_buffer[966];
    assign sum_y = line_buffer[0]+2*line_buffer[1]+line_buffer[2]-line_buffer[964]-2*line_buffer[965]-line_buffer[966];
    assign out_x = (sum_x > 100) ? 255 : 0;
    assign out_y = (sum_y > 100) ? 255 : 0;

    always @(*) begin
        case(state)
            2'd0: n_state = (counter < 966) ? 2'd0 : 2'd1;
            2'd1: n_state = (counter_x < 480) ? 2'd1 : 2'd2;
            2'd2: n_state = 2'd3;
            2'd3: n_state = 2'd1;
        endcase
    end

    always @(posedge clk) begin
        if (rst) begin
            state <= 2'd0;
            counter <= 0;
            counter_x <= 0;
            for(i = 0; i <= 966; i = i + 1) begin
                line_buffer[i] <= 0;
            end
        end
        else begin
            state <= n_state;
            counter <= counter+1;
            counter_x <= (n_state == 2'd1) ? counter_x+1 : 0;
            line_buffer[966] <= data;
            for(i = 0; i <= 965; i = i + 1) begin
                line_buffer[i] <= line_buffer[i+1];
            end
        end
    end
endmodule