require "./spec_helper"

describe Nota::Integer do
  context "#bit_length" do
    it "counts how many bits are needed to represent the number" do
      Nota::Integer.new(0).bit_length.should eq(0)
      Nota::Integer.new(7).bit_length.should eq(3)
      Nota::Integer.new(8).bit_length.should eq(4)
      Nota::Integer.new(16).bit_length.should eq(5)
      Nota::Integer.new(255).bit_length.should eq(8)
      Nota::Integer.new(256).bit_length.should eq(9)
      Nota::Integer.new(UInt32::MAX).bit_length.should eq(32)
      Nota::Integer.new(UInt64::MAX).bit_length.should eq(64)
      Nota::Integer.new(UInt128::MAX >> 1).bit_length.should eq(127)
      Nota::Integer.new(UInt128::MAX).bit_length.should eq(128)
    end
  end

  context "#to_u8" do
    it "converts to UInt8" do
      Nota::Integer.new(0).to_u8.should eq(0_u8)
      Nota::Integer.new(123).to_u8.should eq(123_u8)
      Nota::Integer.new(UInt8::MAX).to_u8.should eq(UInt8::MAX)
    end

    it "raises exception if result doesn't fit" do
      expect_raises(OverflowError) { Nota::Integer.new(-1).to_u8 }
      expect_raises(OverflowError) { Nota::Integer.new(256).to_u8 }
    end
  end


  context "#to_u16" do
    it "converts to UInt16" do
      Nota::Integer.new(0).to_u16.should eq(0_u16)
      Nota::Integer.new(256).to_u16.should eq(256_u16)
      Nota::Integer.new(1024).to_u16.should eq(1024_u16)
      Nota::Integer.new(1025).to_u16.should eq(1025_u16)
      Nota::Integer.new(UInt16::MAX).to_u16.should eq(UInt16::MAX)
    end

    it "raises exception if result doesn't fit" do
      expect_raises(OverflowError) { Nota::Integer.new(-1).to_u16 }
      expect_raises(OverflowError) { Nota::Integer.new(65536).to_u16 }
    end
  end

  context "#to_u32" do
    it "converts to UInt32" do
      Nota::Integer.new(0).to_u32.should eq(0_u32)
      Nota::Integer.new(7).to_u32.should eq(7_u32)
      Nota::Integer.new(9).to_u32.should eq(9_u32)
      Nota::Integer.new(1024).to_u32.should eq(1024_u32)
      Nota::Integer.new(1025).to_u32.should eq(1025_u32)
      Nota::Integer.new(65536).to_u32.should eq(65536_u32)
      Nota::Integer.new(UInt32::MAX).to_u32.should eq(UInt32::MAX)
    end

    it "raises exception if result doesn't fit" do
      expect_raises(OverflowError) { Nota::Integer.new(-1).to_u32 }
      expect_raises(OverflowError) { Nota::Integer.new(UInt32::MAX.to_u64 + 1).to_u32 }
    end
  end
end
