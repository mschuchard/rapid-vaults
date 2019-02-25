require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'reek/rake/task'

task default: %i[rubocop reek grpc unit system]

RuboCop::RakeTask.new(:rubocop) do |task|
  task.formatters = ['simple']
  task.fail_on_error = false
end

Reek::Rake::Task.new do |task|
  task.fail_on_error = false
end

desc 'Execute unit spec tests'
RSpec::Core::RakeTask.new(:unit) do |task|
  task.pattern = 'spec/{rapid-vaults_spec.rb, rapid-vaults/*_spec.rb}'
end

desc 'Execute system spec tests'
RSpec::Core::RakeTask.new(:system) do |task|
  task.pattern = 'spec/system/*_spec.rb'
end

desc 'Generate gRPC bindings'
task :grpc do
  require 'open3'
  stdout, = Open3.capture2("grpc_tools_ruby_protoc -I #{__dir__}/proto --ruby_out=#{__dir__}/lib/rapid-vaults/bindings --grpc_out=#{__dir__}/lib/rapid-vaults/bindings #{__dir__}/proto/rapid-vaults.proto")
  puts stdout unless stdout.empty?
  grpc_services_text_fix = File.read("#{__dir__}/lib/rapid-vaults/bindings/rapid-vaults_services_pb.rb").gsub(/require 'rapid/, 'require_relative \'rapid')
  File.write("#{__dir__}/lib/rapid-vaults/bindings/rapid-vaults_services_pb.rb", grpc_services_text_fix)
end
