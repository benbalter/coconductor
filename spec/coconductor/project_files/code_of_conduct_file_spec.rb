RSpec.describe Coconductor::ProjectFiles::CodeOfConductFile do
  let(:filename) { 'CODE_OF_CONDUCT.txt' }
  let(:cc_1_4) do
    Coconductor::CodeOfConduct.find('contributor-covenant/version/1/4')
  end
  let(:content) { cc_1_4.content }

  subject { described_class.new(content, filename) }

  context 'filenames' do
    [
      'CODE_OF_CONDUCT',
      'CODE-OF-CONDUCT',
      'CODE_OF_CONDUCT.md',
      'CODE_OF_CONDUCT.TXT',
      'CODE_OF_CONDUCT.Markdown',
      'CITIZEN_CODE_OF_CONDUCT',
      'CITIZEN-CODE-OF-CONDUCT.md'
    ].each do |filename|
      context "a #{filename} file" do
        it 'matches' do
          expect(described_class.name_score(filename)).to eql(1.0)
        end
      end
    end

    context 'vendored codes of context' do
      Dir["#{project_root}/vendor/*/**/*.md"].each do |path|
        context File.basename(path).to_s do
          let(:filename) { File.basename(path) }

          it 'matches' do
            expect(described_class.name_score(filename)).to eql(1.0)
          end
        end
      end
    end
  end
end
