# frozen_string_literal: true

module Coconductor
  module Matchers
    autoload :Dice,       'coconductor/matchers/dice'
    autoload :Exact,      'coconductor/matchers/exact'
    autoload :FieldAware, 'coconductor/matchers/field_aware'
    autoload :Matcher,    'coconductor/matchers/matcher'
  end
end
