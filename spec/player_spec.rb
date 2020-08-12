require "./lib/player.rb"

player = Player.new("bob")

describe "Player" do
    describe "#name" do
        it "returns the players name" do
            expect(player.name).to eq("bob")
        end
    end
end