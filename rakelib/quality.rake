# frozen_string_literal: true

require 'quality/rake/task'

Quality::Rake::Task.new do |task|
  task.exclude_files = ['Gemfile.lock']
  # cane deprecated in favor of rubocop, reek rarely actionable
  task.skip_tools = %w[reek cane eslint jscs flake8]
  task.output_dir = 'metrics'
  task.punchlist_regexp = 'XX' \
                          'X|TOD' \
                          'O|FIXM' \
                          'E|OPTIMIZ' \
                          'E|HAC' \
                          'K|REVIE' \
                          'W|LATE' \
                          'R|FIXI' \
                          'T|xi' \
                          't '
end

task quality: %i[pronto update_bundle_audit]
