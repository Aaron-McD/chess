require_relative "Serializable.rb"

class Player
    include Serializable
    attr_reader :name, :white
    def initialize(name, white)
        @name = name
        @white = white
    end
end