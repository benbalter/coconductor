# frozen_string_literal: true

require 'toml'

module Coconductor
  class InvalidCodeOfConduct < ArgumentError; end

  class CodeOfConduct
    class << self
      def all
        @all ||= keys.map { |key| new(key) }
      end

      def latest
        @latest ||= families.map { |family| find(family) }
      end

      # Returns the code of conduct specified by the key with version,
      # or the latest in the family if only the family is specified
      def find(key_or_family)
        return new(key_or_family) if new(key_or_family).pseudo?

        match = all.find { |coc| coc.key == key_or_family }
        match || latest_in_family(key_or_family)
      end
      alias [] find
      alias find_by_key find

      def vendor_dir
        @vendor_dir ||= Pathname.new File.expand_path '../../vendor', __dir__
      end

      def keys
        @keys ||= vendored_codes_of_conduct.map do |path|
          path = Pathname.new(path)
          key = path.relative_path_from(vendor_dir)
          matches = KEY_REGEX.match(key.to_path)
          next unless matches

          [
            matches['family'], 'version', matches['version'], matches['lang']
          ].compact.join('/')
        end.compact.sort
      end

      def latest_in_family(family, language: DEFAULT_LANGUAGE)
        cocs = all.select do |coc|
          coc.language == language && coc.family == family
        end
        cocs.max_by { |c| c.geek_feminism? ? !c.version : c.version }
      end

      def families
        @families ||= begin
          families = Dir["#{vendor_dir}/*"].map { |dir| File.basename(dir) }
          (families - ['bundle']).sort
        end
      end

      private

      def vendored_codes_of_conduct
        @vendored_codes_of_conduct ||= begin
          cocs = "{#{families.join(',')}}"
          path = File.join vendor_dir, cocs, '**', '*.md'
          Dir.glob(path)
        end
      end
    end

    KEY_REGEX = %r{
      (?<family>#{Regexp.union(CodeOfConduct.families)})
      /version
      /(?<version>(?<major>\d)/(?<minor>\d)(/(?<patch>\d))?|(longer|shorter))
      /#{Coconductor::ProjectFiles::CodeOfConductFile::FILENAME_REGEX}
    }ix.freeze
    DEFAULT_LANGUAGE = 'en'

    attr_reader :key
    attr_writer :content

    include Licensee::ContentHelper

    # Define dynamic predicate helpers to determine if a code of conduct is a
    # member of a given family, e.g., code_of_conduct.contributor_covenant?
    CodeOfConduct.families.each do |f|
      define_method("#{f.tr('-', '_')}?") { family == f }
    end

    def initialize(key)
      @key = key
    end

    def version
      toml['version']
    end

    def language
      @language ||= begin
        parts = key.split('/')
        if pseudo?
          nil
        elsif /^[a-z-]{2,5}$/.match?(parts.last)
          parts.last
        else
          DEFAULT_LANGUAGE
        end
      end
    end

    def name
      return @name if defined? @name

      @name = name_without_version.dup
      @name << " (#{language.upcase})" unless default_language?
      @name << " v#{version}" if version
      @name
    end

    def name_without_version
      @name_without_version ||= begin
        key.split('/').first.split('-').map(&:capitalize).join(' ')
      end
    end

    def content
      # See https://github.com/stumpsyn/policies/pull/21
      @content ||= if parts.nil?
                     nil
                   else
                     parts.last
                   end
    end
    alias body content

    def inspect
      "#<Coconductor::CodeOfConduct key=#{key}>"
    end

    def family
      @family ||= key.split('/').first unless none?
    end

    # The "other" code of conduct represents an unidentifiable code of conduct
    def other?
      key == 'other'
    end

    # The "none" code of conduct represents the lack of a code of conduct
    def none?
      key == 'none'
    end

    # Code of conduct is an pseudo code of conduct (e.g., none, other)
    def pseudo?
      other? || none?
    end

    # Returns all fields found in the code of conduct
    #
    # Each field will have a unique _raw_text_, uniq-ing _identical_ fields
    def fields
      @fields ||= Field.from_code_of_conduct(self)
    end

    # Returns all fields found in the code of conduct, uniq'd by normalized key
    #
    # Where the same field exists twice, preferance will be given to the first
    # occurance to contain a description
    def unique_fields
      @unique_fields ||= begin
        fields.sort_by { |f| f.description ? 0 : 1 }.uniq(&:key)
      end
    end

    def ==(other)
      other.is_a?(CodeOfConduct) && key == other.key
    end
    alias eql? ==

    private

    def filename
      filename = if contributor_covenant? && key.include?('/version/1/')
                   'code-of-conduct'
                 elsif contributor_covenant? && key.include?('/version/2/')
                   'code_of_conduct'
                 elsif citizen_code_of_conduct?
                   'citizen_code_of_conduct'
                 else
                   'CODE_OF_CONDUCT'
                 end

      filename += ".#{language}" unless default_language?
      "#{filename}.md"
    end

    def filepath
      return @filepath if defined? @filepath

      parts = key.split('/')
      parts.pop unless default_language?
      path = File.join(*parts[0...5], filename)
      path = File.expand_path path, self.class.vendor_dir
      @filepath = Pathname.new(path)
    end

    # Raw content of code of conduct file, including TOML front matter
    def raw_content
      return if pseudo?

      unless File.exist?(filepath)
        msg = "'#{key}' is not a valid code of conduct key"
        raise Coconductor::InvalidCodeOfConduct, msg
      end
      @raw_content ||= File.read(filepath, encoding: 'utf-8')
    end

    def toml
      @toml ||= begin
        if parts && parts.length == 3
          TOML::Parser.new(parts[1]).parsed
        else
          {}
        end
      end
    end

    def parts
      @parts ||= raw_content.split('+++').map(&:strip) if raw_content
    end

    def default_language?
      pseudo? || language == DEFAULT_LANGUAGE
    end
  end
end
