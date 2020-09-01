# frozen_string_literal: true

require 'tmpdir'

class CoconductorCLI < Thor
  desc 'diff [PATH]', 'Compare the given code of conduct text to a known code of conduct'
  option :code_of_conduct, type: :string, desc: 'The key of the code of conduct to compare'

  def diff(_path = nil)
    say "Comparing to #{expected_code_of_conduct.name}:"
    rows = []
    left = expected_code_of_conduct.content_normalized(wrap: 80)
    right = code_of_conduct_to_diff.content_normalized(wrap: 80)

    similarity = expected_code_of_conduct.similarity(code_of_conduct_to_diff)
    similarity = Licensee::ContentHelper.format_percent(similarity)

    rows << ['Input Length:', code_of_conduct_to_diff.length]
    rows << ['License length:', expected_code_of_conduct.length]
    rows << ['Similarity:', similarity]
    print_table rows

    if left == right
      say 'Exact match!', :green
      exit
    end

    Dir.mktmpdir do |dir|
      path = File.expand_path 'CODE_OF_CONDUCT', dir
      Dir.chdir(dir) do
        `git init`
        File.write(path, left)
        `git add CODE_OF_CONDUCT`
        `git commit -m 'left'`
        File.write(path, right)
        say `git diff --word-diff`
      end
    end
  end

  private

  def code_of_conduct_to_diff
    return options[:code_of_conduct_to_diff] if options[:code_of_conduct_to_diff]

    return project.code_of_conduct_file if remote?

    @code_of_conduct_to_diff ||= begin
      if $stdin.tty?
        error 'You must pipe the file contents to the command via STDIN'
        exit 1
      end

      filename = 'CODE_OF_CONDUCT.txt'
      Coconductor::ProjectFiles::CodeOfConductFile.new($stdin.read, filename)
    end
  end

  def expected_code_of_conduct
    if options[:code_of_conduct]
      @expected_code_of_conduct ||= Coconductor::CodeOfConduct.find(
        options[:code_of_conduct]
      )
    end
    return @expected_code_of_conduct if @expected_code_of_conduct

    if options[:code_of_conduct]
      error "#{options[:code_of_conduct]} is not a valid code of conduct"
    else
      error 'You must provide an expected code of conduct'
    end

    keys = Coconductor.codes_of_conduct.map(&:key).join(', ')
    error "Valid codes of conduct: #{keys}"
    exit 1
  end
end
