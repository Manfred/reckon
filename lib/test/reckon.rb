module Test # :nodoc:
  # The Reckon module holds all the classes used in Reckon
  module Reckon
    # = Expectation
    #
    # Encapsulates an expected result for the test, it is usually created through either the +expects+ or +rejects+ method. An
    # expectation basically holds three things:
    #
    # 1. +subject+: The value that houses the binary method used for the test, we'll get into that later.
    # 2. +test_result+: Either +true+ or +false+. This basically means if we expect the test to succeed (+expects+, +true+) or fail
    #    (+rejects+, +false+).
    # 3. +test_description+: The description of the thing we're trying to test with all the test assertions.
    #
    # == Subject, object, and verb
    #
    # Reckon borrows it's concepts from English grammar. The value to be tested is the *subject* of the test, the value returned from
    # the code that is tested is the *object*, and the actual test performed on these values is the *verb*. For example:
    #
    #   expects(1) == 2
    #
    # In the example 1 is the subject, 2 is the object and == is the verb.
    class Expectation
      VERB_MAP = {
        '==' => { true => '==', false => '!=' },
        '=~' => { true => '=~', false => '!~' },
        '>=' => { true => '>=', false => '<' },
        '<=' => { true => '<=', false => '>' },
        '>'  => { true => '>',  false => '<='  },
        '<'  => { true => '<',  false => '>='  }
      }
      
      def initialize(subject, test_result, test_description)
        @subject = subject
        @test_result = test_result
        @test_description = test_description
      end
      
      # Performs the actual test by calling the _verb_ on the _subject_ with the _object_ as argument. You never call this method
      # directly, but mostly through one of the _verbs_. For instance:
      #
      #   expects(1).test('>', 2)
      #
      # Is equal to:
      #
      #   expects(1) > 2
      #
      # The result of the test is compared to the expected +test_result+ and the result is reported to the Reporter singleton.
      def test(verb, object)
        if !!@subject.send(verb, object) == @test_result
          Test::Reckon::Reporter.instance.add_success
        else
          Test::Reckon::Reporter.instance.add_failure(@test_description,
            "#{@subject.inspect} #{VERB_MAP[verb][!@test_result]} #{object.inspect}"
          )
        end
      end
      
      VERB_MAP.keys.each do |verb|
        define_method(verb) do |object|
          test(verb, object)
        end
      end
    end
    
    # = Reporter
    #
    # The reporter is a singleton class that reports and collects all the test outcomes.
    class Reporter
      require 'singleton'
      include Singleton
      
      def initialize
        @successes = @failures = @exceptions = 0
        at_exit { print_stats }
      end
      
      # Reports a failure to the Reporter
      def add_failure(test_description, message)
        filename, line_number, line = extract_context(*caller(3).first.split(/:/, 2))
        
        $stderr.puts "#{filename}:#{line_number}"
        $stderr.puts "  * #{test_description}"
        $stderr.puts "  tested: #{line.strip}"
        $stderr.puts "  but: #{message}"
        @failures += 1
      end
      
      # Reports a broken test to the Reporter
      def add_exception(test_description, exception)
        filename, line_number, line = extract_context(*find_exception(exception.backtrace, caller).split(/:/, 2))
        
        $stderr.puts "#{filename}:#{line_number}"
        $stderr.puts "  * #{test_description}"
        $stderr.puts "  evaluated: #{line.strip}"
        $stderr.puts "  exception: #{exception.inspect}"
        @exceptions += 1
      end
      
      # Reports a successful test to the Reporter
      def add_success
        @successes += 1
      end
      
      # Prints out statistics about all the tests run
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
      
      def find_exception(backtrace, calltrace)
        filename = calltrace[1].split(':').first
        backtrace.find do |line|
          line.split(':').first == filename
        end
      end
    end
  end
end

def testing(description)
  locker = Marshal.dump instance_variables.inject({}) { |vars, name| vars[name] = instance_variable_get(name); vars }
  @_test_description = @_test_description ? "#{@_test_description} #{description}" : description
  yield
rescue Exception => e
  Test::Reckon::Reporter.instance.add_exception(@_test_description, e)
ensure
  @_test_description = nil
  Marshal.load(locker).each { |name, value| instance_variable_set(name, value) } unless locker.nil?
end

def expects(expected_result)
  Test::Reckon::Expectation.new(expected_result, true, @_test_description)
end

def rejects(expected_result)
  Test::Reckon::Expectation.new(expected_result, false, @_test_description)
end