module Test #:nodoc
  module Reckon #:nodoc
    class Expectation
      def initialize(expected_value, test_description)
        @expected_value = expected_value
        @test_description = test_description
      end
      
      def ==(other)
        reporter = Test::Reckon::Reporter.instance
        if @expected_value == other
          reporter.add_success
        else
          reporter.add_failure(@test_description, "#{@expected_value.inspect} != #{other.inspect}")
        end
      end
    end
  end
end