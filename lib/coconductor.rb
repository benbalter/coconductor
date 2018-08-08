require 'coconductor/version'
require 'licensee'

module Coconductor
  autoload :CodeOfConduct, 'coconductor/code_of_conduct'
  autoload :Matchers,      'coconductor/matchers'
  autoload :Projects,      'coconductor/projects'
  autoload :ProjectFiles,  'coconductor/project_files'

  CONFIDENCE_THRESHOLD = 90
end
