# frozen_string_literal: true

module Coconductor
  module ProjectFiles
    class ProjectFile < Licensee::ProjectFiles::ProjectFile
      def code_of_conduct
        if matcher
          matcher.match
        else
          CodeOfConduct.find('other')
        end
      end

      undef_method :license
      undef_method :matched_license
      undef_method :copyright?
    end
  end
end
