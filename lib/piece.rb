
class Piece
    attr_reader :moveset, :limited
    def initialize(row, column, white)
        @row = row
        @column = column
        @moveset = []
        @moved = false
        @white = white # bool value to flag if the piece is on the white team or the black team
        @limited = true # limited is the determination if the piece can only move the distance of the moveset or move the moveset any number of times
    end

    def show_moveset
        return moveset
    end

    def move_position(row, column)
        @moved = true
        @row = row
        @column = column
    end
end

class Knight < Piece
    def initialize(row, column, white)
        super(row, column, white)
        @moveset = [
            [2,1],
            [1,2],
            [-2,1],
            [-1,2],
            [-2,-1],
            [-1,-2],
            [2,-1],
            [1,-2]
        ]
    end

    def to_s
        return "K"
    end
end

class King < Piece
    def initialize(row, column, white)
        super(row, column, white)
        @moveset = [
            [1,1],
            [-1,1],
            [1,-1],
            [-1,-1],
            [1,0],
            [-1,0],
            [0,1],
            [0,-1]
        ]
    end

    def to_s
        return "†"
    end
end

class Rook < Piece
    def initialize(row, column, white)
        super(row, column, white)
        @limited = false
        @moveset = [
            [1,0],
            [-1,0],
            [0,1],
            [0,-1]
        ]
    end

    def to_s
        return "R"
    end
end

class Bishop < Piece
    def initialize(row, column, white)
        super(row, column, white)
        @limited = false
        @moveset = [
            [1,1],
            [-1,1],
            [1,-1],
            [-1,-1],
        ]
    end

    def to_s
        return "B"
    end
end

class Queen < Piece
    def initialize(row, column, white)
        super(row, column, white)
        @limited = false
        @moveset = [
            [1,1],
            [-1,1],
            [1,-1],
            [-1,-1],
            [1,0],
            [-1,0],
            [0,1],
            [0,-1]
        ]
    end

    def to_s
        return "Q"
    end
end

class Pawn < Piece
    def initialize(row, column, white)
        super(row, column, white)
        @limited = true
        @moveset_w = [[1,0]]
        @moveset_b = [[-1,0]]
    end
    
    def show_moveset
        if @moved
            if @white
                return @moveset_w
            else
                return @moveset_b
            end
        else
            if @white
                return @moveset_w + [[2,0]]
            else
                return @moveset_b + [[-2,0]]
            end
        end
    end

    def to_s
        return "P"
    end
end