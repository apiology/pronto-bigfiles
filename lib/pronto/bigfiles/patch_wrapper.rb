# frozen_string_literal: true

require 'pronto'

module Pronto
  class BigFiles < Runner
    # Add convenience methods on top of Pronto::Git::Patch
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
