# frozen_string_literal: true

[
  Coconductor::Projects::FSProject,
  Coconductor::Projects::GitProject,
  Coconductor::Projects::GitHubProject
].each do |project_type|
  RSpec.describe project_type do
    let(:user) { '_coconductor_test_fixture' }

    context "a #{project_type} project" do
      subject { described_class.new(path) }

      let(:path) { fixture_path(fixture) }
      let(:cc_1_4) do
        Coconductor::CodeOfConduct.find('contributor-covenant/version/1/4')
      end

      if described_class == Coconductor::Projects::GitProject
        before { git_init(path) }

        after do
          subject.close
          FileUtils.rm_rf File.expand_path '.git', path
        end
      elsif described_class == Coconductor::Projects::GitHubProject
        let(:path) { "https://github.com/#{user}/#{fixture}" }
        before { webmock_fixtures }
      end

      context 'root' do
        let(:fixture) { 'contributor-covenant-1-4' }

        it 'returns the code of conduct' do
          expect(subject.code_of_conduct).to eql(cc_1_4)
        end

        it 'returns the code of conduct file' do
          file = subject.code_of_conduct_file
          expect(file).to be_a(Coconductor::ProjectFiles::CodeOfConductFile)
          expect(file.filename).to eql('CODE_OF_CONDUCT.txt')
          expect(file.directory).to eql('.')
        end
      end

      context 'docs folder' do
        let(:fixture) { 'docs-folder' }

        it 'returns the code of conduct' do
          expect(subject.code_of_conduct).to eql(cc_1_4)
        end

        it 'returns the code of conduct file' do
          file = subject.code_of_conduct_file
          expect(file).to be_a(Coconductor::ProjectFiles::CodeOfConductFile)
          expect(file.filename).to eql('CODE_OF_CONDUCT.txt')
          expect(file.directory).to eql('docs')
        end
      end

      describe '.github folder' do
        let(:fixture) { 'dot-github-folder' }

        it 'returns the code of conduct' do
          expect(subject.code_of_conduct).to eql(cc_1_4)
        end

        it 'returns the code of conduct file' do
          file = subject.code_of_conduct_file
          expect(file).to be_a(Coconductor::ProjectFiles::CodeOfConductFile)
          expect(file.filename).to eql('CODE_OF_CONDUCT.txt')
          expect(file.directory).to eql('.github')
        end
      end
    end
  end
end
