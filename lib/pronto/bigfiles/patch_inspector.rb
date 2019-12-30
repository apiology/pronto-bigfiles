# frozen_string_literal: true

require 'pronto'

module Pronto
  # Performs incremental quality reporting for the bigfiles gem
  class BigFiles < Runner
    # Creates Pronto warning message objects
    class MessageCreator
      attr_reader :patch

      # TODO: accept in bigfiles threshold
      def initialize; end

      def create_message(patch, num_lines)
        path = patch.delta.new_file[:path]
        line = patch.added_lines.first
        level = :warning
        # TODO: accept in number of lines in file
        msg = "This file, one of the 3 largest in the project, " \
              "increased in size to #{num_lines} lines.  " \
              "Is it complex enough to refactor?"
        Message.new(path, line, level, msg)
      end
    end

    # Inspects patches and returns a Pronto::Message class when appropriate
    class PatchInspector
      def initialize(bigfiles_result,
                     message_creator_class: MessageCreator)
        @message_creator_class = message_creator_class
        @message_creator = @message_creator_class.new
        @bigfiles_result = bigfiles_result
      end

      def inspect_patch(patch)
        path = patch.delta.new_file[:path]
        file_with_line = @bigfiles_result.find { |f| f.filename == path }
        return if file_with_line.nil? || !patch.additions.positive?

        @message_creator.create_message(patch, file_with_line.num_lines)
      end
    end
  end
end
