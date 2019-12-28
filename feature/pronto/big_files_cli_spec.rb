# frozen_string_literal: true

require 'pronto/bigfiles'
require 'tmpdir'
require 'open3'

describe Pronto::BigFiles do
  let(:env) do
    {
      # Avoid spurious deprecation warnings in things which are out of
      # our control
      'RUBYOPT' => '-W0',
    }
  end

  describe 'bundle exec pronto list' do
    let(:expected_output) do
      <<~OUTPUT
        bigfiles
      OUTPUT
    end

    it 'lists this as a runner' do
      out, exit_code = Open3.capture2e(env, 'bundle exec pronto list')
      expect(out).to include(expected_output)
      expect(exit_code).to eq(0)
    end
  end

  describe 'bundle exec pronto run --staged -r bigfiles -f text' do
    let(:pronto_command) do
      'bundle exec pronto run --staged -r bigfiles -f text'
    end

    around do |example|
      Dir.mktmpdir do |dir|
        Dir.chdir(dir) do
          system('git init')
          File.write('README.md', 'Initial commit contents')
          system('git add .')
          system('git commit -m "First commit"')
          example_files.each do |filename, contents|
            File.write(filename, contents)
          end
          system('git add .')
          example.run
        end
      end
    end

    # TODO: Add specs to match policy below
    #
    # Policy: We complain iff:
    #
    # a file is added to
    # that is in the three complained about
    # and the total ends up above 300
    #
    # ...and we only complain once per file
    context 'when single file added to ' \
            'that is one of the three complained about, ' \
            'and is above limit' do
      xit 'complains on line of first change'
    end

    context 'when single file removed from ' \
            'that is one of the three complained about, ' \
            'and is above limit' do
      xit 'does not complain'
    end

    context 'when single file added to ' \
            'that is not one of the three complained about, ' \
            'and is above limit' do
      xit 'does not complain'
    end

    context 'when single file added to ' \
            'that is one of the three complained about, ' \
            'but is below limit of 300' do
      xit 'does not complain'
    end
  end
end
