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
        msg = "This file, one of the 3 largest in the project, " \
              "increased in size to #{num_lines} lines.  " \
              "Is it complex enough to refactor?"
        Message.new(path, line, level, msg)
      end
    end

    class QualityConfig
      def under_limit?(tool_name, total_lines)
        false
      end
    end

    # Inspects patches and returns a Pronto::Message class when appropriate
    class PatchInspector
      def initialize(bigfiles_result,
                     message_creator_class: MessageCreator,
                     # TODO: Can I move this into quality gem and make
                     # spec that it's part of exported interface'?
                     quality_config: QualityConfig.new)
        @message_creator_class = message_creator_class
        @message_creator = @message_creator_class.new
        @bigfiles_result = bigfiles_result
        @quality_config = quality_config
      end

      def under_limit?
        @quality_config.under_limit?('bigfiles', total_lines)
      end

      def total_lines
        @bigfiles_result.map(&:num_lines).reduce(:+)
      end

      def inspect_patch(patch)
        # TODO: Some of this nastiness should be put into a
        # BigFiles-exported object.  Maybe extract that out here and
        # then import into there?
        path = patch.delta.new_file[:path]
        file_with_line = @bigfiles_result.find { |f| f.filename == path }

        return if file_with_line.nil?

        return unless (patch.additions - patch.deletions).positive?

        return if under_limit?

        @message_creator.create_message(patch, file_with_line.num_lines)
      end
    end
  end
end
