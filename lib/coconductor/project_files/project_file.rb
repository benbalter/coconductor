module Coconductor
  module ProjectFiles
    class ProjectFile < Licensee::ProjectFiles::ProjectFile
      def initialize(content, metadata = {})
        @dir = metadata[:dir] if metadata.is_a?(Hash)
        super
      end

      def code_of_conduct
        matcher && matcher.match
      end

      def directory
        @dir || '.'
      end
      alias dir directory

      def path
        File.join(directory, filename)
      end

      undef_method :license
      undef_method :matched_license
      undef_method :copyright?
    end
  end
end
