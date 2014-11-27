module Pippi::Checks
  class AssertWithNil < Check
    module MyAssertEqual
      def assert_equal(*args)
        if args.size > 1 && args[0].object_id == 8
          self.class._pippi_check_assert_with_nil.add_problem
        end
        super
      end
    end

    def decorate
      if defined?(ActiveSupport::TestCase)
        ActiveSupport::TestCase.class_exec(self) do |my_check|
          @_pippi_check_assert_with_nil = my_check
          def self._pippi_other_check_assert_with_nil
            @_pippi_check_assert_with_nil
          end
          def self._pippi_check_assert_with_nil
            ancestors.find { |x| x == ActiveSupport::TestCase }._pippi_other_check_assert_with_nil
          end
          prepend Pippi::Checks::AssertWithNil::MyAssertEqual
        end
      end
    end

    class Documentation
      def description
        "Don't use assert_equal with nil as a first argument; use assert_nil instead"
      end

      def sample
        'x = nil ; assert_equal(nil, x)'
      end

      def instead_use
        'x = nil ; assert_nil(x)'
      end
    end
  end
end
