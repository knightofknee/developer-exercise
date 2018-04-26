require_relative 'blackjackClassesOnly'

@game = Game.new

# Comment out this middle section to play the game yourself. otherwise it will be simulated
class FakeInput
  def gets
    @stubbed_input ||= Array.new(5).map{
      if rand(2) == 1
        'y'
      else 'n'
      end
    }
    @stubbed_input.shift
  end
end
$stdin = FakeInput.new



if !(@game.player_turn == 2)
  @game.dealer_turn
end

