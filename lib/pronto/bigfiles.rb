# frozen_string_literal: true

require 'pronto/bigfiles/version'
require 'pronto/bigfiles/patch_inspector'
require 'pronto/bigfiles/bigfiles_driver'
require 'pronto'

module Pronto
  # Performs incremental quality reporting for the bigfiles gem
  class BigFiles < Runner
    def initialize(patches, commit = nil,
                   bigfiles_driver: BigFilesDriver.new,
                   patch_inspector: PatchInspector.new(bigfiles_driver.run))
      super(patches, commit)
      @patch_inspector = patch_inspector
    end

    class Error < StandardError; end
    def run
      # TODO: This should calculate a bigfiles result and pass it around
      @patches.flat_map { |patch| inspect_patch(patch) }
    end

    def inspect_patch(patch)
      @patch_inspector.inspect_patch(patch)
    end
  end
end
