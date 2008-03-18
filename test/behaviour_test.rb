PROJECT_ROOT = File.expand_path('../', File.dirname(__FILE__))
$:.unshift(File.join(PROJECT_ROOT, 'lib'))

require 'test/reckon'

testing "Reckon" do
  @description = 'vla'
  testing "should support equality" do
    expects(false) == false
  end
  
  testing "should show a failure for unequality" do
    expects(1) == 2
  end
  
  testing "should support rejecting unequality" do
    rejects(2) == 1
  end
  
  testing "should show a failure for rejecting unequality" do
    rejects(2) == 2
  end
end