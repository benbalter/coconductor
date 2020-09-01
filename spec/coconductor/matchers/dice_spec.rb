# frozen_string_literal: true

RSpec.describe Coconductor::Matchers::Dice do
  subject { described_class.new(file) }

  let(:filename) { 'CODE_OF_CONDUCT.txt' }
  let(:cc_1_4) do
    Coconductor::CodeOfConduct.find('contributor-covenant/version/1/4')
  end
  let(:content) { cc_1_4.content }
  let(:file) do
    Coconductor::ProjectFiles::CodeOfConductFile.new(content, filename)
  end

  it 'stores the file' do
    expect(subject.file).to eql(file)
  end

  it 'matches' do
    expect(subject.match).to eql(cc_1_4)
  end

  it 'is confident' do
    expect(subject.confidence).to be(100.0)
  end

  context 'with words added' do
    let(:content) { "#{cc_1_4.content}foo" }

    it 'matches' do
      expect(subject.match).to eql(cc_1_4)
    end

    it 'is confident' do
      expect(subject.confidence).to be(99.59514170040485)
    end
  end

  context 'random text' do
    let(:content) { 'a random string' }

    it "doesn't match" do
      expect(subject.match).to be_nil
    end

    it "isn't confident" do
      expect(subject.confidence).to be(0)
    end
  end
end
