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

    class QualityThreshold
      attr_reader :tool_name

      def initialize(tool_name,
                     count_file: File,
                     count_io: IO,
                     output_dir: 'metrics')
        @tool_name = tool_name
        @count_file = count_file
        @count_io = count_io
        @filename = File.join(output_dir, "#{tool_name}_high_water_mark")
      end

      def threshold
        if @count_file.exist?(@filename)
          @count_io.read(@filename).to_i
        else
          return 300 if tool_name == 'bigfiles'

          0
        end
      end
    end

    class QualityConfig
      def initialize(tool_name,
                     quality_threshold: QualityThreshold.new(tool_name))
        @quality_threshold = quality_threshold
      end

      def under_limit?(total_lines)
        total_lines <= @quality_threshold.threshold
      end
    end

    # Inspects patches and returns a Pronto::Message class when appropriate
    class PatchInspector
      def initialize(bigfiles_result,
                     message_creator_class: MessageCreator,
                     # TODO: Can I move this into quality gem and make
                     # spec that it's part of exported interface'?
                     quality_config: QualityConfig.new('bigfiles'))
        @message_creator_class = message_creator_class
        @message_creator = @message_creator_class.new
        @bigfiles_result = bigfiles_result
        @quality_config = quality_config
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
