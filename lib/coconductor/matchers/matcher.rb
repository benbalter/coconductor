# frozen_string_literal: true

module Coconductor
  module Matchers
    module Matcher
      def potential_matches
        @potential_matches ||= CodeOfConduct.all
      end
    end
  end
end
