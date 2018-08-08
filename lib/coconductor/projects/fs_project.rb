module Coconductor
  module Projects
    class FSProject < Licensee::Projects::FSProject

      include Coconductor::Projects::Project

      private

      # Returns an array of hashes representing the project's files.
      # Hashes will have the the following keys:
      #  :name - the relative file name
      #  :dir  - the directory path containing the file
      def files
        @files ||= search_directories.flat_map do |dir|
          Dir.glob(::File.join(dir, @pattern).tr('\\', '/')).map do |file|
            next unless ::File.file?(file)
            { name: ::File.basename(file), dir: dir }
          end.compact
        end
      end

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
