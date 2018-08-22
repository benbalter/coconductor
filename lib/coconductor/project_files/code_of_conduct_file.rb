module Coconductor
  module ProjectFiles
    class CodeOfConductFile < Coconductor::ProjectFiles::ProjectFile
      include Licensee::ContentHelper

      EXTENSIONS = %w[md markdown txt].freeze
      EXT_REGEX = /\.#{Regexp.union(EXTENSIONS)}/i
      BASENAME_REGEX = /(citizen[_-])?code[_-]of[_-]conduct/i
      # LANG_REGEX must contain extension to avoid matching .md as the lang
      LANG_REGEX = /(\.(?<lang>[a-z]{2}(-[a-z]{2})?)#{EXT_REGEX})?/i
      FILENAME_REGEX = /#{BASENAME_REGEX}#{LANG_REGEX}#{EXT_REGEX}?/i

      def self.name_score(filename)
        filename =~ /\A#{FILENAME_REGEX}/ ? 1.0 : 0.0
      end

      def possible_matchers
        [Matchers::Exact, Matchers::Dice] # Matchers::CodeOfConduct]
      end
    end
  end
end
