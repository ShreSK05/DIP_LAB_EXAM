module window3x3 (
    input  wire       clk,
    input  wire       rst,
    input  wire       in_valid,
    input  wire [7:0] din,
    output reg        out_valid,
    output reg  [7:0] p00, output reg [7:0] p01, output reg [7:0] p02,
    output reg  [7:0] p10, output reg [7:0] p11, output reg [7:0] p12,
    output reg  [7:0] p20, output reg [7:0] p21, output reg [7:0] p22
);
    // W = 128  ->  col_cnt is 7-bit (0-127)
    reg [7:0] lb0 [0:127];   // line buffer: middle row
    reg [7:0] lb1 [0:127];   // line buffer: oldest row
 
    reg [7:0] cur0, cur1, cur2;   // newest row  (3-tap SR)
    reg [7:0] mid0, mid1, mid2;   // middle row
    reg [7:0] old0, old1, old2;   // oldest row
 
    reg [6:0] col_cnt;            // 7 bits: 0-127
    integer   idx;
 
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            col_cnt   <= 7'd0;
            out_valid <= 1'b0;
            cur0<=8'd0; cur1<=8'd0; cur2<=8'd0;
            mid0<=8'd0; mid1<=8'd0; mid2<=8'd0;
            old0<=8'd0; old1<=8'd0; old2<=8'd0;
            p00<=8'd0; p01<=8'd0; p02<=8'd0;
            p10<=8'd0; p11<=8'd0; p12<=8'd0;
            p20<=8'd0; p21<=8'd0; p22<=8'd0;
            for (idx = 0; idx < 128; idx = idx + 1) begin
                lb0[idx] <= 8'd0;
                lb1[idx] <= 8'd0;
            end
        end else if (in_valid) begin
            // 1. Read old values from line buffers
            mid0 <= lb0[col_cnt];
            old0 <= lb1[col_cnt];
 
            // 2. Shift 3-tap shift registers
            cur2 <= cur1;  cur1 <= cur0;  cur0 <= din;
            mid2 <= mid1;  mid1 <= mid0;
            old2 <= old1;  old1 <= old0;
 
            // 3. Write line buffers
            lb1[col_cnt] <= lb0[col_cnt];
            lb0[col_cnt] <= din;
 
            // 4. Advance column counter
            col_cnt <= (col_cnt == 7'd127) ? 7'd0 : col_cnt + 7'd1;
 
            // 5. Present 3x3 window
            p00 <= old2;  p01 <= old1;  p02 <= old0;
            p10 <= mid2;  p11 <= mid1;  p12 <= mid0;
            p20 <= cur2;  p21 <= cur1;  p22 <= din;
 
            out_valid <= 1'b1;
        end else begin
            out_valid <= 1'b0;
        end
    end
endmodule