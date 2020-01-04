# frozen_string_literal: true

require 'pronto'

module Pronto
  # Performs incremental quality reporting for the bigfiles gem
  class BigFiles < Runner
    # Creates Pronto warning message objects
    class MessageCreator
      attr_reader :num_files, :total_lines, :target_num_lines

      def initialize(num_files, total_lines, target_num_lines)
        @num_files = num_files
        @total_lines = total_lines
        @target_num_lines = target_num_lines
      end

      def create_message(patch_wrapper, num_lines)
        path = patch_wrapper.path
        line = patch_wrapper.first_added_line
        level = :warning
        msg = "This file, one of the #{num_files} largest in the project, " \
              "increased in size to #{num_lines} lines.  The total size " \
              "of those files is now #{total_lines} lines " \
              "(target: #{target_num_lines}).  Is this file complex " \
              "enough to refactor?"
        Message.new(path, line, level, msg, nil, Pronto::BigFiles)
      end
    end
  end
end
