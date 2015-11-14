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
    obj = DbgScript.create_typed_object('RBasic', @val)
    type = obj.flags.value & T_MASK
    DbgScript.resolve_enum('ruby_value_type', type)
  end

  # See 'rb_type' core function.
  #
  def type
    if immediate?
      return "Fixnum" if fixnum?
      return "Float" if flonum?
      return "true" if @val == Qtrue
      return "Symbol" if static_sym?
      return "undef" if @val == Qundef
    elsif !test_true?
      return "nil" if @val == Qnil
      return "false" if @val == Qfalse
    end
    builtin_type
  end
end
