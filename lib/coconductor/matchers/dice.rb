module Coconductor
  module Matchers
    class Dice < Licensee::Matchers::Dice
      include Coconductor::Matchers::Matcher

      undef_method :licenses_by_similarity
      undef_method :potential_licenses
    end
  end
end
