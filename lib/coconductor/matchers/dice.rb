module Coconductor
  module Matchers
    class Dice < Licensee::Matchers::Dice
      include Coconductor::Matchers::Matcher
    end
  end
end
