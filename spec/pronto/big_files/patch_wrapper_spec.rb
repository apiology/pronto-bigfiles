# frozen_string_literal: true

require 'pronto/bigfiles/patch_wrapper'

describe Pronto::BigFiles::PatchWrapper do
  let(:patch_wrapper) { described_class.new(patch) }
  let(:patch) { instance_double(Pronto::Git::Patch) }

  describe '#added_to?' do
    subject { patch_wrapper.added_to? }

    let(:additions) { instance_double(Integer) }
    let(:deletions) { instance_double(Integer) }
    let(:difference) { instance_double(Integer) }
    let(:added_to) { instance_double(Object) }

    before do
      allow(patch).to receive(:additions) { additions }
      allow(patch).to receive(:deletions) { deletions }
      allow(additions).to receive(:-).with(deletions) { difference }
      allow(difference).to receive(:positive?) { added_to }
    end

    it { is_expected.to eq(added_to) }
  end

  describe '#first_added_line' do
    subject { patch_wrapper.first_added_line }

    let(:first_added_line) do
      instance_double(Pronto::Git::Line, 'first_added_line')
    end
    let(:added_lines) { [first_added_line] }

    before do
      allow(patch).to receive(:added_lines) { added_lines }
    end

    it { is_expected.to eq(first_added_line) }
  end

  describe '#path' do
    subject { patch_wrapper.path }

    let(:delta) { instance_double(Rugged::Diff::Delta, 'delta') }
    let(:new_file) { { path: path } }
    let(:path) { instance_double(String, 'path') }

    before do
      allow(patch).to receive(:delta) { delta }
      allow(delta).to receive(:new_file) { new_file }
    end

    it { is_expected.to eq(path) }
  end
end
