# frozen_string_literal: true

module Coconductor
  module Matchers
    class Dice < Licensee::Matchers::Dice
      include Coconductor::Matchers::Matcher

      undef_method :licenses_by_similarity
      undef_method :potential_licenses

      private

      def minimum_confidence
        Coconductor.confidence_threshold
      end
    end
  end
end
