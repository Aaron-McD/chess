require_relative "lib/chess.rb"


p1 = Player.new("aaron", true)
p2 = Player.new("bob", false)

game = Chess.new(p1, p2)

until game.check_mate?
    game.show_board
    game.play_round
end
winning_player = game.current_player == p1 ? p2 : p1
puts "#{game.current_player.name} has been checkmated! #{winning_player.name} wins!"