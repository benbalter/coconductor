# frozen_string_literal: true

module Coconductor
  module ProjectFiles
    class CodeOfConductFile < Coconductor::ProjectFiles::ProjectFile
      include Licensee::ContentHelper

      EXTENSIONS = %w[md markdown txt].freeze
      EXT_REGEX = /\.#{Regexp.union(EXTENSIONS)}/i.freeze
      BASENAME_REGEX = /(citizen[_-])?code[_-]of[_-]conduct/i.freeze
      # LANG_REGEX must contain extension to avoid matching .md as the lang
      LANG_REGEX = /(\.(?<lang>[a-z]{2}(-[a-z]{2})?)#{EXT_REGEX})?/i.freeze
      FILENAME_REGEX = /#{BASENAME_REGEX}#{LANG_REGEX}#{EXT_REGEX}?/i.freeze

      def self.name_score(filename)
        /\A#{FILENAME_REGEX}/o.match?(filename) ? 1.0 : 0.0
      end

      def possible_matchers
        [Matchers::Exact, Matchers::Dice, Matchers::FieldAware]
      end
    end
  end
end
