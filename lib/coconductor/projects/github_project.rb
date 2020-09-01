# frozen_string_literal: true

autoload :Octokit, 'octokit'

module Coconductor
  module Projects
    class GitHubProject < Licensee::Projects::GitHubProject
      include Coconductor::Projects::Project

      private

      def files
        @files ||= begin
          Coconductor::Projects::Project::DIRS.map { |p| dir_files(p) }.flatten
        end
      end
    end
  end
end
