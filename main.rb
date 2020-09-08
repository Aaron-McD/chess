require_relative "lib/chess.rb"

def play_round(game)
    if game.check?
        puts "#{game.current_player.name} is in check!"
    end
    puts "It is #{game.current_player.name}'s turn, please type in your move in '<location from> - <location to>' format."
    puts "Example a4 - a5 would be a move for a4 to a5."
    print "-> "
    move = game.get_move
    until game.valid_move?(move)
        print "Sorry that isn't a valid move, please try again: "
        move = game.get_move
    end
    game.execute_move(move, true)
    game.change_player
end


p1 = Player.new("aaron", true)
p2 = Player.new("bob", false)

game = Chess.new(p1, p2)

until game.check_mate?
    game.show_board
    play_round(game)
end
winning_player = game.current_player == p1 ? p2 : p1
puts "#{game.current_player.name} has been checkmated! #{winning_player.name} wins!"