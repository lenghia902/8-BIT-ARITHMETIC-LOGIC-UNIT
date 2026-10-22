module arith_unit#(parameter WIDTH=8)(
  input [WIDTH-1:0] in_a,
  input [WIDTH-1:0] in_b,
  input input_carry,
  input [2:0] alu_opcode,
  output reg [WIDTH-1:0] arith_out,
  output reg flag_mux_out
);
  localparam [2:0] 	ADD =3'b000,
  				   	SUB =3'b001,
  					MUL =3'b010,
  					INC =3'b011,
  					DEC =3'b100,
  					SHIL =3'b101,
  					SHIR =3'b110;
  wire [WIDTH-1:0] add_out,sub_out,mul_out,inc_out,dec_out,shift_out;
  wire add_cf;
  wire sub_cf;
  wire mul_of;
  wire inc_cf;
  wire dec_cf;
  wire shift_cf;
  fadder_8bit ADD_unit(
    .a(in_a),
    .b(in_b),
    .cin(input_carry),
    .s(add_out),
    .cout(add_cf)
  );
  fsubtrator_8bit SUB_unit(
    .a(in_a),
    .b(in_b),
    .bin(input_carry),
    .d(sub_out),
    .bout(sub_cf)
  );
  multiply MUL_unit(
    .in_a(in_a[3:0]),
    .in_b(in_b[3:0]),
    .mul_out(mul_out),
    .overflow(mul_of)
  );
  fadder_8bit inc_unit(
    .a(in_a),
    .b(8'd1),
    .cin(input_carry),
    .s(inc_out),
    .cout(inc_cf)
    );
    fsubtrator_8bit dec_unit(
      .a(in_a),
      .b(8'd1),
      .bin(input_carry),
      .d(dec_out),
      .bout(dec_cf)
    );
  shifter_8bit SHIFT_unit(
    .in_a(in_a),
    .input_carry(input_carry),
    .opcode(alu_opcode),
    .shift_out(shift_out),
    .shift_cf(shift_cf)
  );
  always@(*)begin
    arith_out=0;
    flag_mux_out=0;
    case(alu_opcode[2:0])
      ADD:begin
        arith_out=add_out;
        flag_mux_out=add_cf;
      end
      SUB:begin
        arith_out=sub_out;
        flag_mux_out=sub_cf;
      end
      MUL:begin
        arith_out=mul_out;
        flag_mux_out=mul_of;
      end
      INC:begin
        arith_out=inc_out;
        flag_mux_out=add_cf; 
      end
      DEC:begin
        arith_out=dec_out;
        flag_mux_out=sub_cf;
      end
      SHIL,SHIR:begin
        arith_out=shift_out;
        flag_mux_out=shift_cf;
      end
    endcase
  end
endmodule

module fadder_1bit(
  input a,
  input b,
  input cin,
  output s,
  output cout
);
  assign s=a^b^cin;
  assign cout=(a&b)|(cin & (a^b));
endmodule

module fadder_8bit#(parameter WIDTH=8)(
  input [WIDTH-1:0] a,
  input [WIDTH-1:0] b,
  input cin,
  output [WIDTH-1:0] s,
  output cout,
);
  wire cin1,cin2,cin3,cin4,cin5,cin6,cin7;
  
  fadder_1bit F0(.a(a[0]),.b(b[0]),.cin(cin),.s(s[0]),.cout(cin1));
  fadder_1bit F1(.a(a[1]),.b(b[1]),.cin(cin1),.s(s[1]),.cout(cin2));
  fadder_1bit F2(.a(a[2]),.b(b[2]),.cin(cin2),.s(s[2]),.cout(cin3));
  fadder_1bit F3(.a(a[3]),.b(b[3]),.cin(cin3),.s(s[3]),.cout(cin4));
  fadder_1bit F4(.a(a[4]),.b(b[4]),.cin(cin4),.s(s[4]),.cout(cin5));
  fadder_1bit F5(.a(a[5]),.b(b[5]),.cin(cin5),.s(s[5]),.cout(cin6));
  fadder_1bit F6(.a(a[6]),.b(b[6]),.cin(cin6),.s(s[6]),.cout(cin7));
  fadder_1bit F7(.a(a[7]),.b(b[7]),.cin(cin7),.s(s[7]),.cout(cout));
endmodule

module fsubtrator_1bit(
  input a,
  input b,
  input bin,
  output d,
  output bout
);
  assign d=a^b^bin;
  assign bout=~a &b | (bin&(~(a^b)));
endmodule

module fsubtrator_8bit#(parameter WIDTH=8)(
  input [WIDTH-1:0] a,
  input [WIDTH-1:0] b,
  input bin,
  output[WIDTH-1:0] d,
  output bout,
);
  wire bin1,bin2,bin3,bin4,bin5,bin6,bin7;
  fsubtrator_1bit D0(.a(a[0]),.b(b[0]),.bin(bin),.d(d[0]),.bout(bin1));
  fsubtrator_1bit D1(.a(a[1]),.b(b[1]),.bin(bin1),.d(d[1]),.bout(bin2));
  fsubtrator_1bit D2(.a(a[2]),.b(b[2]),.bin(bin2),.d(d[2]),.bout(bin3));
  fsubtrator_1bit D3(.a(a[3]),.b(b[3]),.bin(bin3),.d(d[3]),.bout(bin4));
  fsubtrator_1bit D4(.a(a[4]),.b(b[4]),.bin(bin4),.d(d[4]),.bout(bin5));
  fsubtrator_1bit D5(.a(a[5]),.b(b[5]),.bin(bin5),.d(d[5]),.bout(bin6));
  fsubtrator_1bit D6(.a(a[6]),.b(b[6]),.bin(bin6),.d(d[6]),.bout(bin7));
  fsubtrator_1bit D7(.a(a[7]),.b(b[7]),.bin(bin7),.d(d[7]),.bout(bout));
endmodule

module multiply(
  input [3:0] in_a,
  input [3:0] in_b,
  output [7:0] mul_out,
  output overflow
);
  wire [3:0] s_r1,c_r1;// hang 1
  wire [3:0] s_r2,c_r2;// hang 2 
  wire [3:0] s_r3,c_r3;// hang 3
  assign mul_out[0] = in_a[0] & in_b[0];
  //HANG 1 
  half_adder_1bit H0_r1(.a(in_a[1]&in_b[0]),.b(in_a[0]&in_b[1]),.s(mul_out[1]),.cout(c_r1[0]));
  fadder_1bit     H1_r1(.a(in_a[2]&in_b[0]),.b(in_a[1]&in_b[1]),.cin(c_r1[0]),.s(s_r1[1]),.cout(c_r1[1]));
  fadder_1bit     H2_r1(.a(in_a[3]&in_b[0]),.b(in_a[2]&in_b[1]),.cin(c_r1[1]),.s(s_r1[2]),.cout(c_r1[2]));
  half_adder_1bit H3_r1(.a(in_a[3]&in_b[1]),.b(c_r1[2]),.s(s_r1[3]),.cout(c_r1[3]));
  //HANG 2
  half_adder_1bit H4_r2(.a(in_a[0]&in_b[2]),.b(s_r1[1]),.s(mul_out[2]),.cout(c_r2[0]));
  fadder_1bit     H5_r2(.a(in_a[1]&in_b[2]),.b(s_r1[2]),.cin(c_r2[0]),.s(s_r2[1]),.cout(c_r2[1]));
  fadder_1bit     H6_r2(.a(in_a[2]&in_b[2]),.b(s_r1[3]),.cin(c_r2[1]),.s(s_r2[2]),.cout(c_r2[2]));
  fadder_1bit     H7_r2(.a(in_a[3]&in_b[2]),.b(c_r1[3]),.cin(c_r2[2]),.s(s_r2[3]),.cout(c_r2[3]));
  //HANG 3
  half_adder_1bit H8_r3(.a(in_a[0]&in_b[3]),.b(s_r2[1]),.s(mul_out[3]),.cout(c_r3[0]));
  fadder_1bit     H9_r3(.a(in_a[1]&in_b[3]),.b(s_r2[2]),.cin(c_r3[0]),.s(mul_out[4]),.cout(c_r3[1]));
  fadder_1bit     H10_r3(.a(in_a[2]&in_b[3]),.b(s_r2[3]),.cin(c_r3[1]),.s(mul_out[5]),.cout(c_r3[2]));
  fadder_1bit     H11_r3(.a(in_a[3]&in_b[3]),.b(c_r2[3]),.cin(c_r3[2]),.s(mul_out[6]),.cout(mul_out[7]));
  assign overflow=mul_out[7] | mul_out[6] | mul_out[5] | mul_out[4];
endmodule
      
module half_adder_1bit(
  input a,
  input b,
  output s,
  output cout
);
  assign s=a^b;
  assign cout=a&b;
endmodule

module shifter_8bit#(parameter WIDTH=8)(
  input [WIDTH-1:0] in_a,
  input input_carry,
  input [2:0] opcode,
  output reg [WIDTH-1:0] shift_out,
  output reg shift_cf
);
  localparam [2:0] 	SHIL =3'b101,
  				   	SHIR =3'b110;
  always@(*)begin
    shift_out=0;
    shift_cf=0;
    case(opcode)
      SHIL:begin
        shift_out={in_a[WIDTH-2:0],input_carry};
        shift_cf=in_a[WIDTH-1];
      end
      SHIR:begin
        shift_out={input_carry,in_a[WIDTH-1:1]};
        shift_cf=in_a[0];
      end
      default:begin
        shift_out=0;
      end
    endcase
  end
endmodule
