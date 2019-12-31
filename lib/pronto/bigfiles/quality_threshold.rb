# frozen_string_literal: true

require 'pronto'

module Pronto
  # Performs incremental quality reporting for the bigfiles gem
  class BigFiles < Runner
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
  end
end
