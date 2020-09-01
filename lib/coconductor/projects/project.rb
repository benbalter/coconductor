# frozen_string_literal: true

module Coconductor
  module Projects
    module Project
      DIRS = ['./', './docs/', './.github/'].freeze

      def code_of_conduct
        code_of_conduct_file&.code_of_conduct
      end

      def code_of_conduct_file
        return @code_of_conduct_file if defined? @code_of_conduct_file
        return if files.nil? || files.empty?

        file = find_files do |filename|
          ProjectFiles::CodeOfConductFile.name_score(filename)
        end.first

        return unless file

        content = load_file(file)
        @code_of_conduct_file = begin
          ProjectFiles::CodeOfConductFile.new(content, file)
        end
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
