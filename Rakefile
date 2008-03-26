require 'rake'
require 'rake/clean'
require 'rake/testtask'
require 'rake/gempackagetask'
require 'rake/rdoctask'

NAME = 'reckon'
VERSIE = '0.2'
RDOC_OPTS = ['--quiet', '--title', "Reckon – Leaner automated testing",
    "--opname", "index.html",
    "--line-numbers",
    "--main", "README",
    "--charset", "utf-8",
    "--inline-source"]
CLEAN.include ['pkg', 'doc', '*.gem']

desc "Run all tests by default"
task :default => :test

desc "Run all tests"
task :test do
  Dir[File.dirname(__FILE__) + '/test/**/*_test.rb'].each do |file|
    load file
  end
end

desc 'Create documentation'
Rake::RDocTask.new("doc") do |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.options += RDOC_OPTS
  rdoc.main = "README"
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

spec = Gem::Specification.new do |s|
  s.name = NAME
  s.version = VERSIE
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README", "LICENSE"]
  s.rdoc_options += RDOC_OPTS + ['--exclude', '^(examples|test)\/']
  s.summary = "Lean framework for automated testing"
  s.description = "Reckon is an automated testing framework that aims for simplicity, speed and readability."
  s.author = "Manfred Stienstra"
  s.email = 'manfred@fngtps.com'
  s.homepage = 'https://dwerg.net/svn/reckon'
  s.required_ruby_version = '>= 1.8.6'
  
  s.files = %w(README LICENSE Rakefile) + Dir.glob("lib/**/*") +  Dir.glob("examples/**/*")
  s.require_path = "lib"
end

Rake::GemPackageTask.new(spec) do |p|
    p.tar_command = "env COPYFILE_DISABLE=true tar"
    p.need_tar = true
    p.gem_spec = spec
end

task :install do
  sh %{rake package}
  sh %{sudo gem install pkg/#{NAME}-#{VERSIE}}
end

task :uninstall => [:clean] do
  sh %{sudo gem uninstall #{NAME}}
end
