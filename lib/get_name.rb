require 'dinosaurus'
require 'delegate'

Dinosaurus.configure do |config|
  config.api_key = '94fdfa05184d78146123fe7c68bef71f'
end

class Animal < SimpleDelegator
  ADJECTIVES = %w{
    daptable adventurous affable affectionate agreeable ambitious amiable
    amicable amusing brave bright broad-minded calm careful charming
    communicative compassionate conscientious considerate convivial courageous
    courteous creative decisive determined diligent diplomatic discreet dynamic
    easygoing emotional energetic enthusiastic extroverted exuberant
    fair-minded faithful fearless forceful frank friendly funny generous gentle
    good gregarious hard-working helpful honest humorous imaginative impartial
    independent intellectual intelligent intuitive inventive kind loving loyal
    modest neat nice optimistic passionate patient persistent pioneering
    philoshopical placid plucky polite powerful practical pro-active
    quick-witted quiet rational reliable reserved resourceful romantic
    self-confident self-disciplined sensible sensitive shy sincere sociable
    straightforward sympathetic thoughtful tidy tough unassuming understanding
    versatile warmhearted willing witty
  }

  ANIMALS = %w{
    aardvark addax alligator alpaca anteater antelope aoudad ape argali
    armadillo ass baboon badger basilisk bat bear beaver bighorn bison boar
    budgerigar buffalo bull bunny burro camel canary capybara cat chameleon
    chamois cheetah chimpanzee chinchilla chipmunk civet coati colt cony cougar
    cow coyote crocodile crow deer dingo doe dog donkey dormouse dromedary
    duckbill dugong eland elephant elk ermine ewe fawn ferret finch fish fox
    frog gazelle gemsbok gila-monster giraffe gnu goat gopher gorilla
    grizzly-bear ground-hog guanaco guinea-pig hamster hare hartebeest hedgehog
    hippopotamus hog horse hyena ibex iguana impala jackal jaguar jerboa
    kangaroo kid kinkajou kitten koala koodoo lamb lemur leopard lion lizard
    llama lovebird lynx mandrill mare marmoset marten mink mole mongoose monkey
    moose mountain-goat mouse mule musk-deer musk-ox muskrat mustang mynah-bird
    newt ocelot okapi opossum orangutan oryx otter ox panda panther parakeet
    parrot peccary pig platypus polar-bear pony porcupine porpoise prairie-dog
    pronghorn puma puppy quagga rabbit raccoon ram rat reindeer reptile
    rhinoceros roebuck salamander seal sheep shrew silver-fox skunk sloth snake
    springbok squirrel stallion steer tapir tiger toad turtle vicuna walrus
    warthog waterbuck weasel whale wildcat wolf wolverine wombat woodchuck yak
    zebra zebu
  }

  def call
    10.times.map &to_name
  end

  def random_adjective
    ADJECTIVES.sample
  end

  def random_animal
    ANIMALS.sample
  end

  def to_name
    ->(i) {
      [random_adjective, random_animal].join ' '
    }
  end
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
