module Coconductor
  module Matchers
    class Exact < Licensee::Matchers::Exact
      def potential_matches
        CodeOfConduct.all
      end
    end
  end
end
