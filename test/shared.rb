PROJECT_ROOT = File.expand_path('../', File.dirname(__FILE__))
$:.unshift(File.join(PROJECT_ROOT, 'lib'))

require 'rubygems' rescue nil

require 'test/unit'
require 'test/reckon'

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
