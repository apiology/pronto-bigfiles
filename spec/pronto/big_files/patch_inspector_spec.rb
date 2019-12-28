require 'pronto/bigfiles/patch_inspector'

describe Pronto::BigFiles::PatchInspector do
  describe '#inspect_patch' do
    subject(:inspection) { described_class.new.inspect_patch(patch) }

    let(:patch) { double('patch') }

    it { expect { inspection }.not_to raise_error }
  end
end
