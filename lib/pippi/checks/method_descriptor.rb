class MethodDescriptor

  attr_accessor :name, :decorator

  def initialize(name, decorator=nil)
    @name = name
    @decorator = decorator
  end

end
