RSpec.describe Coconductor::ProjectFiles::ProjectFile do
  let(:filename) { 'CODE_OF_CONDUCT.txt' }
  let(:cc_1_4) do
    Coconductor::CodeOfConduct.find('contributor-covenant/version/1/4')
  end
  let(:content) { cc_1_4.content }
  let(:possible_matchers) { [Coconductor::Matchers::Exact] }
  let(:metadata) { { name: filename } }

  subject { described_class.new(content, metadata) }

  before do
    allow(subject).to receive(:possible_matchers).and_return(possible_matchers)
  end

  before { allow(subject).to receive(:length).and_return(cc_1_4.length) }
  before { allow(subject).to receive(:wordset).and_return(cc_1_4.wordset) }

  it 'stores the content' do
    expect(subject.content).to eql(cc_1_4.content)
  end

  it 'store the filename' do
    expect(subject.filename).to eql(filename)
  end

  it 'returns the matcher' do
    expect(subject.matcher).to be_a(Licensee::Matchers::Exact)
  end

  it 'returns the confidence' do
    expect(subject.confidence).to eql(100)
  end

  it 'returns the code of conduct' do
    expect(subject.code_of_conduct).to eql(cc_1_4)
  end

  it 'returns the path' do
    expect(subject.path).to eql('CODE_OF_CONDUCT.txt')
  end

  it 'returns the relative path' do
    expect(subject.relative_path).to eql('./CODE_OF_CONDUCT.txt')
  end

  it 'returns the directory' do
    expect(subject.directory).to eql '.'
  end

  context 'a subdir' do
    let(:metadata) { { name: filename, dir: '.github' } }

    it 'returns the path' do
      expect(subject.path).to eql('CODE_OF_CONDUCT.txt')
    end

    it 'returns the relative path' do
      expect(subject.relative_path).to eql('.github/CODE_OF_CONDUCT.txt')
    end

    it 'returns the directory' do
      expect(subject.directory).to eql '.github'
    end
  end

  context 'an unknown code of conduct' do
    let(:content) { 'something else' }
    let(:other) { Coconductor::CodeOfConduct.find('other') }
    before { allow(subject).to receive(:length).and_return(content.length) }
    before do
      allow(subject).to receive(:wordset).and_return(content.split(' ').to_set)
    end

    it 'returns the "other" code of conduct' do
      expect(subject.code_of_conduct).to eql(other)
    end
  end
end
