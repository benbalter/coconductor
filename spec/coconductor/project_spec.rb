[
  Coconductor::Projects::FSProject,
  Coconductor::Projects::GitProject
].each do |project_type|
  RSpec.describe project_type do
    context "a #{project_type} project" do
      let(:path) { fixture_path(fixture) }
      let(:cc_1_4) do
        Coconductor::CodeOfConduct.find('contributor-covenant/version/1/4')
      end

      subject { described_class.new(path) }

      if described_class == Coconductor::Projects::GitProject
        before { git_init(path) }

        after do
          subject.close
          FileUtils.rm_rf File.expand_path '.git', path
        end
      end

      context 'root' do
        let(:fixture) { 'contributor-covenant-1-4' }

        it 'returns the code of conduct' do
          expect(subject.code_of_conduct).to eql(cc_1_4)
        end

        it 'returns the code of conduct file' do
          file = subject.code_of_conduct_file
          expect(file).to be_a(Coconductor::ProjectFiles::CodeOfConductFile)
          expect(file.filename).to eql("CODE_OF_CONDUCT.txt")
        end
      end
    end
  end
end
