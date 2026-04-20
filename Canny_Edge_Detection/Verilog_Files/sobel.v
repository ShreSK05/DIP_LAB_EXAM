module sobel #(parameter W=16,parameter H=16)(
    input  wire clk,rst,in_valid,
    input  wire [7:0] din,
    output reg  out_valid,
    output reg  [7:0] mag,
    output reg  [1:0] dir
);
    wire w_v;
    wire [7:0] p00,p01,p02,p10,p11,p12,p20,p21,p22;
    window3x3 #(.W(W)) u0(clk,rst,in_valid,din,w_v,
        p00,p01,p02,p10,p11,p12,p20,p21,p22);
 
    reg signed [10:0] Gx,Gy;
    reg        [10:0] aGx,aGy,gsum;
 
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            out_valid<=0;mag<=0;dir<=0;
            Gx<=0;Gy<=0;aGx<=0;aGy<=0;gsum<=0;
        end else if(w_v) begin
            Gx = -{3'b0,p00} + {3'b0,p02}
                 -{2'b0,p10,1'b0} + {2'b0,p12,1'b0}
                 -{3'b0,p20} + {3'b0,p22};
            Gy =  {3'b0,p00} + {2'b0,p01,1'b0} + {3'b0,p02}
                 -{3'b0,p20} - {2'b0,p21,1'b0} - {3'b0,p22};
            aGx = Gx[10] ? (~Gx+1'b1) : Gx;
            aGy = Gy[10] ? (~Gy+1'b1) : Gy;
            gsum= aGx+aGy;
            mag <= (gsum>11'd255) ? 8'hFF : gsum[7:0];
            if((aGy<<1) < aGx)           dir<=2'd0;
            else if((aGx<<1) < aGy)      dir<=2'd2;
            else if(Gx[10]==Gy[10])      dir<=2'd1;
            else                         dir<=2'd3;
            out_valid<=1;
        end else out_valid<=0;
    end
endmodule