require_relative 'blackjackClassesOnly'

@game = Game.new

# Comment in this middle section to simulate user responses. otherwise you can play yourself
#   class FakeInput
#     def gets
#       @stubbed_input ||= Array.new(5).map{
#         if rand(2) == 1
#           'y'
#         else 'n'
#         end
#       }
#       @stubbed_input.shift
#     end
#   end
#   $stdin = FakeInput.new



if !(@game.player_turn == 2)
  @game.dealer_turn
end

