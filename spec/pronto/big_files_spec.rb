# frozen_string_literal: true

require 'pronto'
require 'pronto/bigfiles'

describe Pronto::BigFiles do
  let(:commit) { instance_double(String, 'commit') }
  let(:patch_inspector) { instance_double(Pronto::BigFiles::PatchInspector) }
  let(:pronto_bigfiles) do
    described_class.new(patches, commit,
                        bigfiles_inspector: bigfiles_inspector,
                        patch_inspector: patch_inspector)
  end
  let(:bigfiles_inspector) do
    instance_double(BigFiles::Inspector, 'bigfiles_inspector')
  end
  let(:patch) { instance_double(Pronto::Git::Patch, 'patch') }
  let(:filename) { instance_double(String, 'filename') }
  let(:bigfiles_result) { instance_double(Array, 'bigfiles_result') }

  before do
    allow(bigfiles_inspector).to receive(:find_and_analyze) { bigfiles_result }
  end

  describe '#new' do
    subject { pronto_bigfiles }

    let(:patches) { instance_double(Array, 'patches') }

    it 'inherits from Pronto::Runner' do
      expect(described_class.superclass).to eq(Pronto::Runner)
    end
  end

  describe '#run' do
    subject(:pronto_report) { pronto_bigfiles.run }

    context 'with a single patch which returns issues' do
      let(:patches) { [patch] }
      let(:message_a) { instance_double(Pronto::Message, 'message_a') }
      let(:message_b) { instance_double(Pronto::Message, 'message_b') }
      let(:messages) { [message_a, message_b] }

      before do
        allow(patch_inspector).to receive(:inspect_patch).with(patch) do
          messages
        end
      end

      it 'passes back output of inspector' do
        aggregate_failures 'message and side effects' do
          expect(pronto_report).to eq(messages)
          expect(patch_inspector).to have_received(:inspect_patch).with(patch)
        end
      end
    end

    context 'with two patches, the second of which returns two issues' do
      let(:patch_1) { instance_double(Pronto::Git::Patch, 'patch_1') }
      let(:patch_2) { instance_double(Pronto::Git::Patch, 'patch_2') }
      let(:patches) { [patch_1, patch_2] }
      let(:message_a) { instance_double(Pronto::Message, 'message_a') }
      let(:message_b) { instance_double(Pronto::Message, 'message_b') }
      let(:messages_1) { [] }
      let(:messages_2) { [message_a, message_b] }

      before do
        allow(patch_inspector).to receive(:inspect_patch).with(patch_1) do
          messages_1
        end
        allow(patch_inspector).to receive(:inspect_patch).with(patch_2) do
          messages_2
        end
      end

      it 'returns messages passed back by inspector' do
        aggregate_failures 'message and side-effects' do
          expect(pronto_report).to eq([message_a, message_b])
          expect(patch_inspector).to have_received(:inspect_patch).with(patch_1)
          expect(patch_inspector).to have_received(:inspect_patch).with(patch_2)
        end
      end
    end
  end
end
