module Baudrate_Generator(pclk,preset_n,spi_mode,spiswai,sppr,spr,cpol,cpha,ss,sclk,miso_receive_posedge,miso_receive_negedge,mosi_send_posedge,mosi_send_negedge,baud_rate_divisor);

	input pclk,preset_n,spiswai,cpol,cpha,ss;
	input [1:0] spi_mode;
	input [2:0] sppr,spr;
	output reg sclk,miso_receive_posedge,miso_receive_negedge,mosi_send_posedge,mosi_send_negedge;
	output [11:0] baud_rate_divisor;

	wire pre_clk;
	reg [11:0] count;

	assign baud_rate_divisor=(sppr+1)*(2**(spr+1)); // Baud Rate Divisor
	assign pre_clk=(cpol)?1:0;     

	//Pre clk

	always @(posedge pclk)   // Generate Serial Clk for SPI
	begin
		if(!preset_n)
		begin
			sclk<=pre_clk;
		end
		else if(!ss && (spi_mode==2'b00||spi_mode==2'b01) && !spiswai)
		begin
			if(count==(baud_rate_divisor/2)-1'b1)
				sclk<=~sclk;
			else
				sclk<=sclk;
		end
		else 
			sclk<=pre_clk;
	end

	always @(posedge pclk)   //For MISO 
	begin
		if(!preset_n)
		begin
			miso_receive_posedge<=0;
			miso_receive_negedge<=0;
		end
		else if(((cpol==0 && cpha==0)||(cpol==1 && cpha==1)))
		begin
			if(!sclk)begin
				if(count==(baud_rate_divisor/2)-1)
					miso_receive_posedge<=1;
				else

					miso_receive_posedge<=0;
				end
			else
				miso_receive_posedge<=0;
		end

		else //if((cpol==0 && cpha==1)||(cpol==1 && cpha==0))
		begin
			if(sclk)
			begin
				if(count==(baud_rate_divisor/2)-1)

					miso_receive_negedge<=1;
				else				
					miso_receive_negedge<=0;
			end
			else
				miso_receive_negedge<=0;
		end
	end
		
	always @(posedge pclk )   //For MOSI
		begin
			if(!preset_n)
			begin
				mosi_send_posedge<=0;
				mosi_send_negedge<=0;
			end
			else if(((cpol==0 && cpha==0)||(cpol==1 && cpha==1)))
			begin
				if(!sclk)
					if(count==(baud_rate_divisor/2)-2)
						mosi_send_posedge<=1;
				else	
						mosi_send_posedge<=0;
		  end

		else //if((cpol==0 && cpha==1)||(cpol==1 && cpha==0))
		begin
			if(sclk)
			begin
				if(count==(baud_rate_divisor/2)-2)
					mosi_send_negedge<=1;
				else
					mosi_send_negedge<=0;
			end
		else
			mosi_send_negedge<=0;
		end
		end
		
		always@(posedge pclk )
		begin
			if(!preset_n)
				count<=12'b0;
			else if(!ss && (spi_mode==2'b00||spi_mode==2'b01) && !spiswai)
			begin
				if(count==(baud_rate_divisor/2)-12'b1)
					count<=12'b0;
				else 
					count<=count+12'b1;
			end
			else 
				count<=12'b0;
			end

		

		
	endmodule


