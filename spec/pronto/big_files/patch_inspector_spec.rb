require 'pronto/bigfiles/patch_inspector'

describe Pronto::BigFiles::PatchInspector do
  describe '#inspect_patch' do
    subject(:inspection) do
      described_class.new(bigfiles_result).inspect_patch(patch)
    end

    let(:patch) { instance_double(Pronto::Git::Patch, 'patch') }

    context 'when single file added to ' \
            'that is one of the three complained about, ' \
            'and is above limit' do
      let(:bigfiles_result) { [] }
      let(:first_added_line) do
        instance_double(Pronto::Git::Line, 'first_added_line')
      end
      let(:commit_sha) { instance_double(String, 'commit_sha') }
      let(:added_lines) { [first_added_line] }
      let(:delta) { instance_double(Rugged::Diff::Delta, 'delta') }
      let(:new_file_path) { instance_double(String, 'new_file_path') }
      let(:new_file) { { path: new_file_path } }

      before do
        allow(patch).to receive(:added_lines) { added_lines }
        allow(first_added_line).to receive(:commit_sha) { commit_sha }
        allow(first_added_line).to receive(:patch) { patch }
        allow(patch).to receive(:delta) { delta }
        allow(delta).to receive(:new_file) { new_file }
      end

      it { expect { inspection }.not_to raise_error }
      it { expect(inspection.level).to equal(:warning) }
      it { expect(inspection.path).to eq(new_file_path) }
      it { expect(inspection.msg).to be_an_instance_of(String) }
      it { expect(inspection.line).to eq(first_added_line) }
      it { expect(inspection.commit_sha).to eq(commit_sha) }
      it { expect(inspection).to be_an_instance_of(Pronto::Message) }

      xit "should give a message which mentions name of file and that it's pushing up limit"
    end
  end
end
