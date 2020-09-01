# frozen_string_literal: true

module Coconductor
  # Represents a fillable field in a code of conduct
  class Field
    REGEX = /\[(?<name>[A-Z_ ]{2,})[\s:-]*(?<description>.*?)\]/.freeze

    # the matchable raw text within the code of conduct including brackets
    attr_reader :raw_text

    # Hard coded field descriptions in the form of key => description
    DESCRIPTIONS = {
      'link_to_reporting_guidelines' => 'An optional link to guidelines for ' \
        'how reports of unacceptable behavior will be handled.',
      'link_to_policy' => 'An optional link to guidelines for how warnings ' \
        'and expulsions of community members will be handled.'
    }.freeze

    class << self
      # Returns an array of Fields for the given code of conduct
      def from_code_of_conduct(code_of_conduct)
        matches = []
        return [] unless code_of_conduct&.content

        code_of_conduct.content.scan(REGEX) do |_m|
          matches << Regexp.last_match
        end

        fields = matches.map do |m|
          new(m[0], name: m[:name], description: m[:description])
        end

        fields.uniq(&:raw_text)
      end

      # Returns all fields accross all vendored codes of conduct
      def all
        @all ||= CodeOfConduct.latest.map(&:fields).flatten.uniq(&:key)
      end
    end

    def initialize(raw_text, name: nil, description: nil)
      @raw_text = raw_text
      @name = name
      @description = description.capitalize if description && description != ''
    end

    # The unformatted field name as found in the code of conduct text
    def name
      @name ||= parts ? parts[:name].strip : nil
    end

    # human readable label
    def label
      @label ||= normalized_name.downcase.tr('_', ' ').capitalize
    end

    # machine readable key
    def key
      @key ||= normalized_name.downcase
    end

    def description
      @description ||= begin
        return parts[:description].capitalize if parts && parts[:description] && parts[:description] != ''

        DESCRIPTIONS[key]
      end
    end

    def inspect
      methods = %w[name key label]
      kvs = methods.map { |method| [method, public_send(method)] }.to_h
      kvs = kvs.map { |k, v| "#{k}=\"#{v}\"" }.join(' ')
      "<Coconductor::Field #{kvs}>"
    end

    private

    def parts
      @parts ||= raw_text.match(REGEX)
    end

    def normalized_name
      @normalized_name ||= begin
        normalized_name = name.strip.tr(' ', '_')
        normalized_name = normalized_name.gsub(/\A(YOUR|INSERT)_/i, '')
        normalized_name = normalized_name.gsub(/_?HERE\z/i, '')
        normalized_name.strip
      end
    end
  end
end
