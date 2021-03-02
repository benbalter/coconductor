# frozen_string_literal: true

require 'webmock/rspec'
WebMock.disable_net_connect!

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.warnings = true

  config.default_formatter = 'doc' if config.files_to_run.one?

  config.order = :random
  Kernel.srand config.seed
end

require 'fileutils'
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

def fixture_files(fixture)
  files = Dir.glob("#{fixture_path(fixture)}/**/*", File::FNM_DOTMATCH)
  files.select { |f| File.file?(f) }
end

def fixture_file_hash(file)
  path = file.gsub(fixtures_base, '').split('/')[2..-1].join('/')
  {
    name: File.basename(file),
    path: path,
    type: 'file'
  }
end

def fixture_file_hashes(fixture, path = nil)
  files = fixture_files(fixture).map { |f| fixture_file_hash(f) }
  return files unless path

  files.select { |f| f[:path].start_with?(path) }
end

def fixtures
  Dir["#{fixtures_base}/*"].map { |d| File.basename(d) }
end

def api_base
  'https://api.github.com/repos'
end

def mock_user
  '_coconductor_test_fixture'
end

def webmock_headers
  {
    'Content-Type' => 'application/json'
  }
end

def mock_fixture_files(fixture)
  fixture_file_hashes(fixture).each do |file|
    url = [api_base, mock_user, fixture, 'contents', file[:path]].join('/')
    body = fixture_contents("#{fixture}/#{file[:path]}")
    stub_request(:get, url).to_return(status: 200, body: body)
  end
end

def mock_fixture_indexes(fixture)
  [nil, 'docs/', '.github/'].each do |path|
    files = fixture_file_hashes(fixture, path)
    url = [api_base, mock_user, fixture, 'contents', path].join('/')
    response = { status: 200, body: files.to_json, headers: webmock_headers }
    stub_request(:get, url).to_return(response)
  end
end

def webmock_fixtures
  fixtures.each do |fixture|
    mock_fixture_indexes(fixture)
    mock_fixture_files(fixture)
  end
end
