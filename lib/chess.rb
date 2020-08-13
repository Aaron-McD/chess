require_relative "player.rb"
require_relative "board.rb"
require_relative "piece.rb"
class Chess
    def initialize(player1, player2)
        if(player1.is_a?(Player) && player2.is_a?(Player))
            @p1 = player1
            @p2 = player2
            @board = Board.new
            @weight = 0
            fill_board
        else
            raise "The players passed to chess object must be a Player object"
        end
    end

    private

    def fill_board
        column_index = ["a","b","c","d","e","f","g","h"]
        i = 0
        8.times do
            piece = Pawn.new(true)
            @board.add_piece(piece, 2, column_index[i])
            piece = Pawn.new(false)
            @board.add_piece(piece, 7, column_index[i])
            i += 1
        end
        i = 1
        4.times do
            white = (i % 2 == 0)
            rook = Rook.new(white)
            knight = Knight.new(white)
            bishop = Bishop.new(white)
            if(i < 3)
                if(white)
                    @board.add_piece(rook, 1, "a")
                    @board.add_piece(knight, 1, "b")
                    @board.add_piece(bishop, 1, "c")
                else
                    @board.add_piece(rook, 8, "a")
                    @board.add_piece(knight, 8, "b")
                    @board.add_piece(bishop, 8, "c")
                end
            else
                if(white)
                    @board.add_piece(rook, 1, "h")
                    @board.add_piece(knight, 1, "g")
                    @board.add_piece(bishop, 1, "f")
                else
                    @board.add_piece(rook, 8, "h")
                    @board.add_piece(knight, 8, "g")
                    @board.add_piece(bishop, 8, "f")
                end
            end
            i += 1
        end
        i = 0
        2.times do
            white = i % 2 == 0
            king = King.new(white)
            queen = Queen.new(white)
            if white
                @board.add_piece(king, 1, "e")
                @board.add_piece(queen, 1, "d")
            else
                @board.add_piece(king, 8, "e")
                @board.add_piece(queen, 8, "d")
            end
        end
    end
end