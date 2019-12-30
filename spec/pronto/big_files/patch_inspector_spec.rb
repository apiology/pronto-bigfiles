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
  let(:bigfiles_result) { [] }
  let(:message) { instance_double(Pronto::Message, 'message') }

  before do
    allow(message_creator_class).to receive(:new).with(bigfiles_result) do
      message_creator
    end
    allow(message_creator).to receive(:create_message) { message }
  end

  it { is_expected.to eq(message) }
end
