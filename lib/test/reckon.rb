module Test #:nodoc
  # = Reckon
  #
  # Please explain me!
  module Reckon
    class Expectation
      COMPARISON_MAP = {
        '==' => { true => '==', false => '!=' },
        '>=' => { true => '>=', false => '=<' },
        '<=' => { true => '<=', false => '=>' },
        '>'  => { true => '>',  false => '<'  },
        '<'  => { true => '<',  false => '>'  },
        '=~' => { true => '=~', false => '!~' },
        '!~' => { true => '!~', false => '=~' }
      }
      
      def initialize(expected_value, test_result, test_description)
        @expected_value = expected_value
        @test_result = test_result
        @test_description = test_description
      end
      
      COMPARISON_MAP.keys.each do |method|
        define_method(method) do |other|
          compare(method, other)
        end
      end
      
      private
      
      def compare(method, other)
        reporter = Test::Reckon::Reporter.instance
        if (@expected_value == other) == @test_result
          reporter.add_success
        else
          message = "#{@expected_value.inspect} #{COMPARISON_MAP[method][!@test_result]} #{other.inspect}"
          reporter.add_failure(@test_description, message)
        end
      end
    end
    
    class Reporter
      require 'singleton'
      include Singleton
      
      def initialize
        @failures = 0
        @successes = 0
        @exceptions = 0
        at_exit { print_stats }
      end
      
      def add_failure(test_description, message)
        filename, line_number, line = extract_context(*caller(2).first.split(/:/, 2))
        
        $stderr.puts "#{filename}:#{line_number}"
        $stderr.puts "  * #{test_description}"
        $stderr.puts "  tested: #{line.strip}"
        $stderr.puts "  but: #{message}"
        @failures += 1
      end
      
      def add_exception(test_description, exception)
        filename, line_number, line = extract_context(*exception.backtrace.first.split(/:/, 2))
        
        $stderr.puts "#{filename}:#{line_number}"
        $stderr.puts "  * #{test_description}"
        $stderr.puts "  evaluated: #{line.strip}"
        $stderr.puts "  exception: #{exception.inspect}"
        @exceptions += 1
      end
      
      def add_success
        @successes += 1
      end
      
      def print_stats
        $stderr.puts("\n") if (@failures + @exceptions) > 0
        $stderr.puts("#{@successes} passed, #{@failures} failed, #{@exceptions} broken")
      end
      
      private
      
      def extract_context(filename, line_number)
        filename = File.expand_path(filename)
        line_number = line_number.to_i
        
        lines = File.readlines(filename)
        [filename, line_number, lines[line_number-1]]
      end
    end
  end
end

def testing(description)
  saved = Marshal.dump instance_variables.inject({}) { |saved, name| saved[name] = instance_variable_get(name); saved }
  @_test_description = @_test_description ? "#{@_test_description} #{description}" : description
  yield
rescue Exception => e
  Test::Reckon::Reporter.instance.add_exception(@_test_description, e)
ensure
  @_test_description = nil
  Marshal.load(saved).each { |name, value| instance_variable_set(name, value) }
end

def expects(expected_result)
  Test::Reckon::Expectation.new(expected_result, true, @_test_description)
end

def rejects(expected_result)
  Test::Reckon::Expectation.new(expected_result, false, @_test_description)
end