module Pippi::Checks
  class MethodSequence

    attr_accessor :method1, :method2, :decorator

    def initialize(method1, method2, decorator=nil)
      @method1 = method1
      @method2 = method2
      @decorator = decorator
    end

  end
end
