# frozen_string_literal: true

require 'pronto'
require_relative 'quality_threshold'

module Pronto
  # Performs incremental quality reporting for the bigfiles gem
  class BigFiles < Runner
    class QualityConfig
      def initialize(tool_name,
                     quality_threshold: QualityThreshold.new(tool_name))
        @quality_threshold = quality_threshold
      end

      def under_limit?(total_lines)
        total_lines <= @quality_threshold.threshold
      end
    end
  end
end
