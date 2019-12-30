# frozen_string_literal: true

require 'pronto'
require 'bigfiles/inspector'

module Pronto
  # Performs incremental quality reporting for the bigfiles gem
  class BigFiles < Runner
    # TODO: Should I collapse this back in?
    # Runs the BigFiles inspector class and returns results
    class BigFilesDriver
      def initialize(inspector: ::BigFiles::Inspector.new)
        @inspector = inspector
      end

      def run
        @inspector.find_and_analyze
      end
    end
  end
end
