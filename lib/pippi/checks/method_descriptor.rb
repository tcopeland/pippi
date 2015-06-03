class MethodDescriptor

  ARITY_TYPE_BLOCK_ARG = 1
  ARITY_TYPE_NONE = 2

  attr_accessor :name, :arity

  def initialize(name, arity)
    @name = name
    @arity = arity
  end

  def accepts_block?
    arity == ARITY_TYPE_BLOCK_ARG
  end

  def no_args?
    arity == ARITY_TYPE_NONE
  end

  def module?
    arity.kind_of?(Module)
  end

end
