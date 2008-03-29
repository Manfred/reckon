require File.dirname(__FILE__) + '/shared.rb'

class ExpectationMethodTest < Test::Unit::TestCase
  def setup
    @_test_description = "expects should work"
  end
  
  def test_expects_with_subject_should_create_new_expectation
    expectation = expects(2)
    assert expectation.kind_of?(Test::Reckon::Expectation)
  end
  
  def test_expects_with_block_should_create_new_expectation
    expectation = expects() { }
    assert expectation.kind_of?(Test::Reckon::Expectation)
  end
  
  def test_rejects_with_subject_should_create_new_expectation
    expectation = rejects(2)
    assert expectation.kind_of?(Test::Reckon::Expectation)
  end
  
  def test_rejects_with_block_should_create_new_expectation
    expectation = rejects() { }
    assert expectation.kind_of?(Test::Reckon::Expectation)
  end
end

class TestingTest < Test::Unit::TestCase
  def test_should_leave_instance_variables_intact
    @person = person = "Anne"
    @now = now = Time.now
    
    testing("Some behaviour") { @person = "!Anne" }
    
    assert_equal person, @person
    assert_equal now, @now
  end
end