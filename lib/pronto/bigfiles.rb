# frozen_string_literal: true

require 'pronto/punchlist/version'
require 'pronto/punchlist/patch_inspector'
require 'pronto/punchlist/driver'
require 'pronto/punchlist/patch_validator'
require 'pronto'

module Pronto
  # Performs incremental quality reporting for the bigfiles gem
  class BigFiles < Runner
    def initialize(patches, commit = nil,
                   bigfiles_driver: BigFilesDriver.new,
                   patch_inspector: PatchInspector.new(bigfiles_driver:
                                                         bigfiles_driver),
                   patch_validator: PatchValidator.new)
      super(patches, commit)
      @patch_inspector = patch_inspector
      @patch_validator = patch_validator
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
