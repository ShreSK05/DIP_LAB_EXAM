module canny_top (
    input  wire       clk,
    input  wire       rst,
    input  wire       s_valid,
    input  wire [7:0] s_data,
    output wire       m_valid,
    output wire [7:0] m_data
);
    // ---- Tuneable parameters --------------------------------
    parameter IMG_WIDTH  = 128;
    parameter IMG_HEIGHT = 128;
    parameter TH         = 8'd100;   // strong edge threshold
    parameter TL         = 8'd40;    // weak   edge threshold
    // ---------------------------------------------------------
 
    wire       gb_v;  wire [7:0] gb_d;
    wire       sb_v;  wire [7:0] sb_mag;  wire [1:0] sb_dir;
    wire       nm_v;  wire [7:0] nm_d;
    wire       dt_v;  wire [7:0] dt_d;
    wire       hy_v;  wire [7:0] hy_d;
 
    gaussian_blur u_gb (
        .clk(clk),        .rst(rst),
        .in_valid(s_valid), .din(s_data),
        .out_valid(gb_v),   .dout(gb_d)
    );
 
    sobel u_sb (
        .clk(clk),       .rst(rst),
        .in_valid(gb_v), .din(gb_d),
        .out_valid(sb_v), .mag(sb_mag), .dir(sb_dir)
    );
 
    nms u_nm (
        .clk(clk),       .rst(rst),
        .in_valid(sb_v), .mag_in(sb_mag), .dir_in(sb_dir),
        .out_valid(nm_v), .dout(nm_d)
    );
 
    double_threshold #(.TH(TH), .TL(TL)) u_dt (
        .clk(clk),       .rst(rst),
        .in_valid(nm_v), .din(nm_d),
        .out_valid(dt_v), .dout(dt_d)
    );
 
    hysteresis u_hy (
        .clk(clk),       .rst(rst),
        .in_valid(dt_v), .din(dt_d),
        .out_valid(hy_v), .dout(hy_d)
    );
 
    assign m_valid = hy_v;
    assign m_data  = hy_d;
 
endmodule
