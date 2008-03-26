require File.dirname(__FILE__) + '/shared.rb'

class ExpectationNumberTest < Test::Unit::TestCase
  TEST_DESCRIPTION = "Expectations should work"
  
  attr_accessor :expectation
  
  def setup
    self.expectation = Test::Reckon::Expectation.new(1, true, TEST_DESCRIPTION)
  end
  
  def test_should_report_success_for_equality
    Test::Reckon::Reporter.instance.expects(:add_success)
    expectation == 1
  end
  
  def test_should_report_failure_for_equality
    Test::Reckon::Reporter.instance.expects(:add_failure).with(TEST_DESCRIPTION, "1 != 2")
    expectation == 2
  end
  
  def test_should_report_success_for_greaterequal
    Test::Reckon::Reporter.instance.expects(:add_success)
    expectation >= 0.5
  end
  
  def test_should_report_failure_for_greaterequal
    Test::Reckon::Reporter.instance.expects(:add_failure).with(TEST_DESCRIPTION, "1 < 2")
    expectation >= 2
  end
  
  def test_should_report_success_for_lessequal
    Test::Reckon::Reporter.instance.expects(:add_success)
    expectation <= 2
  end
  
  def test_should_report_failure_for_lessequal
    Test::Reckon::Reporter.instance.expects(:add_failure).with(TEST_DESCRIPTION, "1 > 0.5")
    expectation <= 0.5
  end
  
  def test_should_report_success_for_greater
    Test::Reckon::Reporter.instance.expects(:add_success)
    expectation > 0.5
  end
  
  def test_should_report_failure_for_greater
    Test::Reckon::Reporter.instance.expects(:add_failure).with(TEST_DESCRIPTION, "1 <= 2")
    expectation > 2
  end
  
  def test_should_report_success_for_less
    Test::Reckon::Reporter.instance.expects(:add_success)
    expectation < 2
  end
  
  def test_should_report_failure_for_less
    Test::Reckon::Reporter.instance.expects(:add_failure).with(TEST_DESCRIPTION, "1 >= 0.5")
    expectation < 0.5
  end
end


class ExpectationStringTest < Test::Unit::TestCase
  TEST_DESCRIPTION = "Expectations should work"
  TEST_SUBJECT = "I'm a hood billionaire!"
  
  attr_accessor :expectation
  
  def setup
    self.expectation = Test::Reckon::Expectation.new(TEST_SUBJECT, true, TEST_DESCRIPTION)
  end
  
  def test_should_report_success_for_regexp_match
    Test::Reckon::Reporter.instance.expects(:add_success)
    expectation =~ /hood/
  end
  
  def test_should_report_failure_for_regexp_match
    Test::Reckon::Reporter.instance.expects(:add_failure).with(TEST_DESCRIPTION, "#{TEST_SUBJECT.inspect} !~ /food/")
    expectation =~ /food/
  end
end
