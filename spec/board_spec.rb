require "./lib/board.rb"

board = Board.new

describe "Board" do
    describe "#board" do
        it "returns an array that is 8 arrays long" do
            expect(board.board.length).to eq(8)
        end

        it "returns an array of arrays that are each 8 indices long" do
            expect(board.board[0].length).to eq(8)
        end

        it "has all values set to nil by default" do
            expect(board.board.all? { |array| array.all?{ |item| item == nil } } ).to eq(true)
        end
    end

    describe "#[]" do
        it "returns the object in that position" do
            expect(board[0].class).to eq(Array)
        end

        it "works with the 2D arrary to return the object in the nested array" do
            board[0][1] = "hello"
            expect(board[0][1]).to eq("hello")
        end
    end

    describe "#reset!" do
        it "resets the entire board back to all nil values" do
            board.reset!
            expect(board.board.all? { |array| array.all?{ |item| item == nil } } ).to eq(true)
        end
    end
end