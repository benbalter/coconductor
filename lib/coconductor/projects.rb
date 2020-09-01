# frozen_string_literal: true

module Coconductor
  module Projects
    autoload :Project, 'coconductor/projects/project'
    autoload :FSProject, 'coconductor/projects/fs_project'
    autoload :GitProject, 'coconductor/projects/git_project'
    autoload :GitHubProject, 'coconductor/projects/github_project'
  end
end
