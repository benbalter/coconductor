RSpec.describe 'integration test' do
  [
    Coconductor::Projects::FSProject,
    Coconductor::Projects::GitProject,
    Coconductor::Projects::GitHubProject
  ].each do |project_type|
    context "with a #{project_type} project" do
      let(:user) { '_coconductor_test_fixture' }
      let(:filename) { 'CODE_OF_CONDUCT.txt' }
      let(:project_path) { fixture_path(fixture) }
      let(:git_path) { File.expand_path('.git', project_path) }
      let(:arguments) { {} }
      let(:cc_1_4) do
        Coconductor::CodeOfConduct.find('contributor-covenant/version/1/4')
      end
      let(:other) { Coconductor::CodeOfConduct.find('other') }

      subject { project_type.new(project_path, arguments) }

      context 'fixtures' do
        if project_type == Coconductor::Projects::GitProject
          before { git_init(project_path) }
          after { FileUtils.rm_rf(git_path) }
        elsif project_type == Coconductor::Projects::GitHubProject
          let(:project_path) { "https://github.com/#{user}/#{fixture}" }
          before { webmock_fixtures }
        end

        context 'contributor covenant 1.4' do
          let(:fixture) { 'contributor-covenant-1-4' }

          it 'matches' do
            expect(subject.code_of_conduct).to eql(cc_1_4)
          end
        end

        context 'no code of conduct' do
          let(:fixture) { 'no-coc' }

          it 'matches' do
            expect(subject.code_of_conduct).to be_nil
          end
        end

        context '.github folder' do
          let(:fixture) { 'dot-github-folder' }

          it 'matches' do
            expect(subject.code_of_conduct).to eql(cc_1_4)
          end
        end

        context 'docs folder' do
          let(:fixture) { 'docs-folder' }

          it 'matches' do
            expect(subject.code_of_conduct).to eql(cc_1_4)
          end
        end

        context 'An unknown code of conduct' do
          let(:fixture) { 'other' }

          it 'returns other' do
            expect(subject.code_of_conduct).to eql(other)
          end
        end
      end
    end
  end
end
