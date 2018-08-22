RSpec.describe Coconductor::Matchers::FieldAware do
  let(:filename) { 'CODE_OF_CONDUCT.txt' }
  let(:file) do
    Coconductor::ProjectFiles::CodeOfConductFile.new(content, filename)
  end

  Coconductor.codes_of_conduct.each do |code_of_conduct|
    context code_of_conduct.name do
      let(:content) { code_of_conduct.content }

      it 'matches itself' do
        skip '/shrug' if ['fa-ir', 'hi'].include? code_of_conduct.language
        expect(file.match).to eql(code_of_conduct)
      end

      context 'with fields filled in' do
        let(:fields) { Coconductor.codes_of_conduct.map(&:fields).flatten.uniq }
        let(:field_regex) { /\[#{Regexp.union(fields)}\]/i }
        let(:content) do
          code_of_conduct.content.gsub(field_regex, 'foo@example.com')
        end

        it 'still matches itself' do
          excludes = %w[fa-ir hi ja el kn]
          skip '/shrug' if excludes.include? code_of_conduct.language
          expect(file.match).to eql(code_of_conduct)
        end
      end
    end
  end
end
