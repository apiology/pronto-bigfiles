# frozen_string_literal: true

require 'pronto'

module Pronto
  # Performs incremental quality reporting for the bigfiles gem
  class BigFiles < Runner
    class MessageCreator
      attr_reader :patch

      # TODO: accept in bigfiles threshold
      def initialize
      end

      def create_message(patch)
        path = patch.delta.new_file[:path]
        line = patch.added_lines.first
        level = :warning
        # TODO: accept in number of lines in file
        msg = 'This file, one of the 3 largest in the project, ' \
              'increased in size to 301 lines.  ' \
              'Is it complex enough to refactor?'
        Message.new(path, line, level, msg)
      end
    end

    class PatchInspector
      def initialize(bigfiles_result,
                     message_creator_class: MessageCreator)
        @message_creator_class = message_creator_class
        @message_creator = @message_creator_class.new
        @filenames = bigfiles_result.map(&:filename)
      end

      def inspect_patch(patch)
        path = patch.delta.new_file[:path]
        return unless @filenames.include?(path) && patch.additions.positive?

        @message_creator.create_message(patch)
      end
    end
  end
end
