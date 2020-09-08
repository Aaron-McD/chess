require_relative "lib/chess.rb"

def play_move(game, move)
    game.execute_move(move, true)
    game.change_player
end

def play_game(game)
    until game.check_mate?
        game.show_board
        puts "#{game.current_player.name} is in check!" if game.check?
        puts "It is #{game.current_player.name}'s turn, please type in your move in '<location from> - <location to>' format."
        puts "Example a4 - a5 would be a move for a4 to a5. Type 'save' to save the current game state."
        print "-> "
        move = game.get_move
        if move == 'save'
            puts "save"
        else
            until game.valid_move?(move)
                print "Sorry that isn't a valid move, please try again: "
                move = game.get_move
                if move == 'save'
                    break
                end
            end
            if move == 'save'
                puts 'save'
            else
                play_move(game, move)
            end
        end
    end
    game.show_board
    puts "#{game.current_player.name} has been checkmated! #{game.other_player.name} wins!"
end


p1 = Player.new("aaron", true)
p2 = Player.new("bob", false)

game = Chess.new(p1, p2)

play_game(game)
