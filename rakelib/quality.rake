# frozen_string_literal: true

require 'quality/rake/task'

Quality::Rake::Task.new do |task|
  task.exclude_files = ['Gemfile.lock']
  # cane deprecated in favor of rubocop, reek rarely actionable
  task.skip_tools = %w[reek cane eslint jscs flake8]
  task.output_dir = 'metrics'
end

task quality: %i[pronto update_bundle_audit]
