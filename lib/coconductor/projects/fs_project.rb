# frozen_string_literal: true

module Coconductor
  module Projects
    class FSProject < Licensee::Projects::FSProject
      include Coconductor::Projects::Project

      private

      # Returns the set of unique paths to search for project files
      # in order from @dir -> @root
      def search_directories
        search_enumerator.map(&:to_path)
                         .push(@root) # ensure root is included in the search
                         .concat(subdirs)
                         .uniq # don't include the root twice if @dir == @root
      end

      def subdirs
        Coconductor::Projects::Project::DIRS.map do |dir|
          File.expand_path dir, @dir
        end
      end
    end
  end
end
