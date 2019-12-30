require 'pronto/bigfiles/patch_inspector'

describe Pronto::BigFiles::PatchInspector do
  describe '#inspect_patch' do
    subject(:inspection) do
      described_class.new(bigfiles_result).inspect_patch(patch)
    end

    let(:patch) { double('patch') }
    let(:bigfiles_result) { double('bigfiles_result') }

    it { expect { inspection }.not_to raise_error }
  end
end
