module Pippi
  module Checks
    class CheckDescriptor

      attr_accessor :check, :clazz_to_decorate, :method_sequence, :should_check_subsequent_calls

      def initialize(check_object, clazz_to_decorate, method_sequence)
        @clazz_to_decorate = clazz_to_decorate
        @method_sequence = method_sequence
        @check = check_object
        @should_check_subsequent_calls = true
      end

    end
  end
end
