require_relative "player.rb"
require_relative "board.rb"
require_relative "piece.rb"
class Chess
    def initialize(player1, player2)
        if(player1.is_a?(Player) && player2.is_a?(Player))
            if player1.white == true
                @p1 = player1
                @p2 = player2
            elsif player2.white == true
                @p1 = player2
                @p2 = player1
            elsif player1.white == player2.white
                raise "players must be of different colors"
            end
            @p1_pieces = []
            @p2_pieces = []
            @current_player = @p1
            @current_player_pieces = @p1_pieces
            @board = Board.new
            @previous_move = []
            @last_removed_piece = nil
            @COLUMNS = ["a","b","c","d","e","f","g","h"]
            @ROWS = ["1","2","3","4","5","6","7","8"]
            fill_board
        else
            raise "The players passed to chess object must be a Player object"
        end
    end

    def show_board
        puts ""
        puts "#{@p2.name}".center(44)
        puts "  -----------------------------------------\n"
        puts @board
        puts "  -----------------------------------------\n"
        puts "#{@p1.name}".center(44)
        puts ""
    end

    def play_round
        if check?
            puts "#{@current_player.name} is in check!"
        end
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

    def check?
        opposing_pieces = @current_player == @p1 ? @p2_pieces : @p1_pieces
        valid_movesets = []
        valid_ranges = []
        opposing_pieces.each do |piece|
            valid_movesets.push(generate_valid_moveset(piece))
        end
        king = @current_player_pieces[@current_player_pieces.index { |piece| piece.is_a?(King) }]
        king_location = @board.find_piece(king)
        valid_movesets.each do |moveset|
            moveset.each do |location|
                return true if location == king_location
            end
        end
        return false
    end

    def generate_valid_moveset(piece)
        location = @board.find_piece(piece)
        location_index = convert_location_to_index(location[0], location[1])
        valid_moves = []
        piece.get_moveset.each do |move|
            if piece.limited
                finish_index = [location_index[0] + move[0], location_index[1] + move[1]]
                final_pos = convert_index_to_location(finish_index[0], finish_index[1])
                finish = [final_pos[1], final_pos[0].to_s]
                start = [location[1], location[0].to_s]
                valid_moves.push(final_pos) if valid_move?([start, finish], false, true)
            else
                i = 1
                while i < 8
                    altered_move = [move[0] * i, move[1] * i]
                    finish_index = [location_index[0] + altered_move[0], location_index[1] + altered_move[1]]
                    final_pos = convert_index_to_location(finish_index[0], finish_index[1])
                    finish = [final_pos[1], final_pos[0].to_s]
                    start = [location[1], location[0].to_s]
                    if valid_move?([start, finish], false, true)
                        valid_moves.push(final_pos) 
                        i += 1
                    else
                        break
                    end
                end
            end
        end
        return valid_moves
    end

    def execute_move(move)
        start = move[0]
        finish = move[1]
        @previous_move = move
        piece = @board.get_piece(start[1].to_i, start[0])
        piece.moves += 1
        opposing_piece = @board.get_piece(finish[1].to_i, finish[0])
        @board.remove_piece(start[1].to_i, start[0])
        @last_removed_piece = opposing_piece
        if opposing_piece != nil
            @board.remove_piece(finish[1].to_i, finish[0])
            if @current_player == @p1
                @p2_pieces.delete(opposing_piece)
            else
                @p1_pieces.delete(opposing_piece)
            end
        end
        @board.add_piece(piece, finish[1].to_i, finish[0])
    end

    def undo_last_move
        start = @previous_move[0]
        finish = @previous_move[1]
        piece = @board.get_piece(finish[1].to_i, finish[0])
        piece.moves -= 1
        @board.remove_piece(finish[1].to_i, finish[0])
        if @last_removed_piece != nil
            @board.add_piece(@last_removed_piece, finish[1].to_i, finish[0])
            if @current_player == @p1
                @p2_pieces.push(@last_removed_piece)
            else
                @p1_pieces.push(@last_removed_piece)
            end
        end
        @board.add_piece(piece, start[1].to_i, start[0])
    end

    def move_without_check?(move)
        execute_move(move)
        if check?
            undo_last_move
            return false
        else
            undo_last_move
            return true
        end
    end

    def fill_board
        column_index = ["a","b","c","d","e","f","g","h"]
        i = 0
        8.times do
            piece = Pawn.new(true)
            @board.add_piece(piece, 2, column_index[i])
            @p1_pieces.push(piece)
            piece = Pawn.new(false)
            @board.add_piece(piece, 7, column_index[i])
            @p2_pieces.push(piece)
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
                    @p1_pieces.push(rook)
                    @p1_pieces.push(knight)
                    @p1_pieces.push(bishop)
                else
                    @board.add_piece(rook, 8, "a")
                    @board.add_piece(knight, 8, "b")
                    @board.add_piece(bishop, 8, "c")
                    @p2_pieces.push(rook)
                    @p2_pieces.push(knight)
                    @p2_pieces.push(bishop)
                end
            else
                if(white)
                    @board.add_piece(rook, 1, "h")
                    @board.add_piece(knight, 1, "g")
                    @board.add_piece(bishop, 1, "f")
                    @p1_pieces.push(rook)
                    @p1_pieces.push(knight)
                    @p1_pieces.push(bishop)
                else
                    @board.add_piece(rook, 8, "h")
                    @board.add_piece(knight, 8, "g")
                    @board.add_piece(bishop, 8, "f")
                    @p2_pieces.push(rook)
                    @p2_pieces.push(knight)
                    @p2_pieces.push(bishop)
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
                @p1_pieces.push(king)
                @p1_pieces.push(queen)
            else
                @board.add_piece(king, 8, "e")
                @board.add_piece(queen, 8, "d")
                @p2_pieces.push(king)
                @p2_pieces.push(queen)
            end
            i += 1
        end
    end

    def change_player
        @current_player_pieces = @current_player == @p1 ? @p2_pieces : @p1_pieces
        @current_player = @current_player == @p1 ? @p2 : @p1
    end

    def get_move
        input = gets.chomp
        correct = false
        until correct
            input = input.gsub(" ","").split("-")
            correct_length = input.length == 2
            input = input.map { |item| item = item.split("") }
            bool_arry = []
            input.each do |arry|
                bool_arry.push(@COLUMNS.any? { |char| char == arry[0] })
                bool_arry.push(@ROWS.any? { |char| char == arry[1] })
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
        start_piece = @board.get_piece(start[1].to_i, start[0])
        path.each do |pos| 
            piece = @board.get_piece(pos[0], pos[1])
            if piece != nil
                unless piece == final_piece && start_piece.white != final_piece.white
                    return false
                end
            end
        end
        return true
    end

    def within_bounds?(move)    
        starting_pos = move[0]
        end_pos = move[1]
        unless (@COLUMNS.include?(starting_pos[0]) && @COLUMNS.include?(end_pos[0])) && (@ROWS.include?(starting_pos[1]) && @ROWS.include?(end_pos[1]))
            return false
        end
        return true
    end

    def within_moveset?(piece, move)
        moveset = piece.get_moveset
        starting_pos_index = convert_location_to_index(move[0][1].to_i, move[0][0])
        end_pos_index = convert_location_to_index(move[1][1].to_i, move[1][0])
        movement = [end_pos_index[0] - starting_pos_index[0], end_pos_index[1] - starting_pos_index[1]]
        if piece.limited
            unless moveset.include?(movement)
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
                    return false
                end
            else
                if movement[0] % movement[1] != 0
                    return false
                else
                    base_value = movement[0] > 0 ? movement[0] : movement[0] * -1
                    base_move = [0,0]
                    base_move[0] = movement[0].to_f / base_value.to_f
                    base_move[1] = movement[1].to_f / base_value.to_f
                    unless moveset.include?(base_move)
                        return false
                    end
                end
            end
        end
        return true
    end

    def valid_path_for_piece?(piece, move)
        unless piece.is_a?(Knight)
            unless valid_path?(move[0], move[1])
                return false
            end
        else
            final_piece = @board.get_piece(move[1][1].to_i, move[1][0])
            if final_piece != nil
                if final_piece.white == piece.white
                    return false
                end
            end
        end
        return true
    end

    def valid_move?(move, player_matters = true, silence = false)
        # valid_move? is a checklist for certain criteria to declare a move as valid
        piece = @board.get_piece(move[0][1].to_i, move[0][0])
        # check that the move is within the givin rows and columns available
        unless within_bounds?(move)
            puts "That move is out of bounds." unless silence
            return false 
        end
        # check that there is a piece at the starting location
        if piece == nil
            puts "There is no piece at that starting location." unless silence
            return false 
        end
        # check that the piece is accessible to the player trying to use it
        if @current_player.white != piece.white && player_matters
            puts "That isn't your piece." unless silence
            return false
        end
        # check that the piece is trying to be moved within its moveset
        unless within_moveset?(piece, move)
            puts "That isn't a valid move for that piece." unless silence
            return false
        end
        # check that it has a valid path
        unless valid_path_for_piece?(piece, move)
            puts "There is a piece in the way." unless silence
            return false
        end
        # check that the movement won't put the player in check
        if player_matters
            unless move_without_check?(move)
                puts "That move would put you in check" unless silence
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