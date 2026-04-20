module gaussian_blur #(parameter W=16,parameter H=16)(
    input  wire clk,rst,in_valid,
    input  wire [7:0] din,
    output reg  out_valid,
    output reg  [7:0] dout
);
    wire w_v;
    wire [7:0] p00,p01,p02,p10,p11,p12,p20,p21,p22;
    window3x3 #(.W(W)) u0(clk,rst,in_valid,din,w_v,
        p00,p01,p02,p10,p11,p12,p20,p21,p22);
    reg [11:0] acc;
    always @(posedge clk or posedge rst) begin
        if(rst) begin out_valid<=0;dout<=0;acc<=0; end
        else if(w_v) begin
            acc = {4'b0,p00} + {3'b0,p01,1'b0} + {4'b0,p02} +
                  {3'b0,p10,1'b0} + {2'b0,p11,2'b0} + {3'b0,p12,1'b0} +
                  {4'b0,p20} + {3'b0,p21,1'b0} + {4'b0,p22};
            dout<=acc[11:4]; out_valid<=1;
        end else out_valid<=0;
    end
endmodule