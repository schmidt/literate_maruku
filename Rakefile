require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rdoc/task'

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
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
