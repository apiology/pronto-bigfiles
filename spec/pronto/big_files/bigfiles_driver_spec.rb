require 'pronto/bigfiles/bigfiles_driver'
require 'bigfiles/inspector'

describe Pronto::BigFiles::BigFilesDriver do
  let(:inspector) { instance_double(BigFiles::Inspector, 'inspector') }
  let(:file_and_line_objs) { instance_double(Array, 'file_and_line_objs') }
  let(:driver) { described_class.new(inspector: inspector) }

  describe '#run' do
    subject(:results) { driver.run }

    before do
      allow(inspector).to receive(:find_and_analyze) { file_and_line_objs }
    end

    it { expect { results }.not_to raise_error }

    it 'calls into inspector' do
      results
      expect(inspector).to have_received(:find_and_analyze)
    end
  end
end
