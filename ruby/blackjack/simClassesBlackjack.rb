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

class Game
  attr_accessor :player_hand, :dealer_hand, :game_status

  def initialize
    @deck = Deck.new
    @player_hand = [].push(@deck.deal_card).push(@deck.deal_card)
    @dealer_hand = [].push(@deck.deal_card).push(@deck.deal_card)
    @player_score = 0
    @dealer_score = 0
    puts "The dealer's showing card is #{@dealer_hand[0].name} of #{@dealer_hand[0].suite}"
    puts "Your hand is a #{@player_hand[0].name} of #{@player_hand[0].suite} and a #{@player_hand[1].name} of #{@player_hand[0].suite}"
    if calculate_player_score == 21
      puts "BLACKJACK! You won!!!"
      @game_status = 2
    end
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

  def one_player_turn(hit)

    if (hit)
      @player_hand.push(@deck.deal_card)
      puts "You drew a #{@player_hand.last.name} of #{@player_hand.last.suite}"
      if calculate_player_score > 21
        puts "Sorry bud, you busted. Good luck next time!"
        return 2
      elsif calculate_player_score == 21
        puts "21! lets hope the dealer doesn't match!"
        return 3
      else puts "Your current score is #{calculate_player_score}"
        return 1
      end
    else
      puts "Player score is #{calculate_player_score}"
      return 3
    end
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


