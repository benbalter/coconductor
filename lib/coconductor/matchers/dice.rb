module Coconductor
  module Matchers
    class Dice < Licensee::Matchers::Dice
      def potential_matches
        CodeOfConduct.all
      end
    end
  end
end
