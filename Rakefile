require 'rake'
require 'rake/rdoctask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "literate_maruku"
    gemspec.summary = "Literate programming for Ruby based on Maruku."
    gemspec.description = "Given Ruby's open classes and Maruku's powerful " + 
      "parser architecture, literate_maruku provides a basic literate " +
      "programming environment for Ruby."
    gemspec.email = "ruby@schmidtwisser.de"
    gemspec.homepage = "http://github.com/schmidt/literate_maruku"
    gemspec.authors = ["Gregor Schmidt"]

    gemspec.executable = "literate_maruku"

    gemspec.add_dependency('maruku', '>= 0.6.0')

    gemspec.add_development_dependency('rake')
    gemspec.add_development_dependency('jeweler', '>= 1.4.0')
  end

  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install jeweler"
end

desc "Run all tests"
task :test do 
  require 'rake/runtest'
  Rake.run_tests 'test/**/*_test.rb'
end

desc 'Generate documentation for the literate_maruku gem.'
Rake::RDocTask.new(:doc) do |doc|
  doc.rdoc_dir = 'doc'
  doc.title = 'literate_maruku'
  doc.options << '--line-numbers' << '--inline-source'
  doc.rdoc_files.include('README.rdoc')
  doc.rdoc_files.include('lib/**/*.rb')
end

task :default => :test
