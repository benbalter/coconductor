module Coconductor
  module Projects
    module Project
      DIRS = ['./docs/', './.github/'].freeze

      def code_of_conduct
        code_of_conduct_file.code_of_conduct if code_of_conduct_file
      end

      def code_of_conduct_file
        return if files.nil? || files.empty?
        file = find_files do |filename|
          ProjectFiles::CodeOfConductFile.name_score(filename)
        end.first

        return unless file

        content = load_file(file)
        ProjectFiles::CodeOfConductFile.new(content, file)
      end

      private

      def path_relative_to_root(path)
        return path if is_a?(GitProject) || path.nil?

        root = Pathname.new(@dir)
        path = Pathname.new(path)
        path.relative_path_from(root).to_s
      end
    end
  end
end
