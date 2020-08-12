
class Board
    attr_reader :board
    def initialize 
        @board = []
        8.times do 
            arry = []
            8.times do
                arry.push(nil)
            end
            @board.push(arry)
        end
    end
end