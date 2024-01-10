require "../nota"

# Nota::Integer represents an arbitrary size nota-encoded integer.
#
# The representation is intended for data transfer and thus is not suitable
# for arithmetic operations. To use the value it should be converted to an
# integer type of suitable size (u8..u128, i8..i128, or BigInt).
struct Nota::Integer
  @bytes : Bytes

  def initialize(num : Int)
    @bytes = Nota.encode(num).to_slice
  end

  def to_u8 : UInt8
    raise OverflowError.new if negative? || bit_length > 8

    if @bytes.size == 1
      @bytes[0].bits(0..2)
    else
      @bytes[-1].bits(0..6) | (@bytes[-2].bit(0) << 7)
    end
  end

  def to_u16 : UInt16
    raise OverflowError.new if negative? || bit_length > 16

    if @bytes.size == 1
      @bytes[0].bits(0..2).to_u16
    elsif @bytes.size == 2
      (@bytes[0].bits(0..2).to_u16 << 7) | @bytes[1].bits(0..6)
    else
      (@bytes[0].bits(0..2).to_u16 << 14) | (@bytes[1].bits(0..6).to_u16 << 7) | @bytes[2].bits(0..6)
    end
  end

  def to_u32 : UInt32
    raise OverflowError.new if negative? || bit_length > 32

    if @bytes.size < 6
      v = @bytes[0].bits(0..2).to_u32
      @bytes[1..].each do |b|
        v <<= 7
        v |= b.bits(0..6)
      end
      v
    else
      v = 0_u32
      @bytes[-5..].each do |b|
        v <<= 7
        v |= b.bits(0..6)
      end
      v
    end
  end

  def to_u : UInt32
    to_u32
  end

  def to_u64 : UInt64
    raise NotImplementedError
  end

  def to_u128 : UInt128
    raise NotImplementedError
  end

  def to_i8 : Int8
    raise NotImplementedError
  end

  def to_i16 : Int16
    raise NotImplementedError
  end

  def to_i32 : Int32
    raise NotImplementedError
  end

  def to_i : Int32
    to_i32
  end

  def to_i64 : Int64
    raise NotImplementedError
  end

  def to_i128 : Int128
    raise NotImplementedError
  end

  def to_big_i : BigInt
    raise NotImplementedError
  end

  def bit_length : Int32
    blen = @bytes[0].bits(0..2).bit_length
    @bytes[1..].each do |b|
      if blen == 0
        blen = b.bits(0..6).bit_length
      else
        blen += 7
      end
    end
    blen
  end

  def negative? : Bool
    @bytes[0].bit(3) == 1
  end
end
