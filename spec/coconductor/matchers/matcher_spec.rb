# frozen_string_literal: true

class MatcherSpecHelper
  include Coconductor::Matchers::Matcher
end

RSpec.describe Coconductor::Matchers::Matcher do
  subject { MatcherSpecHelper.new }

  it 'returned potential matches' do
    expect(subject.potential_matches).to eql(Coconductor::CodeOfConduct.all)
  end
end
