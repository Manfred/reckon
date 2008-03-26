require File.dirname(__FILE__) + '/shared.rb'

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
  
  def test_print_stats_without_errors
    reporter.instance_eval { @successes = @failures = @exceptions = 0 }
    assert_difference("output.messages.length", +1) do
      reporter.print_stats
    end
    assert_equal "0 passed, 0 failed, 0 broken", output.messages.last
  end
  
  def test_print_stats_with_errors
    reporter.instance_eval do
      @successes = 1
      @failures = 2
      @exceptions = 3
    end
    assert_difference("output.messages.length", +2) do
      reporter.print_stats
    end
    assert_equal "1 passed, 2 failed, 3 broken", output.messages.last
  end
end