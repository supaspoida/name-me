require 'dinosaurus'

Dinosaurus.configure do |config|
  config.api_key = ENV['API_KEY']
end

class Permutations < SimpleDelegator

  def call
    permutation(2).map(&to_name).sort
  end

  def to_name
    ->(words) {
      words.map(&:capitalize).join
    }
  end
end

class Similar < SimpleDelegator

  def call
    combined.map(&to_name).sort
  end

  def combined
    (one + two).permutation(2)
  end

  def one
    @one ||= Dinosaurus.synonyms_of first
  end

  def to_name
    ->(words) {
      words.map(&:capitalize).join ' '
    }
  end

  def two
    @two ||= Dinosaurus.synonyms_of last
  end
end

class GetName < Struct.new(:words)

  def self.[](words, strategy = Similar)
    words = words.split ' '
    new(strategy.new(words)).call
  end

  def all
    words.call
  end

  def call
    all.join "\n"
  end
end
