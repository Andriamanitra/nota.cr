require "./spec_helper"

macro it_encodes(num, expected)
  Nota.encode({{num}}).to_slice.should eq({{expected}})
end

describe Nota do
  it "encodes integers" do
    # examples from http://crockford.com/nota.html
    it_encodes 0, Bytes[0x60]
    it_encodes 2023, Bytes[0xE0, 0x8F, 0x67]
    it_encodes -1, Bytes[0x69]
    # edge cases
    it_encodes       7, Bytes[0b0110_0_111]
    it_encodes       8, Bytes[0b1110_0_000, 0b0_0001000]
    it_encodes     127, Bytes[0b1110_0_000, 0b0_1111111]
    it_encodes     128, Bytes[0b1110_0_001, 0b0_0000000]
    it_encodes    1023, Bytes[0b1110_0_111, 0b0_1111111]
    it_encodes   -1023, Bytes[0b1110_1_111, 0b0_1111111]
    it_encodes    1024, Bytes[0b1110_0_000, 0b1_0001000, 0b0_0000000]
    it_encodes   -1024, Bytes[0b1110_1_000, 0b1_0001000, 0b0_0000000]
    it_encodes  131071, Bytes[0b1110_0_111, 0b1_1111111, 0b0_1111111]
    it_encodes -131071, Bytes[0b1110_1_111, 0b1_1111111, 0b0_1111111]
  end

  it "works with different integer types" do
    it_encodes 0_u8, Bytes[0x60]
    it_encodes 0_i8, Bytes[0x60]
    it_encodes 0_u16, Bytes[0x60]
    it_encodes 0_i16, Bytes[0x60]
    it_encodes 0_u32, Bytes[0x60]
    it_encodes 0_i32, Bytes[0x60]
    it_encodes 0_u64, Bytes[0x60]
    it_encodes 0_i64, Bytes[0x60]
    it_encodes 0_u128, Bytes[0x60]
    it_encodes 0_i128, Bytes[0x60]

    it_encodes 127_u8, Bytes[0xE0, 0x7F]
    it_encodes 127_i8, Bytes[0xE0, 0x7F]
    it_encodes 127_u16, Bytes[0xE0, 0x7F]
    it_encodes 127_i16, Bytes[0xE0, 0x7F]
    it_encodes 127_u32, Bytes[0xE0, 0x7F]
    it_encodes 127_i32, Bytes[0xE0, 0x7F]
    it_encodes 127_u64, Bytes[0xE0, 0x7F]
    it_encodes 127_i64, Bytes[0xE0, 0x7F]
    it_encodes 127_u128, Bytes[0xE0, 0x7F]
    it_encodes 127_i128, Bytes[0xE0, 0x7F]
  end

  it "does not throw on Int::MIN or Int::MAX" do
    it_encodes Int32::MIN, Bytes[0xE8, 0x88, 0x80, 0x80, 0x80, 0x00]
    it_encodes Int32::MAX, Bytes[0xE7, 0xFF, 0xFF, 0xFF, 0x7F]
    Nota.encode(Int64::MIN).size.should eq(10)
    Nota.encode(Int64::MAX).size.should eq(10)
    Nota.encode(Int128::MIN).size.should eq(19)
    Nota.encode(Int128::MAX).size.should eq(19)
  end
end