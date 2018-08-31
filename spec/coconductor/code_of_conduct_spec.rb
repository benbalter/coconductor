RSpec.describe Coconductor::CodeOfConduct do
  let(:code_of_conduct_count) { 48 }

  context 'class methods' do
    it 'loads all codes of conduct' do
      expect(described_class.all.count).to eql(code_of_conduct_count)
      expect(described_class.all).to all(be_a(described_class))
    end

    context 'find' do
      %w[
        citizen-code-of-conduct/version/2/3
        contributor-covenant/version/1/3/0
        contributor-covenant/version/1/3/0/de
        contributor-covenant/version/1/4
        contributor-covenant/version/1/4/es
      ].each do |key|
        context key do
          it 'returns the requested code of conduct' do
            found = described_class.find(key)
            expect(found).to be_a(described_class)
            expect(found.key).to eql(key)
          end
        end
      end

      it 'returns the latest in the family' do
        found = described_class.find('contributor-covenant')
        expect(found).to be_a(described_class)
        expect(found.family).to eql('contributor-covenant')
        expect(found.version).to eql('1.4')
      end
    end

    it 'returns the latest in a given family' do
      found = described_class.latest_in_family('citizen-code-of-conduct')
      expect(found).to be_a(described_class)
      expect(found.family).to eql('citizen-code-of-conduct')
      expect(found.version).to eql('2.3')
    end

    it 'returns families' do
      expected = %w[
        no-code-of-conduct
        citizen-code-of-conduct
        contributor-covenant
      ]
      expect(described_class.families).to eql(expected)
    end

    it 'returns the latest in each family' do
      expected = %w[
        no-code-of-conduct/version/1/0
        citizen-code-of-conduct/version/2/3
        contributor-covenant/version/1/4
      ]
      expect(described_class.latest.map(&:key)).to eql(expected)
    end

    it 'returns keys' do
      expect(described_class.keys.count).to eql(code_of_conduct_count)
    end

    it 'returns the vendor dir' do
      expected = File.expand_path '../../vendor', __dir__
      expect(described_class.vendor_dir.to_path).to eql(expected)
    end
  end

  it 'knows a contributor covenant' do
    coc = described_class.find('contributor-covenant/version/1/4')
    expect(coc).to be_contributor_covenant
    expect(coc).to_not be_citizen_code_of_conduct
    expect(coc).to_not be_no_code_of_conduct
  end

  it 'knows a contributor covenant' do
    coc = described_class.find('citizen-code-of-conduct/version/2/3')
    expect(coc).to be_citizen_code_of_conduct
    expect(coc).to_not be_contributor_covenant
    expect(coc).to_not be_no_code_of_conduct
  end

  it 'knows a no code of conduct' do
    coc = described_class.find('no-code-of-conduct/version/1/0')
    expect(coc).to be_no_code_of_conduct
    expect(coc).to_not be_citizen_code_of_conduct
    expect(coc).to_not be_contributor_covenant
  end

  Coconductor::CodeOfConduct.all.each do |coc|
    context coc.name do
      subject { coc }

      it 'returns the version' do
        expect(subject.version).to match(/\d\.\d/)
      end

      if coc.key.start_with? 'contributor-covenant'
        it 'returns the language' do
          unless subject.key.split('/').last =~ /\d/
            expect(subject.language).to match(/[a-z-]{2,5}/)
          end
        end
      end

      it 'returns the name without version' do
        expect(subject.name_without_version).to match(/^[a-z ]+$/i)
      end

      it 'returns the name' do
        expect(subject.name).to match(/^[a-z ]+(\([a-z-]+\))?( v\d\.\d)?$/i)
      end

      it 'returns the content' do
        expect(subject.content).to be_a(String)
      end

      it 'returns the normalized content' do
        expect(subject.content_normalized).to be_a(String)
      end

      it 'returns the family' do
        families = described_class.families
        expect(families).to include(subject.family)
      end
    end
  end
end
