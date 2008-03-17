module Test #:nodoc
  module Reckon #:nodoc
    class Reporter
      require 'singleton'
      include Singleton
      
      def initialize
        @failures = 0
        @successes = 0
        at_exit { print_stats }
      end
      
      def add_failure(test_description, message)
        file, line = caller(2)[0].split(/:/, 2)
        $stderr.puts "#{File.expand_path(file)}:#{line.to_i}"
        $stderr.puts "  * #{test_description}"
        $stderr.puts "  expected: TODO"
        $stderr.puts "  but: #{message}"
        @failures += 1
      end
      
      def add_success
        @successes += 1
      end
      
      def print_stats
        $stderr.puts("\n") if @failures > 0
        $stderr.puts("#{@successes} passed, #{@failures} failed")
      end
    end
  end
end