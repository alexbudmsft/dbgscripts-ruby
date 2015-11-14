# Class that wraps a Ruby VALUE.
#
class RubyVal
  # Constants
  #
  MASK_32BIT = 2**32 - 1
  MASK_64BIT = 2**64 - 1
  Qfalse = 0
  Qtrue = 20
  Qnil = 8
  Qundef = 52
  IMMEDIATE_MASK = 7
  FIXNUM_FLAG = 1
  FLONUM_MASK = 3
  FLONUM_FLAG = 2
  SYMBOL_FLAG = 12
  SPECIAL_SHIFT = 8
  T_MASK = 0x1F
  FL_USHIFT = 12

  # Based on FL_USERx in ruby.h
  #
  def self.fl_user_mask(n)
    1 << (FL_USHIFT + n)
  end

  def initialize(val)
    @val = val
  end

  def immediate?
    @val & IMMEDIATE_MASK != 0
  end

  def fixnum?
    # Is the low bit set?
    #
    @val & 1 != 0
  end

  def flonum?
    @val & FLONUM_MASK == FLONUM_FLAG
  end

  def static_sym?
    symbol_mask = ~(MASK_64BIT << SPECIAL_SHIFT) & MASK_64BIT
    @val & symbol_mask == SYMBOL_FLAG
  end

  def test_true?
    @val & ~Qnil != 0
  end

  def builtin_type
    rbasic = DbgScript.create_typed_object('RBasic', @val)
    type = rbasic.flags.value & T_MASK
    return DbgScript.resolve_enum('ruby_value_type', type), rbasic
  end

  # See 'rb_type' core function.
  #
  def type
    if immediate?
      return Fixnum if fixnum?
      return Float if flonum?
      return TrueClass if @val == Qtrue
      return Symbol if static_sym?
      return "undef" if @val == Qundef
    elsif !test_true?
      return NilClass if @val == Qnil
      return FalseClass if @val == Qfalse
    end
    builtin_type
  end

  def value
    t, rbasic = type
    # Can't use 'case' statement because that uses '===' which doesn't help for
    # comparing classes.
    #
    if t == Fixnum
      @val >> 1
    elsif t == 'RUBY_T_ARRAY'
      RArray.new(rbasic)
    else
      "not implemented"
    end
  end
end

class RArray
  def initialize(rbasic)
    @rbasic = rbasic
  end

  def size
    embed_flag = RubyVal.fl_user_mask(1)
    embed_len_mask = RubyVal.fl_user_mask(4) | RubyVal.fl_user_mask(3)
    embed_len_shift = RubyVal::FL_USHIFT + 3
    flags = @rbasic.flags.value
    if flags & embed_flag != 0
      (flags & embed_len_mask) >> embed_len_shift
    else
      arr = DbgScript.create_typed_object('RArray', @rbasic.address)
      arr.as.heap.len.value
    end
  end
end
