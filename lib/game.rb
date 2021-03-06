require "pry"

class Game
  attr_accessor :board, :player_1, :player_2, :player

  def initialize(player_1 = Players::Human.new("X"), player_2 = Players::Human.new("O"), board = Board.new)
    @player_1 = player_1
    @player_2 = player_2
    @board = board
  end

  WIN_COMBINATIONS = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ]

  #   [0, 1, 2],
  #   [3, 4, 5],
  #   [6, 7, 8],
  #   [0, 3, 6],
  #   [1, 4, 7],
  #   [2, 5, 8],
  #   [0, 4, 8],
  #   [2, 4, 6],
  # ]

  def current_player
    if board.turn_count.odd?
      player_2
    elsif board.turn_count.even?
      player_1
    end
  end

  def won?
    WIN_COMBINATIONS.each do |win_combination|
      win_index_1 = win_combination[0]
      win_index_2 = win_combination[1]
      win_index_3 = win_combination[2]

      position_1 = @board.cells[win_index_1]
      position_2 = @board.cells[win_index_2]
      position_3 = @board.cells[win_index_3]

      if position_1 == "X" && position_2 == "X" && position_3 == "X"
        return win_combination
      elsif position_1 == "O" && position_2 == "O" && position_3 == "O"
        return win_combination
      end
    end
    return false
  end

  def draw?
    if won? != false
      return false
    elsif board.full?
      return true
    end
  end

  def over?
    if won? || draw?
      return true
    end
  end

  def winner
    if won?
      return board.cells[won?[0]]
    end
  end

  def turn
    player = current_player
    current_move = player.move(@board)
    # move_index = Players.move.to_i - 1
    if @board.valid_move?(current_move)
      @board.update(current_move, player)
      @board.display
    else
      turn
    end
  end

  def play
    until over?
      turn
    end
    if won?
      puts "Congratulations #{winner}!"
    elsif draw?
      puts ""
      puts "Cat's Game!"
    end
  end
end
