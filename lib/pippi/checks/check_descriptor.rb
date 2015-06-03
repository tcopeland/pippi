class CheckDescriptor

  attr_accessor :check, :clazz_to_decorate, :first_method_descriptor, :second_method_descriptor, :should_check_subsequent_calls

  def initialize(check_object)
    @check = check_object
    @should_check_subsequent_calls = true
  end

end