RSpec.describe 'Vendored codes of conduct' do
  let(:filename) { 'CODE_OF_CONDUCT.txt' }
  let(:code_of_conduct_file) do
    Coconductor::ProjectFiles::CodeOfConductFile.new(content, filename)
  end

  Coconductor::CodeOfConduct.all.each do |code_of_conduct|
    context "the #{code_of_conduct.name}" do
      let(:content) { code_of_conduct.content }

      it 'detects the code of conduct' do
        skip '/shrug' if code_of_conduct.language == 'fa-ir'
        expect(code_of_conduct_file.code_of_conduct).to eql(code_of_conduct)
      end
    end
  end
end
