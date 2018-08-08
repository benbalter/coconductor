module Coconductor
  module Projects
    module Project

      DIRS = ['./docs/', './.github/']

      def code_of_conduct
        code_of_conduct_file.code_of_conduct if code_of_conduct_file
      end

      private

      def code_of_conduct_file
        return [] if files.empty? || files.nil?
        content, name = find_file do |n|
          Coconductor::ProjectFiles::CodeOfConductFile.name_score(n)
        end

        return unless content && name
        Coconductor::ProjectFiles::CodeOfConductFile.new(content, name)
      end
    end
  end
end
