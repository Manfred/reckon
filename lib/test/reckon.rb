require 'test/reckon/expectation'
require 'test/reckon/reporter'

def testing(description)
  saved = Marshal.dump instance_variables.inject({}) { |saved, name| saved[name] = instance_variable_get(name); saved }
  @_test_description = @_test_description ? "#{@_test_description} #{description}" : description
  yield
  @_test_description = nil
  Marshal.load(saved).each { |name, value| instance_variable_set(name, value) }
end

def expects(expected_result)
  Test::Reckon::Expectation.new(expected_result, true, @_test_description)
end

def rejects(expected_result)
  Test::Reckon::Expectation.new(expected_result, false, @_test_description)
end