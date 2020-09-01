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
        puts ""
        puts "#{@p2.name}".center(42)
        puts "  ----------------------------------------\n"
        puts @board
        puts "  ----------------------------------------\n"
        puts "#{@p1.name}".center(42)
        puts ""
    end

    def play_round
        puts "It is #{@current_player.name}'s turn, please type in your move in '<location from> - <location to>' format."
        puts "Example a4 - a5 would be a move for a4 to a5."
        print "-> "
        move = get_move
        until valid_move?(move)
            print "Sorry that isn't a valid move, please try again: "
            move = get_move
        end
        execute_move(move)
        change_player
    end

    private

    def execute_move(move)
        start = move[0]
        finish = move[1]
        piece = @board.get_piece(start[1].to_i, start[0])
        piece.move_position
        opposing_piece = @board.get_piece(finish[1].to_i, finish[0])
        @board.remove_piece(start[1].to_i, start[0])
        if opposing_piece != nil
            @board.remove_piece(finish[1].to_i, finish[0])
        end
        @board.add_piece(piece, finish[1].to_i, finish[0])
    end

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

    def get_path(start, finish)
        starting_pos_index = convert_location_to_index(start[1].to_i, start[0])
        end_pos_index = convert_location_to_index(finish[1].to_i, finish[0])
        path = []
        while starting_pos_index != end_pos_index
            if end_pos_index[0] > starting_pos_index[0]
                starting_pos_index[0] += 1
            elsif end_pos_index[0] < starting_pos_index[0]
                starting_pos_index[0] -= 1
            end
            if end_pos_index[1] > starting_pos_index[1]
                starting_pos_index[1] += 1
            elsif end_pos_index[1] < starting_pos_index[1]
                starting_pos_index[1] -= 1
            end
            path.push(convert_index_to_location(starting_pos_index[0], starting_pos_index[1]))
        end
        return path
    end

    def valid_path?(start, finish)
        path = get_path(start, finish)
        final_piece = @board.get_piece(finish[1].to_i, finish[0])
        path.each do |pos| 
            piece = @board.get_piece(pos[0], pos[1])
            if piece != nil
                unless piece == final_piece && piece.white != @current_player.white
                    return false
                end
            end
        end
        return true
    end

    def valid_move?(move)
        starting_pos = move[0]
        end_pos = move[1]
        piece = @board.get_piece(starting_pos[1].to_i, starting_pos[0])
        if piece == nil
            puts "There is no piece at that starting location."
            return false 
        end
        if @current_player.white != piece.white
            puts "That isn't your piece"
            return false
        end
        moveset = piece.get_moveset
        starting_pos_index = convert_location_to_index(starting_pos[1].to_i, starting_pos[0])
        end_pos_index = convert_location_to_index(end_pos[1].to_i, end_pos[0])
        movement = [end_pos_index[0] - starting_pos_index[0], end_pos_index[1] - starting_pos_index[1]]
        if piece.limited
            unless moveset.include?(movement)
                puts "That isn't a valid move for that piece."
                return false
            end
        else
            if movement[0] == 0 || movement[1] == 0
                zero_value = movement[0] == 0 ? 0 : 1
                non_zero_value = movement[0] != 0 ? 0 : 1
                if movement[non_zero_value] > 0
                    base_move = [1,1]
                else
                    base_move = [-1,-1]
                end
                base_move[zero_value] = 0
                unless moveset.include?(base_move)
                    puts "That isn't a valid move for that piece."
                    return false
                end
            else
                if movement[0] % movement[1] != 0
                    puts "That isn't a valid move for that piece."
                    return false
                else
                    base_value = movement[0] > 0 ? movement[0] : movement[0] * -1
                    base_move = [0,0]
                    base_move[0] = movement[0] / base_value
                    base_move[1] = movement[1] / base_value
                    unless moveset.include?(base_move)
                        puts "That isn't a valid move for that piece."
                        return false
                    end
                end
            end
        end
        unless piece.is_a?(Knight)
            unless valid_path?(starting_pos, end_pos)
                puts "There is a piece in the way."
                return false
            end
        end
        return true
    end

    # these functions work in opposite where the recieve 2 items and convert from one format to the other for ease
    # with the 2D array and the board object

    def convert_location_to_index(row, column)
        column = column.ord - 97
        row = 8 - row
        return [row, column]
    end

    def convert_index_to_location(row, column)
        column = (column + 97).chr
        row = (row - 8) * -1
        return [row, column]
    end
end