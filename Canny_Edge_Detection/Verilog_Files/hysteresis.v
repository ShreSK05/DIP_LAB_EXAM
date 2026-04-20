module hysteresis #(parameter W=16,parameter H=16)(
    input  wire clk,rst,in_valid,
    input  wire [7:0] din,
    output reg  out_valid,
    output reg  [7:0] dout
);
    wire w_v;
    wire [7:0] p00,p01,p02,p10,p11,p12,p20,p21,p22;
    window3x3 #(.W(W)) u0(clk,rst,in_valid,din,w_v,
        p00,p01,p02,p10,p11,p12,p20,p21,p22);
 
    wire ns = (p00==8'hFF)||(p01==8'hFF)||(p02==8'hFF)||
              (p10==8'hFF)||              (p12==8'hFF)||
              (p20==8'hFF)||(p21==8'hFF)||(p22==8'hFF);
 
    always @(posedge clk or posedge rst) begin
        if(rst) begin out_valid<=0;dout<=0; end
        else if(w_v) begin
            out_valid<=1;
            if(p11==8'hFF)              dout<=8'hFF;
            else if(p11==8'h80 && ns)   dout<=8'hFF;
            else                        dout<=8'h00;
        end else out_valid<=0;
    end
endmodule