module Coconductor
  module ProjectFiles
    class CodeOfConductFile < Coconductor::ProjectFiles::ProjectFile
      include Licensee::ContentHelper

      PREFERRED_EXT = %w[md markdown txt].freeze
      PREFERRED_EXT_REGEX = /\.#{Regexp.union(PREFERRED_EXT)}/
      BASENAME_REGEX = /(citizen[_-])?code[_-]of[_-]conduct/i
      LANG_REGEX = /(\.(?<lang>[a-z]{2}(-[a-z]{2})?))?/i
      FILENAME_REGEX = /#{BASENAME_REGEX}#{LANG_REGEX}#{PREFERRED_EXT_REGEX}/i

      def self.name_score(filename)
        filename =~ /\A#{FILENAME_REGEX}/ ? 1.0 : 0.0
      end

      def possible_matchers
        [Matchers::Exact, Matchers::Dice] # Matchers::CodeOfConduct]
      end
    end
  end
end
