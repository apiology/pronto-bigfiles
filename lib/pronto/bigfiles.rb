# frozen_string_literal: true

require 'pronto/bigfiles/version'
require 'pronto/bigfiles/patch_inspector'
require 'bigfiles/inspector'
require 'pronto'

module Pronto
  # Performs incremental quality reporting for the bigfiles gem
  class BigFiles < Runner
    def initialize(patches, commit = nil,
                   bigfiles_inspector: ::BigFiles::Inspector.new,
                   bigfiles_results: bigfiles_inspector.find_and_analyze,
                   patch_inspector: PatchInspector.new(bigfiles_results))
      super(patches, commit)
      @patch_inspector = patch_inspector
    end

    class Error < StandardError; end
    def run
      @patches.flat_map { |patch| inspect_patch(patch) }
    end

    def inspect_patch(patch)
      @patch_inspector.inspect_patch(patch)
    end
  end
end
