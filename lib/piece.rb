require_relative "Serializable.rb"

class Piece
    include Serializable
    attr_reader :moveset, :limited, :white
    attr_accessor :moves
    def initialize(white)
        @moveset = []
        @moves = 0
        @white = white # bool value to flag if the piece is on the white team or the black team
        @limited = true # limited is the determination if the piece can only move the distance of the moveset or move the moveset any number of times
    end

    def get_moveset
        return moveset
    end
end

class Knight < Piece
    def initialize(white)
        super(white)
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
        if white
            subscript = "\u2081"
        else
            subscript = "\u2082"
        end
        return "K#{subscript}".encode('utf-8')
    end
end

class King < Piece
    def initialize(white)
        super(white)
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
        if white
            subscript = "\u2081"
        else
            subscript = "\u2082"
        end
        return "†#{subscript}".encode('utf-8')
    end
end

class Rook < Piece
    def initialize(white)
        super(white)
        @limited = false
        @moveset = [
            [1,0],
            [-1,0],
            [0,1],
            [0,-1]
        ]
    end

    
    def to_s
        if white
            subscript = "\u2081"
        else
            subscript = "\u2082"
        end
        return "R#{subscript}".encode('utf-8')
    end
end

class Bishop < Piece
    def initialize(white)
        super(white)
        @limited = false
        @moveset = [
            [1,1],
            [-1,1],
            [1,-1],
            [-1,-1],
        ]
    end

    
    def to_s
        if white
            subscript = "\u2081"
        else
            subscript = "\u2082"
        end
        return "B#{subscript}".encode('utf-8')
    end
end

class Queen < Piece
    def initialize(white)
        super(white)
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
        if white
            subscript = "\u2081"
        else
            subscript = "\u2082"
        end
        return "Q#{subscript}".encode('utf-8')
    end
end

class Pawn < Piece
    attr_reader :moveset_b, :moveset_w, :special_moveset_b, :special_moveset_w
    def initialize(white)
        super(white)
        @limited = true
        @moveset_b = [[1,0]]
        @moveset_w = [[-1,0]]
        @special_moveset_b = [[1,1],[1,-1]]
        @special_moveset_w = [[-1,1],[-1,-1]]
    end

    def get_special_moves
        if @white
            return @special_moveset_w
        else
            return @special_moveset_b
        end
    end
    
    def get_moveset
        if @moves > 0
            if @white
                return @moveset_w
            else
                return @moveset_b
            end
        else
            if @white
                return @moveset_w + [[-2,0]]
            else
                return @moveset_b + [[2,0]]
            end
        end
    end

    
    def to_s
        if white
            subscript = "\u2081"
        else
            subscript = "\u2082"
        end
        return "P#{subscript}".encode('utf-8')
    end
end