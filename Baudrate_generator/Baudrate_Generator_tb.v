
module Baudrate_Generator_tb;

reg pclk, preset_n, spiswai, cpol, cpha, ss;
reg [1:0] spi_mode;
reg [2:0] sppr, spr;

wire sclk;
wire miso_receive_posedge, miso_receive_negedge;
wire mosi_send_posedge, mosi_send_negedge;
wire [11:0] baud_rate_divisor;

Baud_generator dut(
    pclk,
    preset_n,
    spi_mode,
    spiswai,
    sppr,
    spr,
    cpol,
    cpha,
    ss,
    sclk,
    miso_receive_posedge,
    miso_receive_negedge,
    mosi_send_posedge,
    mosi_send_negedge,
    baud_rate_divisor
);

always #5 pclk = ~pclk;


task reset;
begin
    preset_n = 0;
    @(negedge pclk);
    preset_n = 1;
end
endtask


task data(input [2:0] sppr_val,
          input [2:0] spr_val,
          input       cpol_val,
          input       cpha_val);
begin
    spi_mode = 2'b00;
    sppr     = sppr_val;
    spr      = spr_val;
    spiswai  = 1'b0;
    ss       = 1'b0;
    cpol     = cpol_val;
    cpha     = cpha_val;

    @(negedge pclk);
end
endtask


initial begin

    pclk    = 0;
    preset_n = 1;
    spi_mode = 2'b00;
    spiswai = 0;
    ss      = 0;
    sppr    = 3'b000;
    spr     = 3'b000;
    cpol    = 0;
    cpha    = 0;

    reset;

   
    repeat(20)
        data(3'b000, 3'b001, 1'b0, 1'b0);

    // SPPR = 1, SPR = 1, CPOL = 0, CPHA = 0
    repeat(20)
        data(3'b001, 3'b001, 1'b0, 1'b0);

    // SPPR = 0, SPR = 2, CPOL = 0, CPHA = 0
    repeat(20)
        data(3'b000, 3'b010, 1'b0, 1'b0);

    // CPOL = 1, CPHA = 0
    repeat(20)
        data(3'b000, 3'b001, 1'b1, 1'b0);

    // CPOL = 0, CPHA = 1
    repeat(20)
        data(3'b000, 3'b001, 1'b0, 1'b1);

    // CPOL = 1, CPHA = 1
    repeat(20)
        data(3'b000, 3'b001, 1'b1, 1'b1);

    #100 $finish;

end

endmodule

