# frozen_string_literal: true

module Coconductor
  module Matchers
    class FieldAware < Licensee::Matchers::Exact
      include Coconductor::Matchers::Matcher

      def match
        return @match if defined? @match

        potential_matches.find do |code_of_conduct|
          file.content_normalized =~ regex_for(code_of_conduct)
        end
      end

      def confidence
        100
      end

      private

      FIELD_PLACEHOLDER = 'COCONDUCTOR_FIELD_COCONDUCTOR'
      FIELD_PLACEHOLDER_REGEX = /coconductor\\ field\\ coconductor/.freeze

      def regex_for(code_of_conduct)
        coc = code_of_conduct.dup
        coc.instance_variable_set '@content_normalized', nil
        coc.instance_variable_set '@content_without_title_and_version', nil
        field_regex = /#{Regexp.union(coc.fields.map(&:raw_text))}/i
        coc.content = coc.content.gsub(field_regex, FIELD_PLACEHOLDER)
        regex = Regexp.escape(coc.content_normalized)
        regex = regex.gsub(FIELD_PLACEHOLDER_REGEX, '([a-z ]+?)')
        Regexp.new(regex)
      end
    end
  end
end
