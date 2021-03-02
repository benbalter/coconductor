# frozen_string_literal: true

require_relative './coconductor/version'
require 'licensee'

module Coconductor
  autoload :CodeOfConduct, 'coconductor/code_of_conduct'
  autoload :Field,         'coconductor/field'
  autoload :Matchers,      'coconductor/matchers'
  autoload :Projects,      'coconductor/projects'
  autoload :ProjectFiles,  'coconductor/project_files'
  autoload :Vendorer,      'coconductor/vendorer'

  CONFIDENCE_THRESHOLD = 85

  class << self
    attr_writer :confidence_threshold

    def codes_of_conduct
      CodeOfConduct.all
    end

    def code_of_conduct(path)
      Coconductor.project(path).code_of_conduct
    end

    def project(path, **args)
      if %r{\Ahttps://github.com}.match?(path)
        Coconductor::Projects::GitHubProject.new(path, **args)
      else
        Coconductor::Projects::GitProject.new(path, **args)
      end
    rescue Coconductor::Projects::GitProject::InvalidRepository
      Coconductor::Projects::FSProject.new(path, **args)
    end

    def confidence_threshold
      @confidence_threshold ||= CONFIDENCE_THRESHOLD
    end
  end
end
