# frozen_string_literal: true

require 'pronto'

module Pronto
  # Performs incremental quality reporting for the bigfiles gem
  class BigFiles < Runner
    class PatchInspector
      def inspect_patch(patch)
      end
    end
  end
end
