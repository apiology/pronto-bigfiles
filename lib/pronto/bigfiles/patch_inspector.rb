# frozen_string_literal: true

require 'pronto'

module Pronto
  # Performs incremental quality reporting for the bigfiles gem
  class BigFiles < Runner
    class MessageCreator
      attr_reader :patch

      def initialize(patch)
        @patch = patch
      end

      def create_message
        path = patch.delta.new_file[:path]
        line = patch.added_lines.first
        level = :warning
        msg = ""
        Message.new(path, line, level, msg)
      end
    end

    class PatchInspector
      def initialize(bigfiles_result,
                     message_creator_class: MessageCreator)
        @message_creator_class = message_creator_class
      end

      def inspect_patch(patch)
        @message_creator_class.new(patch).create_message
      end
    end
  end
end
