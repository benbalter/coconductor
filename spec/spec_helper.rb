RSpec.configure do |config|
  config.disable_monkey_patching!
  config.warnings = true

  config.default_formatter = 'doc' if config.files_to_run.one?

  config.order = :random
  Kernel.srand config.seed
end

require_relative '../lib/coconductor'

def project_root
  File.expand_path '../', File.dirname(__FILE__)
end

def fixtures_base
  File.expand_path 'spec/fixtures', project_root
end

def fixture_path(fixture)
  File.expand_path fixture, fixtures_base
end

def fixture_contents(fixture)
  File.read fixture_path(fixture)
end

# Init git dir
# Note: we disable gpgsign and restore it to its original setting to avoid
# Signing commits during tests and slowing down / breaking specs
def git_init(path)
  Dir.chdir path do
    `git init`
    `git config --local commit.gpgsign false`
    `git add .`
    `git commit -m 'initial commit'`
  end
end
