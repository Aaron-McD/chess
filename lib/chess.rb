require_relative "player.rb"
require_relative "board.rb"
require_relative "piece.rb"
class Chess
    def initialize(player1, player2)
        if(player1.is_a?(Player) && player2.is_a?(Player))
            @p1 = player1
            @p2 = player2
            puts "Hello world"
        else
            raise "The players passed to chess object must be a Player object"
        end
    end
end