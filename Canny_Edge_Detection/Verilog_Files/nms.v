module nms (
    input  wire       clk,
    input  wire       rst,
    input  wire       in_valid,
    input  wire [7:0] mag_in,
    input  wire [1:0] dir_in,
    output reg        out_valid,
    output reg  [7:0] dout
);
    wire       wv;
    wire [7:0] m00,m01,m02,m10,m11,m12,m20,m21,m22;
 
    window3x3 u_win (
        .clk(clk),       .rst(rst),     .in_valid(in_valid), .din(mag_in),
        .out_valid(wv),
        .p00(m00), .p01(m01), .p02(m02),
        .p10(m10), .p11(m11), .p12(m12),
        .p20(m20), .p21(m21), .p22(m22)
    );
 
    // Delay dir_in by W+4 = 128+4 = 132 clocks to align with window output
    // pipe index 0..131  (132 entries)
    reg [1:0] dpipe [0:131];
    integer   kk;
 
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (kk = 0; kk <= 131; kk = kk + 1)
                dpipe[kk] <= 2'd0;
        end else begin
            dpipe[0] <= dir_in;
            for (kk = 1; kk <= 131; kk = kk + 1)
                dpipe[kk] <= dpipe[kk-1];
        end
    end
 
    wire [1:0] dir_c = dpipe[131];
 
    reg [7:0] n1, n2;
 
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            out_valid <= 1'b0;
            dout      <= 8'd0;
            n1        <= 8'd0;
            n2        <= 8'd0;
        end else if (wv) begin
            case (dir_c)
                2'd0 : begin n1 = m10; n2 = m12; end  // horizontal : left/right
                2'd1 : begin n1 = m02; n2 = m20; end  // 45 deg     : NE/SW
                2'd2 : begin n1 = m01; n2 = m21; end  // vertical   : top/bottom
                2'd3 : begin n1 = m00; n2 = m22; end  // 135 deg    : NW/SE
                default: begin n1 = m10; n2 = m12; end
            endcase
            dout      <= (m11 >= n1 && m11 >= n2) ? m11 : 8'h00;
            out_valid <= 1'b1;
        end else begin
            out_valid <= 1'b0;
        end
    end
endmodule