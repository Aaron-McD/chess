require_relative "chess_node.rb"
require_relative "Serializable.rb"

class Chess_AI
  include Serializable
  attr_reader :white, :name
  @@DEPTH = [1, 2, 3]
  @@difficulty_name = ["Easy", "Medium", "Hard"]
  def initialize(white, difficulty)
    @white = white
    @difficulty = difficulty # integer from 0 - 2
    @name = "AI_#{@@difficulty_name[@difficulty]}"
  end

  def copy_game(game)
    test_player = Player.new("test", true)
    test_player2 = Player.new("test2", false)
    game.save_state("temp")
    copy = Chess.new(test_player, test_player2)
    copy = copy.load_state("temp")
    return copy
  end

  def update_game_to_node(game, node)
    node_path = [node]
    while node.parent != nil
      node = node.parent
      node_path.push(node)
    end
    node_path.reverse.each do |node|
      unless node.move == nil
        game.execute_move(node.move, true)
        game.change_player
      end
    end
    return game
  end

  def get_valid_moves(game)
    pieces = game.current_player_pieces
    valid_moves_unchecked = {}
    valid_moves = {}
    pieces.each do |piece|
      location = game.board.find_piece(piece)
      valid_moves_unchecked[location] = game.generate_valid_moveset(piece)
    end
    valid_moves_unchecked.each_key do |start|
      final_pos = []
      valid_moves_unchecked[start].each do |finish|
        if game.valid_move?([start, finish], true, true)
          final_pos.push(finish)
        end
      end
      valid_moves[start] = final_pos unless final_pos.empty?
    end
    return valid_moves
  end

  def get_pieces_value(pieces)
    score = 0
    king_present = false
    pieces.each do |piece|
      if piece.is_a?(Pawn)
        score += 1
      elsif piece.is_a?(Knight)
        score += 3
      elsif piece.is_a?(Rook)
        score += 5
      elsif piece.is_a?(Bishop)
        score += 3
      elsif piece.is_a?(Queen)
        score += 9
      else
        score += 10
        king_present = true
      end
    end
    return 0 unless king_present
    return score
  end

  def get_board_value(game)
    ai_pieces = @white == true ? game.p1_pieces : game.p2_pieces
    other_pieces = @white == false ? game.p1_pieces : game.p2_pieces
    ai_score = get_pieces_value(ai_pieces)
    other_score = get_pieces_value(other_pieces)
    return ai_score - other_score
  end

  def clean_children(node)
    useless_nodes = []
    node.children.each do |child|
      useless_nodes.push(child) if node.base_value == child.base_value
    end
    amount = useless_nodes.length
    while amount > 5
      index = rand(useless_nodes.length)
      child = useless_nodes[index]
      node.remove_child(child)
      useless_nodes.delete(child)
      amount -= 1
    end
  end

  def build_tree(game, prev_move, depth)
    root = Chess_Node.new(prev_move, nil, get_board_value(game))
    game.change_player unless prev_move == nil
    que = [root]
    i = 0
    while i < depth
      temp_que = []
      que.each do |node|
        if node.move == nil
          copy = copy_game(game)
        else
          copy = copy_game(game)
          copy = update_game_to_node(copy, node)
        end
        valid_moves = get_valid_moves(copy)
        valid_moves.each_key do |start|
          valid_moves[start].each do |finish|
            copy.execute_move([start, finish], false)
            new_node = Chess_Node.new([start, finish], node, get_board_value(copy))
            copy.undo_last_move(false)
            temp_que.push(new_node)
            node.append_child(new_node)
          end
        end
      end
      que = temp_que
      i += 1
    end
    return root
  end

  def assess_tree(root)
    highest_node = nil
    root.children.each do |node|
      node.update_avg
      if highest_node == nil
        highest_node = node
        next
      else
        highest_node = node if node.avg_value > highest_node.avg_value
      end
    end
    all_same = root.children.all? { |node| node.avg_value == highest_node.avg_value }
    if all_same
      index = rand(root.children.length)
      return root.children[index].move
    end
    return highest_node.move
  end

  def make_move(game)
    root = build_tree(game, nil, @@DEPTH[@difficulty])
    move = assess_tree(root)
    return move
  end
end