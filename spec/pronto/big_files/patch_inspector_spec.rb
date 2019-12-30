require 'pronto/bigfiles/patch_inspector'

describe Pronto::BigFiles::PatchInspector do
  subject { patch_inspector.inspect_patch(patch) }

  let(:patch_inspector) do
    described_class.new(bigfiles_result,
                        message_creator_class: message_creator_class)
  end
  let(:patch) { instance_double(Pronto::Git::Patch, 'patch') }
  let(:message_creator_class) { class_double(Pronto::BigFiles::MessageCreator) }
  let(:message_creator) { instance_double(Pronto::BigFiles::MessageCreator) }
  let(:bigfiles_result) { [bigfile_a, bigfile_b] }
  let(:bigfile_a) { instance_double(BigFiles::FileWithLines, 'bigfile_a') }
  let(:bigfile_b) { instance_double(BigFiles::FileWithLines, 'bigfile_b') }
  let(:filename_a) { instance_double(String, 'filename_a') }
  let(:filename_b) { instance_double(String, 'filename_b') }
  let(:filename_d) { instance_double(String, 'filename_d') }
  let(:message) { instance_double(Pronto::Message, 'message') }
  let(:delta) { instance_double(Rugged::Diff::Delta, 'delta') }
  let(:new_file) { { path: new_file_path } }
  let(:num_lines_a) { instance_double(Integer, 'num_lines_a') }
  let(:num_lines_b) { instance_double(Integer, 'num_lines_b') }
  let(:num_lines_d) { instance_double(Integer, 'num_lines_d') }

  before do
    allow(message_creator_class).to receive(:new).with(no_args) do
      message_creator
    end
    allow(message_creator).to receive(:create_message).with(patch, num_lines) do
      message
    end
    allow(patch).to receive(:additions) { additions }
    allow(patch).to receive(:deletions) { deletions }
    allow(bigfile_a).to receive(:filename) { filename_a }
    allow(bigfile_b).to receive(:filename) { filename_b }
    allow(patch).to receive(:delta) { delta }
    allow(delta).to receive(:new_file) { new_file }
    allow(bigfile_a).to receive(:num_lines) { num_lines_a }
    allow(bigfile_b).to receive(:num_lines) { num_lines_b }
  end

  context 'with patch to file not in report' do
    let(:new_file_path) { filename_d }
    let(:num_lines) { num_lines_d }

    context 'with more additions than deletions' do
      let(:additions) { 1 }
      let(:deletions) { 0 }

      it { is_expected.to eq(nil) }
    end
  end

  context 'with patch to file in report' do
    let(:new_file_path) { filename_a }
    let(:num_lines) { num_lines_a }

    context 'with more additions than deletions' do
      let(:additions) { 1 }
      let(:deletions) { 0 }

      it { is_expected.to eq(message) }
    end

    context 'with more deletions than additions' do
      let(:additions) { 0 }
      let(:deletions) { 1 }

      it { is_expected.to eq(nil) }
    end

    context 'with no net change' do
      xit
    end
  end

  # TODO: Add specs to match policy below
  #
  # Policy: We complain iff:
  #
  # a file is added to
  # that is in the three complained about
  # and the total ends up above 300
  #
  # ...and we only complain once per file
  context 'when single file net added to ' \
          'that is one of the three complained about, ' \
          'and is above limit' do
    xit 'complains on line of first change'
  end

  context 'when single file removed from ' \
          'that is one of the three complained about, ' \
          'and is above limit' do
    xit 'does not complain'
  end

  context 'when single file net added to ' \
          'that is not one of the three complained about, ' \
          'and is above limit' do
    xit 'does not complain'
  end

  context 'when single file untouched ' \
          'that is not one of the three complained about, ' \
          'and is above limit' do
    xit 'does not complain'
  end

  context 'when single file net added to ' \
          'that is one of the three complained about, ' \
          'but is below limit of 300' do
    xit 'does not complain'
  end
end
