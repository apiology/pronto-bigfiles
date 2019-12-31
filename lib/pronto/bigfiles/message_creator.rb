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
  end
end
