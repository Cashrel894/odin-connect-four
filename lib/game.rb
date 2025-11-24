# frozen_string_literal: true

require_relative 'board'

class Game
  attr_reader :player_marks, :current_player, :board

  def initialize(player_marks = %w[X O], current_player = 0, board = nil)
    @player_marks = player_marks
    @current_player = current_player
    @board = board || Board.new
  end

  def run
    introduction
    loop do
      display_board
      player_turn
      display_board
      break if board.game_over?

      rotate_players!
    end
    game_result
  end

  def rotate_players!
    @current_player = 1 - current_player
  end

  def player_input
    print 'Enter the id of the column you would like to put a mark in: '
    loop do
      input = verified_input
      return input unless input.nil? || board.invalid_column?(input)

      puts 'Input Error!'
    end
  end

  def display_board
    system('clear')

    transformed_grid.each do |row|
      row.each do |cell|
        print to_mark(cell)
      end
      puts
    end
  end

  private

  def verified_input
    input = gets.chomp
    input.to_i if input.match(/^\d+$/)
  end

  def to_mark(id)
    return '.' if id.nil?

    player_marks[id]
  end

  def introduction
    puts 'Welcome to Connect Four!'
  end

  def player_turn
    column_id = player_input
    board.place!(column_id, current_player)
  end

  # Transforms the board grid to adapt to the output format.
  def transformed_grid
    board.grid[0].zip(*board.grid[1..]).reverse
  end

  def game_result
    if board.tie?
      puts "There's finally a tie!"
    else
      puts "Player #{board.winner} wins!"
    end
  end
end
