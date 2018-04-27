require_relative 'simClassesBlackjack'

@game = Game.new

continue = 1
while (continue == 1) && @game.game_status != 2

  if (@game.calculate_player_score < 12)
    guess = true
  elsif(@game.calculate_player_score < 17)
    guess = rand(10) > 6
  else
    guess = rand(10) > 8
  end

  continue = @game.one_player_turn(guess)
end

if (continue != 2 && @game.game_status != 2)
  @game.dealer_turn
end
