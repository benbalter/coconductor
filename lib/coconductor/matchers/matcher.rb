module Coconductor
  class Matchers < Licensee::Matchers::Matcher
    private

    def potential_matches
      @potential_matches ||= CodeOfConduct.all
    end
  end
end
