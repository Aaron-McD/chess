
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

    def [](index)
        return @board[index]
    end

    def reset!
        @board = []
        8.times do 
            arry = []
            8.times do
                arry.push(nil)
            end
            @board.push(arry)
        end
    end

    def to_s
        outst = "    a   b   c   d   e   f   g   h \n"
        outst +="  ---------------------------------\n"
        y_axis = 8
        @board.each do |array|
            outst += y_axis.to_s
            array.each do |item|
                if item == nil
                    outst += " |  "
                else
                    outst += " |  #{item.to_s}"
                end
            end
            y_axis -= 1
            outst += " |\n"
            outst +="  ---------------------------------\n"
        end
        return outst
    end
end