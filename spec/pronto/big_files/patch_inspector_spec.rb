# frozen_string_literal: true

require 'pronto/bigfiles/patch_inspector'

describe Pronto::BigFiles::PatchInspector do
  subject { patch_inspector.inspect_patch(patch_wrapper) }

  let(:patch_inspector) do
    described_class.new(bigfiles_result,
                        message_creator_class: message_creator_class,
                        bigfiles_config: bigfiles_config)
  end
  let(:bigfiles_config) do
    instance_double(::BigFiles::Config, 'bigfiles_config')
  end
  let(:patch_wrapper) do
    instance_double(Pronto::BigFiles::PatchWrapper, 'patch_wrapper')
  end
  let(:message_creator_class) { class_double(Pronto::BigFiles::MessageCreator) }
  let(:message_creator) { instance_double(Pronto::BigFiles::MessageCreator) }
  let(:bigfiles_result) { [bigfile_a, bigfile_b] }
  let(:bigfile_a) { instance_double(BigFiles::FileWithLines, 'bigfile_a') }
  let(:bigfile_b) { instance_double(BigFiles::FileWithLines, 'bigfile_b') }
  let(:filename_a) { instance_double(String, 'filename_a') }
  let(:filename_b) { instance_double(String, 'filename_b') }
  let(:filename_d) { instance_double(String, 'filename_d') }
  let(:message) { instance_double(Pronto::Message, 'message') }
  let(:num_lines_a) { instance_double(Integer, 'num_lines_a') }
  let(:num_lines_b) { instance_double(Integer, 'num_lines_b') }
  let(:num_lines_d) { instance_double(Integer, 'num_lines_d') }
  let(:total_lines) { instance_double(Integer, 'total_lines') }
  let(:num_files) { instance_double(Integer, 'num_files') }
  let(:target_num_lines) { instance_double(Integer, 'target_num_lines') }

  before do
    allow(message_creator_class).to receive(:new)
      .with(num_files, total_lines, target_num_lines) do
      message_creator
    end
    allow(message_creator).to receive(:create_message).with(patch_wrapper,
                                                            num_lines) do
      message
    end
    allow(bigfile_a).to receive(:filename) { filename_a }
    allow(bigfile_b).to receive(:filename) { filename_b }
    allow(bigfile_a).to receive(:num_lines) { num_lines_a }
    allow(bigfile_b).to receive(:num_lines) { num_lines_b }
    allow(bigfiles_config).to receive(:under_limit?).with(total_lines) do
      under_limit
    end
    allow(bigfiles_config).to receive(:num_files) { num_files }
    allow(num_lines_a).to receive(:+).with(num_lines_b) { total_lines }
    allow(bigfiles_config).to receive(:high_water_mark) { target_num_lines }
    allow(patch_wrapper).to receive(:path) { new_file_path }
    allow(patch_wrapper).to receive(:added_to?) { added_to }
  end

  # Policy: We complain iff:
  #
  # a file is added to
  # that is in the three complained about
  # and the total ends up above 300
  #
  # ...and we only complain once per file
  context 'with patch to file not in report above limit' do
    let(:new_file_path) { filename_d }
    let(:num_lines) { num_lines_d }
    let(:under_limit) { false }

    it { is_expected.to be_nil }
  end

  context 'with patch to file in report below limit added to' do
    let(:new_file_path) { filename_a }
    let(:num_lines) { num_lines_a }
    let(:under_limit) { true }
    let(:added_to) { true }

    it { is_expected.to be_nil }
  end

  context 'with patch to file in report above limit' do
    let(:new_file_path) { filename_a }
    let(:num_lines) { num_lines_a }
    let(:under_limit) { false }

    context 'with no additions' do
      let(:added_to) { false }

      it { is_expected.to be_nil }
    end

    context 'with more additions than deletions' do
      let(:added_to) { true }

      it { is_expected.to eq(message) }
    end
  end
end
