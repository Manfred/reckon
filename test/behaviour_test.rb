PROJECT_ROOT = File.expand_path('../', File.dirname(__FILE__))
$:.unshift(File.join(PROJECT_ROOT, 'lib'))

require 'test/reckon'

testing "Reckon" do
  testing "should support equality" do
    expects(false) == false
  end
  
  testing "should show a failure for unequality" do
    expects(1) == 2
  end
  
  testing "should support rejecting unequality" do
    rejects(2) == 1
  end
  
  testing "should show a failure for rejecting equality" do
    rejects(2) == 2
    
    testing "and give correct line when callstack is deeper" do
      rejects(3) == 3
    end
  end
  
  testing "should show expections when they occur" do
    expects(Unknown) == Unknown
  end
end