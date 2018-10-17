require 'fileutils'
require 'open-uri'
require 'toml'
require 'reverse_markdown'
require 'logger'

# Used in development to vendor codes of conduct
module Coconductor
  class Vendorer
    attr_reader :family, :repo
    attr_writer :ref, :raw_content

    OPTIONS = %i[filename url repo replacements html source_path].freeze
    INVALID_CHARS = ["\u202D", "\u202C", "\u200E", "\u200F"].freeze
    UPPERCASE_WORD_REGEX = /(?:[A-Z]{3,}+ ?)+[A-Z_]+/
    UNMARKED_FIELD_REGEX = /(?<= |^)#{UPPERCASE_WORD_REGEX}(?= |\.|,)/

    def initialize(family, options = {})
      @family = family

      OPTIONS.each do |option|
        instance_variable_set("@#{option}", options[option])
      end

      logger.info "Vendoring #{family}"

    #  mkdir
    end

    def dir
      @dir ||= File.expand_path family, vendor_dir
    end

    def filename
      @filename ||= 'CODE_OF_CONDUCT.md'
    end

    def source_path
      @source_path ||= filename
    end

    def content
      content_normalized
    end

    def url
      @url || "https://github.com/#{repo}/raw/#{ref}/#{source_path}"
    end

    def vendor(version: '1.0')
      write_with_meta(content, version: version)
    end

    def ref
      @ref ||= 'master'
    end

    def replacements
      @replacements ||= {}
    end

    def write_with_meta(content, version: '1.0')
      content = content_with_meta(content, 'version' => version)
      write(filepath(version), content)
    end

    private

    def logger
      @logger ||= Logger.new(STDOUT)
    end

    def vendor_dir
      @vendor_dir ||= File.expand_path '../../vendor', __dir__
    end

    def filepath(version = '1.0')
      File.join(dir, 'version', *version.split('.'), filename)
    end

    def content_with_meta(content, meta)
      toml = TOML::Generator.new(meta).body.strip
      ['+++', toml, '+++', '', content].join("\n")
    end

    def mkdir
      FileUtils.rm_rf(dir)
      FileUtils.mkdir_p(dir)
    end

    def write(path, content)
      logger.info "Writing #{path}"
      FileUtils.mkdir_p File.dirname(path)
      File.write(path, content)
    end

    def raw_content
      return @raw_content if defined? @raw_content
      logger.info "Retrieving #{url}"
      @raw_content = URI.open(url).read if url
    end

    def content_normalized
      content = raw_content.dup.gsub(Regexp.union(INVALID_CHARS), '')
      content = ReverseMarkdown.convert content if html?
      replacements.each { |from, to| content.gsub!(from, to) }
      content = normalize_implicit_fields(content)
      content.gsub!(/ ?{% .* %} ?/, '')
      content.squeeze(' ').strip
    end

    def normalize_implicit_fields(content)
      content.gsub!(/#{UPPERCASE_WORD_REGEX} #{UPPERCASE_WORD_REGEX}/) do |m|
        m.tr(' ', '_')
      end
      content.gsub(UNMARKED_FIELD_REGEX) { |m| "[#{m}]" }
    end

    def html?
      @html == true
    end
  end
end
