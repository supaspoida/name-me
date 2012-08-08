require 'dinosaurus'

Dinosaurus.configure do |config|
  config.api_key = ENV['API_KEY']
end

class GetName < Struct.new(:one, :two)

  def self.[](one, two)
    new(one, two).call
  end

  def all
    combined.sort.map &to_name
  end

  def call
    all.join "\n"
  end

  def combined
    (one + two).combination(2)
  end

  def one
    @one ||= Dinosaurus.synonyms_of super
  end

  def to_name
    ->(words) {
      words.map(&:capitalize).join ' '
    }
  end

  def two
    @two ||= Dinosaurus.synonyms_of super
  end
end
