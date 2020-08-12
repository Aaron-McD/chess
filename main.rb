require_relative "lib/chess.rb"
# example API usage
# puts "Welcome to chess in the console! We will start by getting the name of player 1: "
# player1 = get_player
# puts "Alright now we will get the name of player 2:"
# player2 = get_player

# game = Chess.new("player1", "player2")

=begin
until game.check_mate
    game.change_player
    game.show_board
    game.play_round
end
=end

pawn = Pawn.new(8,"a", false)

p pawn.show_moveset