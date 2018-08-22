require 'coconductor/version'
require 'licensee'
require 'pathname'

module Coconductor
  autoload :CodeOfConduct, 'coconductor/code_of_conduct'
  autoload :Matchers,      'coconductor/matchers'
  autoload :Projects,      'coconductor/projects'
  autoload :ProjectFiles,  'coconductor/project_files'

  CONFIDENCE_THRESHOLD = 90

  class << self
    attr_writer :confidence_threshold

    def codes_of_conduct
      CodeOfConduct.all
    end

    def code_of_conduct(path)
      Coconductor.project(path).code_of_conduct
    end

    def project(path, **args)
      Coconductor::Projects::GitProject.new(path, args)
    rescue Coconductor::Projects::GitProject::InvalidRepository
      Coconductor::Projects::FSProject.new(path, args)
    end

    def confidence_threshold
      @confidence_threshold ||= CONFIDENCE_THRESHOLD
    end
  end
end
