require 'pronto'

module Pronto
  class BigFiles < Runner
    class PatchWrapper
      attr_reader :patch

      def initialize(patch)
        @patch = patch
      end

      def added_to?
        (patch.additions - patch.deletions).positive?
      end

      def path
        patch.delta.new_file[:path]
      end

      def first_added_line
        patch.added_lines.first
      end
    end
  end
end
