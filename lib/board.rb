# frozen_string_literal: true

class Board
  attr_reader :width, :height, :grid

  def initialize(width = 7, height = 6, grid = nil)
    @width = width
    @height = height
    @grid = grid || [[nil] * height] * width
  end

  def invalid_column?(col_id)
    !col_id.between?(0, width - 1) || column_full?(col_id)
  end

  def place!(column_id, player_id)
    cell_to_place = grid[column_id].index(nil)
    grid[column_id][cell_to_place] = player_id unless cell_to_place.nil?
  end

  def tie?
    game_state == :TIE
  end

  def game_over?
    game_state != :NOT_END
  end

  def winner
    game_state
  end

  private

  # Detects the state of the game.
  # Returns 0 or 1 if the corresponding player wins.
  # Returns :TIE if there's a tie.
  # Returns :NOT_END else
  def game_state
    if grid_four_connected?(0)
      0
    elsif grid_four_connected?(1)
      1
    elsif grid_full?
      :TIE
    else
      :NOT_END
    end
  end

  def grid_full?
    (0...width).all? { |col_id| column_full?(col_id) }
  end

  def column_full?(col_id)
    grid[col_id].none?(&:nil?)
  end

  def grid_four_connected?(player_id)
    lines.any? { |line| line_four_connected?(line, player_id) }
  end

  def line_four_connected?(line, player_id)
    line.each_cons(4) do |l|
      return true if l.all? { |cell| cell == player_id }
    end
    false
  end

  def lines
    rows + columns + diagonals + back_diagonals
  end

  def select_cells
    result = []
    grid.each_with_index do |column, i|
      column.each_with_index do |cell, j|
        result.push(cell) if yield(i, j)
      end
    end
    result
  end

  def rows
    rows = []
    (0...height).each do |row_id|
      row = select_cells { |_, j| j == row_id }
      rows.push(row)
    end
    rows
  end

  def columns
    columns = []
    (0...width).each do |col_id|
      column = select_cells { |i, _| i == col_id }
      columns.push(column)
    end
    columns
  end

  def diagonals
    diagonals = []
    ((1 - width)..(height - 1)).each do |diag_id|
      diagonal = select_cells { |i, j| j - i == diag_id }
      diagonals.push(diagonal)
    end
    diagonals
  end

  def back_diagonals
    back_diagonals = []
    (0..(width + height - 2)).each do |back_diag_id|
      back_diagonal = select_cells { |i, j| j + i == back_diag_id }
      back_diagonals.push(back_diagonal)
    end
    back_diagonals
  end
end
