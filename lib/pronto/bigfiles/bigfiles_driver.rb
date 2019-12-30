# frozen_string_literal: true

require 'pronto'
require 'bigfiles/inspector'

module Pronto
  # Performs incremental quality reporting for the bigfiles gem
  class BigFiles < Runner
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
