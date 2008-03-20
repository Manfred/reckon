PROJECT_ROOT = File.expand_path('../', File.dirname(__FILE__))
$:.unshift(File.join(PROJECT_ROOT, 'lib'))

require 'test/unit'
require 'test/reckon'

require 'rubygems' rescue nil
require 'mocha'

class Test::Unit::TestCase
  def assert_difference(expression, difference = 1, message = nil, &block)
    wrapped_expression = lambda { eval(expression) }
    original_value = wrapped_expression.call
    yield
    assert_equal original_value + difference, wrapped_expression.call, message
  end
end

class OutputMock
  require 'singleton'
  include Singleton
  
  attr_accessor :messages
  
  def initialize
    @messages = []
  end
  
  def puts(message)
    self.messages << message
  end
  alias :write :puts
end

$stderr = OutputMock.instance

class ReporterTest < Test::Unit::TestCase
  def test_should_be_singleton
    assert_same Test::Reckon::Reporter.instance, Test::Reckon::Reporter.instance
  end
end

class ReporterInstanceTest < Test::Unit::TestCase
  attr_accessor :reporter, :output
  
  def setup
    self.reporter = Test::Reckon::Reporter.instance
    self.output = OutputMock.instance
  end
  
  def test_should_add_success
    assert_difference("reporter.instance_eval { @successes }", +1) do
      reporter.add_success
    end
  end
  
  def test_should_add_failure
    assert_difference("reporter.instance_eval { @failures }", +1) do
      assert_difference("output.messages.length", +4) do
        reporter.add_failure("Testing failure", "should work")
      end
    end
    assert_match /rb:\d+$/, output.messages[-4]
    assert_equal "  * Testing failure", output.messages[-3]
    assert_match /^\s+tested:\s/, output.messages[-2]
    assert_match "  but: should work", output.messages[-1]
  end
  
  def test_should_add_exceptions
    begin
      raise ArgumentError, "For testing purposes"
    rescue ArgumentError => e
      assert_difference("reporter.instance_eval { @exceptions }", +1) do
        assert_difference("output.messages.length", +4) do
          reporter.add_exception("Testing exceptions", e)
        end
      end
    end
    assert_match /rb:\d+$/, output.messages[-4]
    assert_equal "  * Testing exceptions", output.messages[-3]
    assert_match /^\s+evaluated:\s/, output.messages[-2]
    assert_match /^\s+exception:\s#</, output.messages[-1]
  end
  
  def test_print_stats
    assert_difference("output.messages.length", +1) do
      reporter.print_stats
    end
    assert_equal "0 passed, 0 failed, 0 broken", output.messages.last
  end
end