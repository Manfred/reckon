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

class ExpectationBlockTest < Test::Unit::TestCase
  TEST_DESCRIPTION = "Expectations should work"
  
  def test_should_report_succes_if_expected_exception_is_raised
    expectation = Test::Reckon::Expectation.new(nil, true, TEST_DESCRIPTION) { raise ArgumentError }
    Test::Reckon::Reporter.instance.expects(:add_success)
    expectation.raises(ArgumentError)
  end
  
  def test_should_report_failure_if_exception_other_than_expected_is_raised
    expectation = Test::Reckon::Expectation.new(nil, true, TEST_DESCRIPTION) { raise ArgumentError }
    Test::Reckon::Reporter.instance.expects(:add_failure).with(TEST_DESCRIPTION, "Expected TypeError but got an ArgumentError")
    expectation.raises(TypeError)
  end
  
  def test_should_report_failure_if_no_exception_is_raised_but_was_expected
    expectation = Test::Reckon::Expectation.new(nil, true, TEST_DESCRIPTION) { }
    Test::Reckon::Reporter.instance.expects(:add_failure).with(TEST_DESCRIPTION, "Expected TypeError but no exception was raised")
    expectation.raises(TypeError)
  end
  
  def test_should_report_success_if_other_exception_than_rejected_exception_was_raised
    expectation = Test::Reckon::Expectation.new(nil, false, TEST_DESCRIPTION) { raise TypeError }
    Test::Reckon::Reporter.instance.expects(:add_success)
    expectation.raises(ArgumentError)
  end
  
  def test_should_report_success_if_no_exception_was_raised_but_one_was_rejected
    expectation = Test::Reckon::Expectation.new(nil, false, TEST_DESCRIPTION) {  }
    Test::Reckon::Reporter.instance.expects(:add_success)
    expectation.raises(ArgumentError)
  end
  
  def test_should_report_failure_if_rejected_exception_is_raised
    expectation = Test::Reckon::Expectation.new(nil, false, TEST_DESCRIPTION) { raise ArgumentError }
    Test::Reckon::Reporter.instance.expects(:add_failure).with(TEST_DESCRIPTION, "Rejected exception ArgumentError was raised")
    expectation.raises(ArgumentError)
  end
end