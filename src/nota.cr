module Nota
  VERSION = "0.1.0"

  alias UInt = UInt8 | UInt16 | UInt32 | UInt64 | UInt128

  PREAMBLE_INT = 0b0110_0000_u8

  def self.encode(v) : IO
    io = IO::Memory.new
    self.encode(io, v)
  end

  def self.encode(io : IO, value : Int8 | Int16 | Int32) : IO
    preamble = value >= 0 ? PREAMBLE_INT : PREAMBLE_INT | 0b1000

    if value < 0
      uvalue = (~value).to_u32! + 1
    else
      uvalue = value.to_u32!
    end

    if uvalue <= 7_u32
      io.write_byte preamble | uvalue.to_u8
    else
      shift = (uvalue.bit_length + 3) // 7 * 7
      io.write_byte 0b1000_0000_u8 | preamble | (uvalue >> shift).to_u8
      self.encode_int_continuation(io, uvalue, shift - 7)
    end

    return io
  end

  def self.encode(io : IO, value : Int64) : IO
    preamble = value >= 0 ? PREAMBLE_INT : PREAMBLE_INT | 0b1000

    if value < 0
      uvalue = (~value).to_u64! + 1
    else
      uvalue = value.to_u64!
    end

    if uvalue <= 7_u64
      io.write_byte preamble | uvalue.to_u8
    else
      shift = (uvalue.bit_length + 3) // 7 * 7
      io.write_byte 0b1000_0000_u8 | preamble | (uvalue >> shift).to_u8
      self.encode_int_continuation(io, uvalue, shift - 7)
    end

    return io
  end

  def self.encode(io : IO, value : Int128) : IO
    preamble = value >= 0 ? PREAMBLE_INT : PREAMBLE_INT | 0b1000

    if value < 0
      uvalue = (~value).to_u128! + 1
    else
      uvalue = value.to_u128!
    end

    if uvalue <= 7_u128
      io.write_byte preamble | uvalue.to_u8
    else
      shift = (uvalue.bit_length + 3) // 7 * 7
      io.write_byte 0b1000_0000_u8 | preamble | (uvalue >> shift).to_u8
      self.encode_int_continuation(io, uvalue, shift - 7)
    end

    return io
  end

  def self.encode(io : IO, value : UInt) : IO
    preamble = PREAMBLE_INT

    if value <= 7_u32
      io.write_byte preamble | value.to_u8
    else
      shift = (value.bit_length + 3) // 7 * 7
      io.write_byte 0b1000_0000_u8 | preamble | (value >> shift).to_u8
      self.encode_int_continuation(io, value, shift - 7)
    end

    return io
  end

  private def self.encode_int_continuation(io : IO, value : UInt, shift = 0) : IO
    while shift > 0
      io.write_byte 0b1000_0000_u8 | (value >> shift).to_u8!
      shift -= 7
    end

    io.write_byte value.to_u8! & 0b0111_1111
    return io
  end
end
