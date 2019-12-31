# frozen_string_literal: true

require 'pronto/bigfiles/patch_inspector'

describe Pronto::BigFiles::QualityConfig do
  let(:quality_config) { described_class.new }

  describe '#under_limit?' do
    subject { quality_config.under_limit?(tool_name, total_lines) }

    let(:tool_name) { 'tool_name' }

    context 'when metrics file does not exist' do
      context 'when above 300' do
        let(:total_lines) { 301 }

        it { is_expected.to be false }
      end

      context 'when at 300' do
        let(:total_lines) { 300 }

        xit { is_expected.to be true }
      end

      context 'when below 300' do
        let(:total_lines) { 299 }

        xit { is_expected.to be false }
      end
    end

    context 'when metrics file does exist' do
      xit { is_expected.not_to eq(nil) }

      context 'when above that number' do
        let(:total_lines) { 1401 }

        xit { is_expected.to be false }
      end

      context 'when at that number' do
        let(:total_lines) { 1400 }

        xit { is_expected.to be true }
      end

      context 'when below that number' do
        let(:total_lines) { 1399 }

        xit { is_expected.to be false }
      end
    end
  end
end
