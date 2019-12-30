# frozen_string_literal: true

require 'pronto'

module Pronto
  # Performs incremental quality reporting for the bigfiles gem
  class BigFiles < Runner
    class PatchInspector
      def initialize(bigfiles_result)
      end

      def inspect_patch(patch)
        path = patch.delta.new_file[:path]
        line = patch.added_lines.first
        level = :warning
        msg = ""
        Message.new(path, line, level, msg)
      end
    end
  end
end
