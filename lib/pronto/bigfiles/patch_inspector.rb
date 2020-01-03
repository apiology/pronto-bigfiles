# frozen_string_literal: true

require 'pronto'
require_relative 'message_creator'

module Pronto
  # Performs incremental quality reporting for the bigfiles gem
  class BigFiles < Runner
    # Inspects patches and returns a Pronto::Message class when appropriate
    class PatchInspector
      def initialize(bigfiles_result,
                     message_creator_class: MessageCreator,
                     bigfiles_config:)
        @message_creator_class = message_creator_class
        @bigfiles_result = bigfiles_result
        @bigfiles_config = bigfiles_config
        @message_creator =
          @message_creator_class.new(@bigfiles_config.num_files,
                                     total_lines,
                                     @bigfiles_config.high_water_mark)
      end

      def under_limit?
        @bigfiles_config.under_limit?(total_lines)
      end

      def total_lines
        @bigfiles_result.map(&:num_lines).reduce(:+)
      end

      def inspect_patch(patch_wrapper)
        path = patch_wrapper.path
        file_with_line = @bigfiles_result.find { |f| f.filename == path }

        return if file_with_line.nil?

        return unless patch_wrapper.added_to?

        return if under_limit?

        @message_creator.create_message(patch_wrapper, file_with_line.num_lines)
      end
    end
  end
end
