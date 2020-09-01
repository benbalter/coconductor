# frozen_string_literal: true

class CoconductorCLI < Thor
  desc 'version', 'Return the Coconductor version'
  def version
    say Coconductor::VERSION
  end
end
