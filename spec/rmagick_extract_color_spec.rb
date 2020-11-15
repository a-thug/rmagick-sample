# frozen_string_literal: true

require '../rmagick_extract_color'

describe 'RmagickExtractColor' do
  let(:object) { RmagickExtractColor.new(path) }
  let(:path) { './sample.jpeg' }

  describe '.hist' do
    subject { object.hist }

    before { subject }

    it do
      expect(object.hist).to be_a(Array)
      expect(object.hist.count).to eq(246_498)
    end
  end

  describe '.summarize' do
    subject do
      object.summarized_hist
    end

    before { subject }

    it do
      expect(object.summarized_hist).to be_a(Array)
      expect(object.summarized_hist.count).to eq(2051)
    end
  end

  describe '.display' do
    subject do
      object.display
    end

    before { subject }

    it { expect { subject }.not_to raise_error }
  end

  describe '.summarized_hist_display' do
    subject do
      object.summarized_hist_display
    end

    before { subject }

    it { expect { subject }.not_to raise_error }
  end
end
