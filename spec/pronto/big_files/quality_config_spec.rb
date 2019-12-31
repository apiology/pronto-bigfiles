# frozen_string_literal: true

require 'pronto/bigfiles/patch_inspector'

describe Pronto::BigFiles::QualityConfig do
  let(:quality_config) do
    described_class.new(tool_name,
                        quality_threshold: quality_threshold)
  end

  describe '#under_limit?' do
    subject { quality_config.under_limit?(total_lines) }

    let(:tool_name) { 'bigfiles' }
    let(:quality_threshold) do
      instance_double(Pronto::BigFiles::QualityThreshold)
    end
    let(:threshold) { 99 }

    before do
      allow(quality_threshold).to receive(:threshold) { threshold }
    end

    context 'when above threshold' do
      let(:total_lines) { 100 }

      it { is_expected.to be false }
    end

    context 'when below threshold' do
      let(:total_lines) { 98 }

      it { is_expected.to be true }
    end

    context 'when at threshold' do
      let(:total_lines) { 99 }

      it { is_expected.to be true }
    end
  end
end

describe Pronto::BigFiles::QualityThreshold do
  let(:quality_threshold) do
    described_class.new(tool_name,
                        count_file: count_file,
                        count_io: count_io)
  end
  let(:count_file) { class_double(File) }
  let(:count_io) { class_double(IO) }

  describe '#threshold' do
    subject { quality_threshold.threshold }

    let(:metrics_filename) { "metrics/#{tool_name}_high_water_mark" }

    before do
      allow(count_file).to receive(:exist?).with(metrics_filename) do
        file_exists
      end
      if file_exists
        allow(count_io).to receive(:read).with(metrics_filename) do
          high_water_mark.to_s
        end
      end
    end

    context 'when high water mark file exists' do
      let(:tool_name) { 'bigfiles' }
      let(:file_exists) { true }
      let(:high_water_mark) { 923 }

      it { is_expected.to be high_water_mark }
    end

    context 'when high water mark file does not exist' do
      let(:file_exists) { false }

      context 'with bigfiles' do
        let(:tool_name) { 'bigfiles' }

        it { is_expected.to be 300 }
      end

      context 'with another tool' do
        let(:tool_name) { 'another_tool' }

        it { is_expected.to be 0 }
      end
    end
  end
end
