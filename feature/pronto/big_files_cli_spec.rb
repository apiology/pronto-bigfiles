# frozen_string_literal: true

require 'pronto/bigfiles'
require 'tmpdir'
require 'open3'

describe Pronto::BigFiles do
  let(:env) do
    {
      # Avoid spurious deprecation warnings in things which are out of
      # our control
      #
      # Save existing RUBYOPT if set; bundler uses it
      'RUBYOPT' => [ENV['RUBYOPT'], '-W0'].compact.join(' '),
    }
  end

  describe 'bundle exec pronto list' do
    it 'lists this as a runner' do
      out, exit_code = Open3.capture2e(env, 'bundle exec pronto list')
      expect(out).to include("bigfiles\n")
      expect(exit_code).to eq(0)
    end
  end

  describe 'bundle exec pronto run --staged -r bigfiles -f text' do
    let(:pronto_command) do
      'bundle exec pronto run --staged -r bigfiles -f text'
    end

    let(:results) { Open3.capture2e(env, pronto_command) }
    let(:out) { results[0] }
    let(:exit_code) { results[1] }

    around do |example|
      Dir.mktmpdir do |dir|
        Dir.chdir(dir) do
          system('git init')
          system('git config user.email "you@example.com"')
          system('git config user.name "Fake User"')
          example_files_committed.each do |filename, contents|
            File.write(filename, contents)
          end
          system('git add .')
          system('git commit -m "First commit"')
          example_files_staged.each do |filename, contents|
            File.write(filename, contents)
          end
          system('git add .')
          example.run
        end
      end
    end

    # Policy: We complain iff:
    #
    # a file is added to
    # that is in the three complained about
    # and the total ends up above 300
    #
    # ...and we only complain once per file
    context 'when single file net added to ' \
            'that is one of the three complained about, ' \
            'and is above limit' do
      let(:expected_output) do
        "one_line_added_above_limit.rb:302 W: This file, one of the " \
        "3 largest in the project, increased in size to 302 lines.  " \
        "The total size of those files is now 502 lines (target: 300).  " \
        "Is this file complex enough to refactor?\n"
      end

      let(:example_files_committed) do
        {
          'one_line_added_above_limit.rb' => ("\n" * 301),
          'some_other_file_1.rb' => ("\n" * 100),
          'some_other_file_2.rb' => ("\n" * 100),
        }
      end

      let(:example_files_staged) do
        { 'one_line_added_above_limit.rb' => ("\n" * 302) }
      end

      it 'complains on line of first change' do
        expect(out).to eq(expected_output)
        expect(exit_code).to eq(0)
      end
    end
  end
end
