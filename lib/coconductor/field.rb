module Coconductor
  # Represents a fillable field in a code of conduct
  class Field
    REGEX = /\[(?<name>[A-Z_ ]{2,}):?\s?(?<description>.*)\]/

    # the matchable raw text within the code of conduct including brackets
    attr_reader :raw_text

    class << self
      # Returns an array of Fields for the given code of conduct
      def from_code_of_conduct(code_of_conduct)
        matches = []

        code_of_conduct.content.scan(REGEX) do |_m|
          matches << Regexp.last_match
        end

        fields = matches.map do |m|
          new(m[0], name: m[:name], description: m[:description])
        end

        fields.uniq(&:key)
      end

      # Returns all fields accross all vendored codes of conduct
      def all
        @all ||= CodeOfConduct.latest.map(&:fields).flatten.uniq(&:key)
      end
    end

    def initialize(raw_text, name: nil, description: nil)
      @raw_text = raw_text
      @name = name
      @description = description
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
      @description ||= parts ? parts[:description] : nil
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
        normalized_name = name.tr(' ', '_')
        normalized_name = normalized_name.gsub(/\A(YOUR|INSERT)_/i, '')
        normalized_name = normalized_name.gsub(/_?HERE\z/i, '')
        normalized_name.strip
      end
    end
  end
end
