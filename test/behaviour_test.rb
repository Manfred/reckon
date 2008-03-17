PROJECT_ROOT = File.expand_path('../', File.dirname(__FILE__))
$:.unshift(File.join(PROJECT_ROOT, 'lib'))

require 'test/reckon'

testing "Reckon" do
  @description = 'vla'
  testing "should support equality" do
    expects(1) == 1
    expects(false) == false
  end
  
  testing "should show a failure for this test (:" do
    expects(1) == 2
  end
end