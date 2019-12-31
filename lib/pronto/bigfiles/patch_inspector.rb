# frozen_string_literal: true

require 'pronto'
require_relative 'message_creator'
require 'bigfiles/quality_config'

module Pronto
  # Performs incremental quality reporting for the bigfiles gem
  class BigFiles < Runner
    # Inspects patches and returns a Pronto::Message class when appropriate
    class PatchInspector
      def initialize(bigfiles_result,
                     message_creator_class: MessageCreator,
                     # TODO: Can I move this into quality gem and make
                     # spec that it's part of exported interface'?
                     # TODO: Let's delegate this work to BigfilesConfig
                     quality_config: ::BigFiles::QualityConfig.new('bigfiles'),
                     bigfiles_config:)
        @message_creator_class = message_creator_class
        @bigfiles_result = bigfiles_result
        @bigfiles_config = bigfiles_config
        @quality_config = quality_config
        @message_creator = @message_creator_class.new(num_files,
                                                      total_lines,
                                                      target_num_lines)
      end

      def num_files
        @bigfiles_config.num_files
      end

      def target_num_lines
        @quality_config.high_water_mark
      end

      def under_limit?
        @quality_config.under_limit?(total_lines)
      end

      def total_lines
        @bigfiles_result.map(&:num_lines).reduce(:+)
      end

      def inspect_patch(patch)
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
