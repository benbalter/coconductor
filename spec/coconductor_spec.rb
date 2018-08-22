RSpec.describe Coconductor do
  let(:cc_1_4) do
    Coconductor::CodeOfConduct.find('contributor-covenant/version/1/4')
  end
  let(:path) { project_root }

  it 'has a version number' do
    expect(described_class::VERSION).not_to be nil
  end

  it 'returns all codes of conduct' do
    expect(described_class.codes_of_conduct.count).to eql(47)
    expect(described_class.codes_of_conduct).to all(be_a(Coconductor::CodeOfConduct))
  end

  it 'returns the code of conduct for a given path' do
    expect(described_class.code_of_conduct(path)).to eql(cc_1_4)
  end

  it 'returns the project for a given path' do
    project = described_class.project(path)
    expect(project).to be_a(Coconductor::Projects::GitProject)
    expect(project.code_of_conduct).to eql(cc_1_4)
  end

  context '#confidence_threshold' do
    it 'returns the confidence threshold' do
      expect(subject.confidence_threshold).to eql(90)
    end

    context 'user overridden' do
      before { described_class.confidence_threshold = 50 }
      after { described_class.confidence_threshold = nil }

      it 'lets the user override the confidence threshold' do
        expect(described_class.confidence_threshold).to eql(50)
      end
    end
  end
end
