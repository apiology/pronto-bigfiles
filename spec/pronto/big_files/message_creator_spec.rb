# frozen_string_literal: true

require 'pronto/bigfiles/message_creator'

describe Pronto::BigFiles::MessageCreator do
  describe '#create_message' do
    subject(:created_message) do
      message_creator.create_message(patch_wrapper, num_lines)
    end

    let(:message_creator) do
      described_class.new(num_files, total_lines, target_num_lines)
    end
    let(:patch_wrapper) { instance_double(Pronto::BigFiles::PatchWrapper, 'patch_wrapper') }
    let(:commit_sha) { instance_double(String, 'commit_sha') }
    let(:delta) { instance_double(Rugged::Diff::Delta, 'delta') }
    let(:new_file_path) { instance_double(String, 'new_file_path') }
    let(:num_files) { 5 }
    let(:num_lines) { 123 }
    let(:total_lines) { 395 }
    let(:target_num_lines) { 393 }
    let(:first_added_line) do
      instance_double(Pronto::Git::Line, 'first_added_line')
    end

    before do
      allow(first_added_line).to receive(:commit_sha) { commit_sha }
      allow(first_added_line).to receive(:patch) { patch }
      allow(patch_wrapper).to receive(:first_added_line) { first_added_line }
      allow(patch_wrapper).to receive(:path) { new_file_path }
    end

    it { expect { created_message }.not_to raise_error }
    it { expect(created_message.level).to equal(:warning) }
    it { expect(created_message.path).to eq(new_file_path) }
    it { expect(created_message.msg).to be_an_instance_of(String) }
    it { expect(created_message.line).to eq(first_added_line) }
    it { expect(created_message.commit_sha).to eq(commit_sha) }
    it { expect(created_message).to be_an_instance_of(Pronto::Message) }

    it 'gives a good message' do
      expect(created_message.msg)
        .to eq("This file, one of the #{num_files} largest in the project, " \
               "increased in size to #{num_lines} lines.  " \
               "The total size of those files is now #{total_lines} lines " \
               "(target: #{target_num_lines}).  " \
               "Is this file complex enough to refactor?")
    end
  end
end
