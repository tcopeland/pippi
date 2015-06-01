class CheckDescriptor

  attr_accessor :check, :clazz_to_decorate, :method1, :method2, :first_method_arity_type, :second_method_arity_type, :should_check_subsequent_calls, :return_type

  def initialize(check_object)
    @check = check_object
    @should_check_subsequent_calls = true
  end

end