# frozen_string_literal: true

module Coconductor
  module Matchers
    class Exact < Licensee::Matchers::Exact
      include Coconductor::Matchers::Matcher
    end
  end
end
