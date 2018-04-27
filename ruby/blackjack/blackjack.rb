class Card
  attr_accessor :suite, :name, :value

  def initialize(suite, name, value)
    @suite, @name, @value = suite, name, value
  end
end

class Deck
  attr_accessor :playable_cards
  SUITES = [:hearts, :diamonds, :spades, :clubs]
  NAME_VALUES = {
    :two   => 2,
    :three => 3,
    :four  => 4,
    :five  => 5,
    :six   => 6,
    :seven => 7,
    :eight => 8,
    :nine  => 9,
    :ten   => 10,
    :jack  => 10,
    :queen => 10,
    :king  => 10,
    :ace   => 1}

  def initialize
    shuffle
  end

  def deal_card
    random = rand(@playable_cards.size)
    @card = @playable_cards[random]
    @playable_cards.delete_at(random)
  end

  def shuffle
    @playable_cards = []
    SUITES.each do |suite|
      NAME_VALUES.each do |name, value|
        @playable_cards << Card.new(suite, name, value)
      end
    end
  end
end

class Hand
  attr_accessor :cards

  def initialize
    @cards = []
  end
end

require 'test/unit'

class CardTest < Test::Unit::TestCase
  def setup
    @card = Card.new(:hearts, :ten, 10)
  end

  def test_card_suite_is_correct
    assert_equal @card.suite, :hearts
  end

  def test_card_name_is_correct
    assert_equal @card.name, :ten
  end
  def test_card_value_is_correct
    assert_equal @card.value, 10
  end
end

class DeckTest < Test::Unit::TestCase
  def setup
    @deck = Deck.new
  end

  def test_new_deck_has_52_playable_cards
    assert_equal @deck.playable_cards.size, 52
  end

  def test_dealt_card_should_not_be_included_in_playable_cards
    card = @deck.deal_card
    assert(!@deck.playable_cards.include?(card))
  end

  def test_shuffled_deck_has_52_playable_cards
    @deck.shuffle
    assert_equal @deck.playable_cards.size, 52
  end
end

class Game
  attr_accessor :player_hand, :dealer_hand

  def initialize
    @deck = Deck.new
    @player_hand = [].push(@deck.deal_card).push(@deck.deal_card)
    @dealer_hand = [].push(@deck.deal_card).push(@deck.deal_card)
    @player_score = 0
    @dealer_score = 0
    puts "The dealer's showing card is #{@dealer_hand[0].name} of #{@dealer_hand[0].suite}"
  end

  def calculate_player_score
    player_score = 0
    ace_flag = false
    @player_hand.each do |card|
      if card.name.to_s == 'ace'
        ace_flag = true
      end
      player_score += card.value
    end
    if ace_flag && (player_score < 12)
      player_score += 10
    end
    player_score
  end

  def calculate_dealer_score
    dealer_score = 0
    ace_flag = false
    @dealer_hand.each do |card|
      if card.name.to_s == 'ace'
        ace_flag = true
      end
      dealer_score += card.value
    end
    if ace_flag && (dealer_score < 12)
      dealer_score += 10
    end
    dealer_score
  end

  def player_turn
    puts "Your hand is a #{@player_hand[0].name} of #{@player_hand[0].suite} and a #{@player_hand[1].name} of #{@player_hand[0].suite}"
    if calculate_player_score == 21
      puts "BLACKJACK! You won!!!"
      return 2
    end
    while true
      print "Would you like to hit again? [y/n]: "
      case gets.strip
      when 'Y', 'y', 'yes', 'Yes'
        @player_hand.push(@deck.deal_card)
        puts "You drew a #{@player_hand.last.name} of #{@player_hand.last.suite}"
        if calculate_player_score > 21
          puts "Sorry bud, you busted. Good luck next time!"
          return 2
        elsif calculate_player_score == 21
          puts "21! lets hope the dealer doesn't match!"
          break
        else puts "Your current score is #{calculate_player_score}"
        end
      when 'N', 'n', 'no', 'No'
        puts "Player score is #{calculate_player_score}"
        break
      end
    end
    true
  end

  def dealer_turn
    puts "The dealer has a #{@dealer_hand[0].name} of #{@dealer_hand[0].suite} and a #{@dealer_hand[1].name} of #{@dealer_hand[1].suite}"
    while (calculate_dealer_score < 17) do
      @dealer_hand.push(@deck.deal_card)
      puts "Dealer drew a #{@dealer_hand.last.name} of #{@dealer_hand.last.suite}"
    end
    if calculate_dealer_score > 21
      puts "Woo! The house busted! You win!"
    elsif calculate_player_score > calculate_dealer_score
      puts "Yayay! You have a higher score, you win!"
    elsif calculate_player_score == calculate_dealer_score
      puts "Womp, it's a tie"
    else puts "Dealer wins with a score of #{calculate_dealer_score} over #{calculate_player_score}"
    end
    true
  end

end

class GameTest < Test::Unit::TestCase
  def setup
    @game = Game.new
  end

  def test_new_game_has_dealer_cards
    assert_equal @game.dealer_hand.size, 2
  end

  def test_new_game_has_player_cards
    assert_equal @game.player_hand.size, 2
  end

  def test_player_score_calc
    @game.player_hand = [Card.new(:hearts, :ten, 10), Card.new(:hearts, :ace, 1)]
    assert_equal @game.calculate_player_score, 21
  end

  def test_black_jack_test
    @game.player_hand = [Card.new(:hearts, :ten, 10), Card.new(:hearts, :ace, 1)]
    assert_equal @game.player_turn, 2
  end

  def test_game_has_turn_play
    assert_equal @game.player_turn, true
  end

  def test_game_has_dealer_play
    @game.player_turn
    assert_equal @game.dealer_turn, true
  end

end
