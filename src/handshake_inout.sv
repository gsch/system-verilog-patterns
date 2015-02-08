/*==============================================================================

The MIT License (MIT)

Copyright (c) 2015 Luuvish Hwang

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

================================================================================

    File         : handshake_inout.sv
    Author(s)    : luuvish (github.com/luuvish/system-verilog-patterns)
    Modifier     : luuvish (luuvish@gmail.com)
    Descriptions : design patterns for handshake inout module

==============================================================================*/

module handshake_inout (
  input  wire       clock,
  input  wire       reset_n,
  input  wire [7:0] i_value,
  input  wire       i_valid,
  output wire       o_ready,
  output reg  [7:0] o_value,
  output reg        o_valid,
  input  wire       i_ready
);

  reg  [7:0] r_value;
  reg        r_valid;
  wire       s_valid;
  wire       s_ready;
  wire       m_ready;

  assign s_valid =  i_valid & o_ready;
  assign s_ready = ~r_valid | m_ready;

  assign o_ready = s_ready;

  always_ff @(posedge clock, negedge reset_n) begin
    if (~reset_n) begin
      r_value <= '0;
      r_valid <= 1'b0;
    end
    else if (s_ready) begin
      if (s_valid) begin
        r_value <= i_value;
      end
      r_valid <= s_valid;
    end
  end

  assign m_ready = ~o_valid | i_ready;

  always_ff @(posedge clock, negedge reset_n) begin
    if (~reset_n) begin
      o_value <= '0;
      o_valid <= 1'b0;
    end
    else if (m_ready) begin
      if (r_valid) begin
        o_value <= r_value;
      end
      o_valid <= r_valid;
    end
  end

endmodule
