module top(
	input CLK,
	input SCK,
	input CS,
	input MOSI,
	output TMP,
	output STORE);

reg [2:0] SCKr;  
reg [2:0] CSr;  
reg [1:0] MOSIr;  

wire SCK_risingedge = (SCKr[2:1]==2'b01);  // now we can detect SCK rising edges
wire CS_endmessage = (CSr[2:1]==2'b01);  // message stops at rising edge
wire MOSI_data = MOSIr[1];

assign STORE = CS_endmessage;

always @(posedge CLK) 
	SCKr <= {SCKr[1:0], SCK};

always @(posedge CLK) 
	CSr <= {CSr[1:0], CS};

always @(posedge CLK) 
	MOSIr <= {MOSIr[0], MOSI};

assign TMP = ^lcd_data[23:0];
	
reg [23:0] lcd_data;
reg [23:0] tmp_data;

always @(posedge CLK)
begin
  if(SCK_risingedge)
  begin
    tmp_data <= {tmp_data[22:0], MOSI_data};
  end
end

always @(posedge CLK)
begin
  if(CS_endmessage)
  begin
    lcd_data <= tmp_data;
  end
end


endmodule
