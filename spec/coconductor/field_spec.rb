RSpec.describe Coconductor::Field do
  let(:all_field_count) { 9 }
  let(:cc_field_cound) { 1 }
  let(:name) { 'SOME_FIELD' }
  let(:description) { 'Some description.' }
  let(:raw_text) { "[#{name}: #{description}]" }
  subject { described_class.new(raw_text) }

  context 'class methods' do
    it 'returns all fields' do
      expect(described_class.all).to all(be_a(described_class))
      expect(described_class.all.count).to eql(all_field_count)
    end

    context 'from a code of conduct' do
      let(:family) { 'contributor-covenant' }
      let(:coc) { Coconductor::CodeOfConduct.find(family) }
      let(:fields) { described_class.from_code_of_conduct(coc) }

      it 'pulls from a code of conduct' do
        expect(fields).to all(be_a(described_class))
        expect(fields.count).to eql(cc_field_cound)
      end
    end
  end

  it 'stores the raw text' do
    expect(subject.raw_text).to eql(raw_text)
  end

  it 'returns the name' do
    expect(subject.name).to eql(name)
  end

  context 'when passed a name' do
    subject { described_class.new(raw_text, name: 'ANOTHER_NAME') }

    it 'store the name' do
      expect(subject.name).to eql('ANOTHER_NAME')
    end
  end

  context 'when passed a description' do
    subject { described_class.new(raw_text, description: 'description...') }

    it 'store the name' do
      expect(subject.description).to eql('description...')
    end
  end

  it 'returns the label' do
    expect(subject.label).to eql('Some field')
  end

  it 'returns the key' do
    expect(subject.key).to eql('some_field')
  end

  it 'returns the description' do
    expect(subject.description).to eql('Some description.')
  end

  context 'a hard-coded description' do
    let(:raw_text) { '[LINK_TO_POLICY]' }

    it 'returns the description' do
      expected = /how warnings and expulsions of community members will be/
      expect(subject.description).to match(expected)
    end
  end

  context 'normalizing' do
    examples = {
      '[SOME FIELD]' => {
        name: 'SOME FIELD', label: 'Some field',
        key: 'some_field', description: nil
      },
      '[SOME_FIELD]' => {
        name: 'SOME_FIELD', label: 'Some field',
        key: 'some_field', description: nil
      },
      '[SOME_FIELD: description]' => {
        name: 'SOME_FIELD', label: 'Some field',
        key: 'some_field', description: 'description'
      },
      '[SOME FIELD description]' => {
        name: 'SOME FIELD', label: 'Some field',
        key: 'some_field', description: 'description'
      },
      '[YOUR CONTACT INFO]' => {
        name: 'YOUR CONTACT INFO', label: 'Contact info',
        key: 'contact_info', description: nil
      },
      '[INSERT_CONTACT_INFO]' => {
        name: 'INSERT_CONTACT_INFO', label: 'Contact info',
        key: 'contact_info', description: nil
      },
      '[YOUR CONTACT INFO HERE]' => {
        name: 'YOUR CONTACT INFO HERE', label: 'Contact info',
        key: 'contact_info', description: nil
      },
      '[INSERT_CONTACT_INFO_HERE]' => {
        name: 'INSERT_CONTACT_INFO_HERE', label: 'Contact info',
        key: 'contact_info', description: nil
      },
      '[FIELD -- description]' => {
        name: 'FIELD', label: 'Field',
        key: 'field', description: 'description'
      }
    }

    examples.each do |raw_text, expectations|
      context "When given '#{raw_text}'" do
        let(:raw_text) { raw_text }

        %i[name label key description].each do |method|
          it "normalized the #{method}" do
            expect(subject.public_send(method)).to eql(expectations[method])
          end
        end
      end
    end
  end
end
