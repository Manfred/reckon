require File.dirname(__FILE__) + '/shared.rb'

class ExpectationMethodTest < Test::Unit::TestCase
  def setup
    @_test_description = "expects should work"
  end
  
  def test_expects_should_create_new_expectation
    def expects(expected_result)
      Test::Reckon::Expectation.expects(:new).with(2, true, @_test_description)
      expects(2)
    end
  end
  
  def test_rejects_should_create_new_expectation
    def expects(expected_result)
      Test::Reckon::Expectation.expects(:new).with(2, false, @_test_description)
      rejects(2)
    end
  end
end

class TestingTest < Test::Unit::TestCase
  def test_should_leave_instance_variables_intact
    expects(:instance_variables).returns(['@person', '@time'])
    @person = person = "Anne"
    @now = now = Time.now
    
    testing("Some behaviour") { @person = "!Anne" }
    
    assert_equal person, @person
    assert_equal now, @now
  end
end