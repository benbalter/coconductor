module Coconductor
  module Projects
    class GitProject < Licensee::Projects::GitProject
      include Coconductor::Projects::Project

      private

      # Returns an array of hashes representing the project's files.
      # Hashes will have the the following keys:
      #  :name - the file's path relative to the repo root
      #  :oid  - the file's OID
      def files
        return @files if defined? @files
        @files = files_from_tree(commit.tree)

        commit.tree.each_tree do |tree|
          next unless subdir?(tree)
          tree = Rugged::Tree.lookup(@repository, tree[:oid])
          @files.concat files_from_tree(tree) if tree
        end

        @files
      end

      def files_from_tree(tree)
        tree.select { |e| e[:type] == :blob }.map do |entry|
          { name: entry[:name], oid: entry[:oid] }
        end.compact
      end

      def subdir?(tree)
        Coconductor::Projects::Project::DIRS.include? "./#{tree[:name]}/"
      end
    end
  end
end
