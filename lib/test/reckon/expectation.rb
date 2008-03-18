module Test #:nodoc
  module Reckon #:nodoc
    class Expectation
      TYPE_MAP = {
        '==' => {
          true => '==',
          false => '!='
        }
      }
      
      def initialize(expected_value, test_result, test_description)
        @expected_value = expected_value
        @test_result = test_result
        @test_description = test_description
      end
      
      def ==(other)
        reporter = Test::Reckon::Reporter.instance
        if (@expected_value == other) == @test_result
          reporter.add_success
        else
          reporter.add_failure(@test_description, "#{@expected_value.inspect} #{TYPE_MAP['=='][!@test_result]} #{other.inspect}")
        end
      end
    end
  end
end