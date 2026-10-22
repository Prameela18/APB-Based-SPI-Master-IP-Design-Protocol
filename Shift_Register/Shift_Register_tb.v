module Shift_Register_tb();

reg pclk;
reg preset;
reg ss;
reg send_data;
reg lsbfe;
reg cpha;
reg cpol;

reg miso_recieve_sclk_o;
reg miso_recieve_sclk0_o;
reg mosi_send_sclk_o;
reg mosi_send_sclk0_o;

reg miso;
reg rcv_data;

reg [7:0] data_mosi;

wire mosi_o;
wire [7:0] data_miso_o;

reg spi_swai;
reg [2:0] sppr_i;
reg [2:0] spr_i;
reg [1:0] spi_mode;
reg sclk;
reg [11:0] brd;
reg [15:0] count;

parameter CYCLE = 10;

Shift_Register dut (
    .pclk(pclk),
    .preset(preset),
    .ss(ss),
    .send_data(send_data),
    .lsbfe(lsbfe),
    .cpha(cpha),
    .cpol(cpol),
    .miso_recieve_sclk(miso_recieve_sclk_o),
    .miso_recieve_sclk0(miso_recieve_sclk0_o),
    .mosi_send_sclk(mosi_send_sclk_o),
    .mosi_send_sclk0(mosi_send_sclk0_o),
    .data_mosi(data_mosi),
    .miso(miso),
    .rcv_data(rcv_data),
    .mosi(mosi_o),
    .data_miso(data_miso_o)
);

always #(CYCLE/2) pclk = ~pclk;

always #(CYCLE*2) sclk = ~sclk;

always @(posedge pclk or negedge preset)
begin
    if(!preset)
        count <= 16'd0;
    else if(((spi_mode == 2'b00) || (spi_mode == 2'b01)) &&
            (!ss) && (!spi_swai))
    begin
        if(count == ((brd/2)-1))
            count <= 16'd0;
        else
            count <= count + 1'b1;
    end
    else
        count <= 16'd0;
end

always @(posedge pclk or negedge preset)
begin
    if(!preset)
        miso_recieve_sclk0_o <= 1'b0;
    else if((~cpha && cpol) || (~cpol && cpha))
    begin
        if(!sclk)
        begin
            if(count == ((brd/2)-1))
                miso_recieve_sclk0_o <= 1'b1;
            else
                miso_recieve_sclk0_o <= 1'b0;
        end
        else
            miso_recieve_sclk0_o <= 1'b0;
    end
    else
        miso_recieve_sclk0_o <= 1'b0;
end

always @(posedge pclk or negedge preset)
begin
    if(!preset)
        miso_recieve_sclk_o <= 1'b0;
    else if((~cpha && ~cpol) || (cpol && cpha))
    begin
        if(sclk)
        begin
            if(count == ((brd/2)-1))
                miso_recieve_sclk_o <= 1'b1;
            else
                miso_recieve_sclk_o <= 1'b0;
        end
        else
            miso_recieve_sclk_o <= 1'b0;
    end
    else
        miso_recieve_sclk_o <= 1'b0;
end

always @(posedge pclk or negedge preset)
begin
    if(!preset)
        mosi_send_sclk_o <= 1'b0;
    else if((cpha && cpol) || (~cpol && ~cpha))
    begin
        if(!sclk)
        begin
            if(count == ((brd/2)-2))
                mosi_send_sclk_o <= 1'b1;
            else
                mosi_send_sclk_o <= 1'b0;
        end
        else
            mosi_send_sclk_o <= 1'b0;
    end
    else
        mosi_send_sclk_o <= 1'b0;
end

always @(posedge pclk or negedge preset)
begin
    if(!preset)
        mosi_send_sclk0_o <= 1'b0;
    else if((cpha && ~cpol) || (cpol && ~cpha))
    begin
        if(sclk)
        begin
            if(count == ((brd/2)-2))
                mosi_send_sclk0_o <= 1'b1;
            else
                mosi_send_sclk0_o <= 1'b0;
        end
        else
            mosi_send_sclk0_o <= 1'b0;
    end
    else
        mosi_send_sclk0_o <= 1'b0;
end

initial
begin
    pclk = 1'b0;
    preset = 1'b1;

    ss = 1'b1;
    send_data = 1'b0;

    lsbfe = 1'b0;
    cpha = 1'b0;
    cpol = 1'b0;

    miso = 1'b0;
    rcv_data = 1'b0;

    data_mosi = 8'h00;

    miso_recieve_sclk_o = 1'b0;
    miso_recieve_sclk0_o = 1'b0;

    mosi_send_sclk_o = 1'b0;
    mosi_send_sclk0_o = 1'b0;

    spi_swai = 1'b0;
    spi_mode = 2'b01;

    sppr_i = 3'd0;
    spr_i = 3'd0;

    sclk = 1'b0;
    brd = 12'd4;

    count = 16'd0;

    #10;
    preset = 1'b0;

    #20;
    preset = 1'b1;

    #10;

    cpol = 1'b0;
    cpha = 1'b1;
    lsbfe = 1'b1;

    spi_mode = 2'b01;
    spi_swai = 1'b0;

    brd = 12'd4;

    data_mosi = 8'h04;

    ss = 1'b0;

    send_data = 1'b1;

    #10;
    send_data = 1'b0;

    miso = 1'b1;

    #800;

    @(posedge pclk);
    rcv_data = 1'b1;

    @(posedge pclk);
    rcv_data = 1'b0;

    #100;

    ss = 1'b1;

    #100;

    $finish;
end

initial
begin
    $monitor(
    "TIME=%0t | pclk=%b | sclk=%b | preset=%b | ss=%b | send_data=%b | lsbfe=%b | cpol=%b | cpha=%b | data_mosi=%h | miso=%b | mosi=%b | rcv_data=%b | data_miso=%h | count=%d",
    $time,
    pclk,
    sclk,
    preset,
    ss,
    send_data,
    lsbfe,
    cpol,
    cpha,
    data_mosi,
    miso,
    mosi_o,
    rcv_data,
    data_miso_o,
    count
    );
end

endmodule
