require 'toml'

module Coconductor
  class InvalidCodeOfConduct < ArgumentError; end
  class CodeOfConduct
    VENDORED_CODES_OF_CONDUCT = %w[
      citizen-code-of-conduct
      contributor-covenant
    ].freeze

    class << self
      def all
        @all ||= keys.map { |key| new(key) }
      end

      def find(key)
        all.find { |coc| coc.key == key }
      end
      alias [] find
      alias find_by_key find

      def vendor_dir
        @vendor_dir ||= File.expand_path '../../vendor', __dir__
      end

      def keys
        @keys ||= vendored_codes_of_conduct.map do |path|
          if File.dirname(path).end_with? 'citizen-code-of-conduct'
            'citizen-code-of-conduct'
          else
            path.gsub!(%r{#{Regexp.escape(vendor_dir)}/}, '')
            path.gsub!('code-of-conduct.', '')
            path.gsub(%r{/?\.?md$}, '')
          end
        end
      end

      private

      def vendored_codes_of_conduct
        @vendored_codes_of_conduct ||= begin
          cocs = "{#{VENDORED_CODES_OF_CONDUCT.join(',')}}"
          path = File.join vendor_dir, cocs, '**', '*.md'
          Dir.glob(path)
        end
      end
    end

    attr_reader :key
    include Licensee::ContentHelper

    def initialize(key)
      @key = key
    end

    def version
      toml['version']
    end

    def language
      @language ||= begin
        parts = key.split('/')
        parts.last if parts.last =~ /^[a-z-]{2,5}$/
      end
    end

    def name
      return @name if defined? @name
      @name = name_without_version.dup
      @name << " (#{language.upcase})" if language
      @name << " v#{version}" if version
      @name
    end

    def name_without_version
      @name_without_version ||= begin
        key.split('/').first.split('-').map(&:capitalize).join(' ')
      end
    end

    def content
      parts.last
    end

    def inspect
      "#<Licensee::CodeOfConduct key=#{key}>"
    end

    def contributor_covenant?
      key.start_with? 'contributor-covenant'
    end

    def citizen_code_of_conduct?
      key.start_with? 'citizen-code-of-conduct'
    end

    private

    def path
      if contributor_covenant?
        filename = 'code-of-conduct'
      elsif citizen_code_of_conduct?
        filename = 'citizen_code_of_conduct'
      end

      parts = key.split('/')
      filename << '.' + parts.pop if language
      parts.pop if citizen_code_of_conduct?

      filename << '.md'
      path = File.join(*parts[0...5], filename)
      File.expand_path path, self.class.vendor_dir
    end

    # Raw content of code of conduct file, including TOML front matter
    def raw_content
      unless File.exist?(path)
        msg = "'#{key}' is not a valid code of conduct key"
        raise Licensee::InvalidCodeOfConduct, msg
      end
      @raw_content ||= File.read(path, encoding: 'utf-8')
    end

    def toml
      @toml ||= begin
        if parts.length == 3
          TOML::Parser.new(parts[1]).parsed
        else
          {}
        end
      end
    end

    def parts
      @parts ||= raw_content.split('+++')
    end
  end
end
