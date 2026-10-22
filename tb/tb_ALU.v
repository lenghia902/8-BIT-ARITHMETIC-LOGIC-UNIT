`timescale 1ns / 1ps

module tb_ALU;


  parameter WIDTH = 8;
  reg [WIDTH-1:0] in_a;
  reg [WIDTH-1:0] in_b;
  reg input_carry;
  reg [3:0] alu_opcode;
  wire [WIDTH-1:0] alu_out;
  wire [4:0] alu_out_flag;
  wire zero     = alu_out_flag[0];
  wire gt       = alu_out_flag[1]; // A > B
  wire eq       = alu_out_flag[2]; // A == B
  wire lt       = alu_out_flag[3]; // A < B
  wire flag_mux_out=alu_out_flag[4];//carry & overflow


  ALU #(
      .WIDTH(WIDTH)
  ) uut (
      .in_a(in_a),
      .in_b(in_b),
      .input_carry(input_carry),
      .alu_opcode(alu_opcode),
      .alu_out(alu_out),
      .alu_out_flag(alu_out_flag)
  );
   initial begin
        $dumpfile("dump.vcd"); 
        $dumpvars;
    end
  initial begin
    $display(" ==============TEST ARITHMETIC================");
    $display("ADD: 10 + 20 ");//EXPECT OUT =30
    in_a=8'd10;
    in_b=8'd20;
    alu_opcode=4'b0000;
    input_carry=0;
    #10;
    $display("ADD WITH CARRY: 10 + 20 +1");//EXPECT OUT=31
    input_carry=1;
    #10;
    $display("TEST CARRY FLAG: 255+1");//EXPECT OUT=0
    in_a=8'd255;
    in_b=8'd1;
    input_carry=0;
    #10;
    $display("SUB: 100 - 24");//EXPECT OUT =76
    in_a=8'd100;
    in_b=8'd24;
    alu_opcode=4'b0001;
    #10;
    $display("SUB WITH CARRY:100 -24 -1");//EXPECT OUT =75
    input_carry=1;
    #10;
    $display("MUL: 2 * 3");//EXPECT OUT =6
    in_a=8'd2;
    in_b=8'd3;
    alu_opcode=4'b0010;
    #10;
    $display("MUL OVERFLOW FLAG: 6 *3 ");//EXPECT OUT =18
    in_a=8'd6;
    in_b=8'd3;
    #10;
    $display("INCREASE: 10 + 1");//EXPECT OUT=11
    in_a=8'd10;
    in_b=8'd0;
    alu_opcode=4'b0011;
    input_carry=0;
    #10;
    $display("INCREASE WITH CARRY: 10 +1 +1");//EXPECT OUT =11
    input_carry=1;
    #10;
    $display("DECREASE: 10 -1");//EXPECT OUT =9
    alu_opcode=4'b0100;
    input_carry=0;
    #10;
    $display("DECREASE WITH CARRY: 10 - 1 -1");//EXPECT OUT =8
    input_carry=1;
    #10;
    $display("SHIFT LEFT");
    in_a=8'b10001010;
    alu_opcode=4'b0101;
    input_carry=0;
    #10;
    $display("SHIFT LEFT WITH CARRY");
    input_carry=1;
    #10;
    $display("SHIFT RIGHT");
    input_carry=0;
    alu_opcode=4'b0110;
    #10;
    $display("SHIFT RIGHT WITH CARRY");
    in_a=8'b10010001;
    input_carry=1;
    #10;
    $display(" ===============TEST LOGIC==============");
    input_carry=0;
    #10;
    $display("COMPARE: 45 VS 50");//EXPECT:  A < B : LT
    in_a=8'd45;
    in_b=8'd50;
    alu_opcode=4'b1000;
    #10;
    $display("COMPARE:36 VS 18");// EXPECT: A >B : GR
    in_a=8'd36;
    in_b=8'd18;
    #10;
    $display("COMPARE: 100 VS 100");// EXPECT A=B:EQ
    in_a=8'd100;
    in_b=8'd100;
    #10;
    $finish;
  end
    initial begin
      $monitor("time =%t | a =%d(a=%b) | b = %d(b=%b) | input_carry = %b | alu_opcode =%b ,| alu_out =%d(alu_out=%b) | alu_out_flag = %b{flag_mux_out(carry & overflow)=%b|lt=%b|eq=%b|gt=%b|zero=%b} ",$time,in_a,in_a,in_b,in_b,input_carry,alu_opcode,alu_out,alu_out,alu_out_flag,flag_mux_out,lt,eq,gt,zero);
    end
    
endmodule
