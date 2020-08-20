require_relative "player.rb"
require_relative "board.rb"
require_relative "piece.rb"
class Chess
    def initialize(player1, player2)
        if(player1.is_a?(Player) && player2.is_a?(Player))
            @p1 = player1
            @p2 = player2
            @current_player = @p1
            @board = Board.new
            fill_board
        else
            raise "The players passed to chess object must be a Player object"
        end
    end

    def show_board
        puts "#{@p2.name}".center(35)
        puts "  ---------------------------------\n"
        puts @board
        puts "  ---------------------------------\n"
        puts "#{@p1.name}".center(35)
    end

    def play_round
        puts "It is #{@current_player.name}'s turn, please type in your move in <location from> - <location to> format."
        puts "Example (a4 - a5) would be a move for a4 to a5."
        print "-> "
        moves = get_move
        p moves
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
            i += 1
        end
    end

    def change_player
        @current_player = @current_player == @p1 ? @p2 : @p1
    end

    def get_move
        input = gets.chomp
        columns = ["a","b","c","d","e","f","g","h"]
        rows = ["1","2","3","4","5","6","7","8"]
        correct = false
        until correct
            input = input.gsub(" ","").split("-")
            correct_length = input.length == 2
            input = input.map { |item| item = item.split("") }
            bool_arry = []
            input.each do |arry|
                bool_arry.push(columns.any? { |char| char == arry[0] })
                bool_arry.push(rows.any? { |char| char == arry[1] })
            end
            correct_orientation = bool_arry.all? { |bool| bool == true }
            correct = correct_length && correct_orientation
            unless correct
                if correct_length
                    puts "It seems that your values are incorrect or in the wrong orientation, make sure it is <letter><number> and within the bounds of the board."
                else
                    puts "Sorry but that isn't correct, make sure you add your '-' character between the locations."
                end
                print "Please try again: "
                input = gets.chomp
            end
        end
        return input
    end
end