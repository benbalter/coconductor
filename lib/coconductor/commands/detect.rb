# frozen_string_literal: true

class CoconductorCLI < Thor
  desc 'detect [PATH]', 'Detect the code of conduct of the given project', default: Dir.pwd
  option :confidence, type: :numeric, default: Coconductor.confidence_threshold, desc: 'Confidence threshold'
  option :diff, type: :boolean, desc: 'Compare the code of conduct to the closest match'
  option :code_of_conduct, type: :string, desc: 'The key of the code of conduct to compare (implies --diff)'

  def detect(_path = nil)
    Coconductor.confidence_threshold = options[:confidence]
    rows = []
    rows << if code_of_conduct
              ['Code of conduct:', code_of_conduct.name]
            else
              ['Code of conduct:', set_color('None', :red)]
            end

    unless code_of_conduct.nil?
      %i[key family version language].each do |method|
        value = code_of_conduct.public_send(method)
        rows << [humanize(method, :method), humanize(value, method)] if value
      end
    end

    unless code_of_conduct_file.nil?
      %i[relative_path confidence matcher content_hash].each do |method|
        value = code_of_conduct_file.public_send(method)
        rows << [humanize(method, :method), humanize(value, method)] if value
      end
    end

    print_table rows

    return unless code_of_conduct_file && (options[:code_of_conduct] || options[:diff])

    expected_code_of_conduct = options[:code_of_conduct] || closest_code_of_conduct
    return unless expected_code_of_conduct

    invoke(:diff, nil,
           code_of_conduct: expected_code_of_conduct,
           code_of_conduct_to_diff: code_of_conduct_file)
  end

  private

  def closest_code_of_conduct
    return unless code_of_conduct_file

    matcher = Coconductor::Matchers::Dice.new(code_of_conduct_file)
    matches = matcher.matches_by_similarity
    matches.first.first.key unless matches.empty?
  end

  # Given a string or object, prepares it for output and human consumption
  def humanize(value, type = nil)
    case type
    when :matcher
      value.class
    when :confidence
      Licensee::ContentHelper.format_percent(value)
    when :method
      "#{value.to_s.tr('_', ' ').capitalize}:"
    else
      value
    end
  end
end
