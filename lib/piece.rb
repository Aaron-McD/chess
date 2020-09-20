require_relative "Serializable.rb"

class Piece
    include Serializable
    attr_reader :white
    attr_accessor :moves
    def initialize(white)
        @moves = 0
        @white = white # bool value to flag if the piece is on the white team or the black team
    end
end

class Knight < Piece
    @@moveset = [
            [2,1],
            [1,2],
            [-2,1],
            [-1,2],
            [-2,-1],
            [-1,-2],
            [2,-1],
            [1,-2]
        ]
    @@limited = true 
    def initialize(white)
        super(white)
    end

    def get_moveset
        return @@moveset
    end

    def limited
        return @@limited
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
    @@moveset = [
            [1,1],
            [-1,1],
            [1,-1],
            [-1,-1],
            [1,0],
            [-1,0],
            [0,1],
            [0,-1]
        ]
    @@special_moveset = [[0,2],[0,-2]]
    @@limited = true 
    def initialize(white)
        super(white) 
    end

    def get_special_moves
        return @@special_moveset
    end

    def get_moveset
        return @@moveset
    end

    def limited
        return @@limited
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
    @@limited = false
    @@moveset = [
        [1,0],
        [-1,0],
        [0,1],
        [0,-1]
    ]
    def initialize(white)
        super(white) 
    end

    def limited
        return @@limited
    end

    def get_moveset
        return @@moveset
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
    @@limited = false
    @@moveset = [
        [1,1],
        [-1,1],
        [1,-1],
        [-1,-1],
    ]
    def initialize(white)
        super(white)
    end

    def get_moveset
        return @@moveset
    end

    def limited
        return @@limited
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
    @@limited = false
    @@moveset = [
        [1,1],
        [-1,1],
        [1,-1],
        [-1,-1],
        [1,0],
        [-1,0],
        [0,1],
        [0,-1]
    ]
    def initialize(white)
        super(white)
    end

    def get_moveset
        return @@moveset
    end

    def limited
        return @@limited
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
    @@limited = true
    @@moveset_b = [[1,0]]
    @@moveset_w = [[-1,0]]
    @@special_moveset_b = [[1,1],[1,-1]]
    @@special_moveset_w = [[-1,1],[-1,-1]]
    def initialize(white)
        super(white)
    end

    def limited
        return @@limited
    end

    def get_special_moves
        if @white
            return @@special_moveset_w
        else
            return @@special_moveset_b
        end
    end
    
    def get_moveset
        if @moves > 0
            if @white
                return @@moveset_w
            else
                return @@moveset_b
            end
        else
            if @white
                return @@moveset_w + [[-2,0]]
            else
                return @@moveset_b + [[2,0]]
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