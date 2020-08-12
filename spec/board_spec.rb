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
end