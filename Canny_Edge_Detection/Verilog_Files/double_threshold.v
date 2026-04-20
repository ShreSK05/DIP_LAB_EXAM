module double_threshold #(parameter TH=8'd100,parameter TL=8'd40)(
    input  wire clk,rst,in_valid,
    input  wire [7:0] din,
    output reg  out_valid,
    output reg  [7:0] dout
);
    always @(posedge clk or posedge rst) begin
        if(rst) begin out_valid<=0;dout<=0; end
        else if(in_valid) begin
            out_valid<=1;
            if(din>=TH)      dout<=8'hFF;
            else if(din>=TL) dout<=8'h80;
            else             dout<=8'h00;
        end else out_valid<=0;
    end
endmodule