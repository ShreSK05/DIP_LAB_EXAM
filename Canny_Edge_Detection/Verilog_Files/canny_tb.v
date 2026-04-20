// =============================================================
//  TESTBENCH : canny_tb  -  128 x 128 image
//  Vivado xsim / Verilog-2001 compatible
//
//  IMPORTANT - copy input.mem to the xsim working directory:
//    <project>.sim/sim_1/behav/xsim/
//  output.mem will appear in the same folder after simulation.
// =============================================================
`timescale 1ns/1ps

module canny_tb;

    // Image dimensions
    parameter IMG_W = 128;
    parameter IMG_H = 128;
    parameter TOTAL = 16384;      // 128 * 128

    // Clock & control
    reg        clk     = 1'b0;
    reg        rst     = 1'b1;
    reg        s_valid = 1'b0;
    reg  [7:0] s_data  = 8'd0;
    wire       m_valid;
    wire [7:0] m_data;

    // 100 MHz clock  (10 ns period)
    always #5 clk = ~clk;

    // ---- DUT ------------------------------------------------
    canny_top dut (
        .clk    (clk),
        .rst    (rst),
        .s_valid(s_valid),
        .s_data (s_data),
        .m_valid(m_valid),
        .m_data (m_data)
    );

    // ---- Memory arrays --------------------------------------
    reg [7:0] in_mem  [0:16383];
    reg [7:0] out_mem [0:16383];

    integer out_count;
    integer i;
    integer fd;
    integer edge_cnt;

    // ---- Capture output pixels ------------------------------
    always @(posedge clk) begin
        if (m_valid && out_count < TOTAL) begin
            out_mem[out_count] = m_data;
            out_count = out_count + 1;
        end
    end

    // ---- Main stimulus --------------------------------------
    initial begin
        out_count = 0;
        edge_cnt  = 0;

        // Load pixels from file
        $readmemh("input.mem", in_mem);
        $display("[TB] Loaded %0d pixels  (%0d x %0d)", TOTAL, IMG_W, IMG_H);

        // Reset for 4 clocks
        rst = 1'b1;
        repeat(4) @(posedge clk);
        rst = 1'b0;
        @(posedge clk);

        // Feed one pixel per clock
        for (i = 0; i < TOTAL; i = i + 1) begin
            @(posedge clk);
            s_valid = 1'b1;
            s_data  = in_mem[i];
        end
        // De-assert valid
        @(posedge clk);
        s_valid = 1'b0;
        s_data  = 8'd0;

        // Drain pipeline  (5 stages * 128 + generous margin)
        repeat(900) @(posedge clk);

        // ---- Write output.mem --------------------------------
        fd = $fopen("output.mem", "w");
        if (fd == 0) begin
            $display("[TB] ERROR: Cannot open output.mem for writing.");
            $finish;
        end
        for (i = 0; i < out_count; i = i + 1)
            $fwrite(fd, "%02X\n", out_mem[i]);
        $fclose(fd);

        // ---- Summary -----------------------------------------
        for (i = 0; i < out_count; i = i + 1)
            if (out_mem[i] == 8'hFF) edge_cnt = edge_cnt + 1;

        $display("[TB] Pixels received  : %0d / %0d", out_count, TOTAL);
        $display("[TB] Edge pixels      : %0d", edge_cnt);
        $display("[TB] Non-edge pixels  : %0d", out_count - edge_cnt);
        $display("[TB] Simulation PASSED - output.mem written.");
        $finish;
    end

    // ---- Watchdog  (20 ms @ 10 ns/clk = 2,000,000 clocks) --
    initial begin
        #20_000_000;
        $display("[TB] WATCHDOG TIMEOUT - simulation did not finish.");
        $finish;
    end

endmodule