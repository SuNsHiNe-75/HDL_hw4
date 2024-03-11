`timescale 1ns / 1ns
`define period          10
`define img_max_size    480*360*3+54
//---------------------------------------------------------------
//You need specify the path of image in/out
//---------------------------------------------------------------
`define path_img_in     "./cat.bmp"
`define path_img_out    "./cat_after_sobel_x.bmp"
`define path_img_out2    "./cat_after_sobel_y.bmp"

module HDL_HW4_TB;
    integer img_in;
    integer img_out, img_out2;
    integer offset;
    integer img_h;
    integer img_w;
    integer idx = 0;
    integer header;
    integer c = 0;
    reg         clk;
    reg         rst;
    reg  [7:0]  img_data [0:`img_max_size-1];
    reg  [7:0]  R;
    reg  [7:0]  G;
    reg  [7:0]  B;
    reg [19:0] Y;
    reg [7:0] G_P [0:482*362-1];

    reg [7:0] data;
    wire [7:0] out_x, out_y;
    wire [1:0] state, n_state;

    sobel uut(out_x, out_y, state, n_state, data, clk, rst);

//---------------------------------------------------------------------------------------Take out the color image(cat) of RGB----------------------------------------------
    //---------------------------------------------------------------
    //This initial block write the pixel 
    //---------------------------------------------------------------
    initial begin
        clk = 1'b1;
    #(`period)
        for (idx = 0; idx < (img_h+2)*(img_w+2); idx = idx+1) begin
            #(`period)
            R = img_data[c*3 + offset + 2];
            G = img_data[c*3 + offset + 1];
            B = img_data[c*3 + offset + 0];

            if(idx < 482)
                data = 0;
            else if (idx%482==481 || idx%482==0)
                data = 0;
            else if (idx > (img_h+2)*(img_w+2)-482)
                data = 0;
            else begin
                data = (R*1224 + G*2404+ B*466) >> 12;
                c = c+1;
            end
            if (state == 2'd1) begin
                if(out_x === 8'dx)
                    $fwrite(img_out, "%c%c%c", 0, 0, 0);
                else
                    $fwrite(img_out, "%c%c%c", out_x, out_x, out_x);
                if(out_y === 8'dx)
                    $fwrite(img_out2, "%c%c%c", 0, 0, 0);
                else
                    $fwrite(img_out2, "%c%c%c", out_y, out_y, out_y);
            end
        end
        $fclose(img_in);
        $fclose(img_out);
        $fclose(img_out2);
        $stop;
    end

    initial begin
        rst = 1; #2
        rst = 0;
    end
    //---------------------------------------------------------------
    //This initial block read the pixel 
    //---------------------------------------------------------------
    initial begin
        img_in  = $fopen(`path_img_in, "rb");
        img_out = $fopen(`path_img_out, "wb");
        img_out2 = $fopen(`path_img_out2, "wb");
        $fread(img_data, img_in);

        img_w   = {img_data[21],img_data[20],img_data[19],img_data[18]};
        img_h   = {img_data[25],img_data[24],img_data[23],img_data[22]};
        offset  = {img_data[13],img_data[12],img_data[11],img_data[10]};

        for(header = 0; header < 54; header = header + 1) begin
			$fwrite(img_out, "%c", img_data[header]);
            $fwrite(img_out2, "%c", img_data[header]);
        end
    end
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    always begin
		#(`period/2.0) clk <= ~clk;
	end
endmodule