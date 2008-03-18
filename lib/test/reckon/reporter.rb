module Test #:nodoc
  module Reckon #:nodoc
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