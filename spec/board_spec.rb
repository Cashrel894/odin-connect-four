# frozen_string_literal: true

require_relative '../lib/board'

describe Board do
  describe '#initialize' do
    context 'when using default initialization' do
      subject(:default_board) { described_class.new }

      it 'is 7 cells wide' do
        expect(default_board.width).to eq(7)
      end

      it 'is 6 cells high' do
        expect(default_board.height).to eq(6)
      end

      it 'creates an empty 6 * 7 grid' do
        expected_grid = [[nil] * 6] * 7
        expect(default_board.grid).to eq(expected_grid)
      end
    end

    context 'when specifying the width(8) and height(5) of the board' do
      subject(:custom_board) { described_class.new(8, 5) }

      it 'is 8 cells wide' do
        expect(custom_board.width).to eq(8)
      end

      it 'is 5 cells high' do
        expect(custom_board.height).to eq(5)
      end

      it 'creates an empty 5 * 8 grid' do
        expected_grid = [[nil] * 5] * 8
        expect(custom_board.grid).to eq(expected_grid)
      end
    end

    context 'when specifying the grid of the board' do
      let(:grid) { [[0, nil, nil, nil], [1, 1, nil, nil], [0, 0, nil, nil]] }
      subject(:grid_board) { described_class.new(3, 4, grid) }

      it 'is 3 cells wide' do
        expect(grid_board.width).to eq(3)
      end

      it 'is 4 cells high' do
        expect(grid_board.height).to eq(4)
      end

      it 'has the specific grid' do
        expect(grid_board.grid).to eq(grid)
      end
    end
  end

  describe '#invalid_column?' do
    let(:grid) do
      [
        [0, 1, 0, nil, nil],
        [1, 1, 1, 0, 0]
      ]
    end
    subject(:validation_board) { described_class.new(2, 5, grid) }

    context 'when the specified column is valid' do
      it 'returns false' do
        expect(validation_board.invalid_column?(0)).to be(false)
      end
    end

    context 'when the specified column is invalid(full)' do
      it 'returns true' do
        expect(validation_board.invalid_column?(1)).to be(true)
      end
    end

    context 'when the specific column is out of range' do
      it 'returns true if given a integer that is not between 0 and (width - 1)' do
        expect(validation_board.invalid_column?(-1)).to be(true)
        expect(validation_board.invalid_column?(2)).to be(true)
      end
    end
  end

  describe '#place!' do
    context 'when the specific column is empty' do
      let(:grid) do
        [
          [nil, nil, nil, nil]
        ]
      end
      subject(:place_board) { described_class.new(1, 4, grid) }

      let(:expected_grid) do
        [
          [1, nil, nil, nil]
        ]
      end

      it "puts the specific player's mark at the bottom" do
        expect { place_board.place!(0, 1) }.to change { place_board.grid }.to expected_grid
      end
    end

    context 'when the specific column is not empty' do
      let(:grid) do
        [
          [0, 1, nil, nil]
        ]
      end
      subject(:place_board) { described_class.new(1, 4, grid) }

      let(:expected_grid) do
        [
          [0, 1, 0, nil]
        ]
      end

      it 'stacks the mark on top of other existing marks' do
        expect { place_board.place!(0, 0) }.to change { place_board.grid }.to expected_grid
      end
    end
  end

  describe '#tie?' do
    context "when there's indeed a tie" do
      let(:grid) do
        [
          [1, 1, 0, 0, 1, 1],
          [0, 0, 1, 1, 0, 0],
          [1, 1, 0, 0, 1, 1],
          [0, 0, 1, 1, 0, 0],
          [1, 1, 0, 0, 1, 1],
          [0, 0, 1, 1, 0, 0],
          [1, 1, 0, 0, 1, 1]
        ]
      end
      subject(:tie_board) { described_class.new(7, 6, grid) }

      it 'returns true' do
        expect(tie_board).to be_tie
      end
    end

    context "when the game's not over" do
      let(:grid) do
        [
          [1, 1, 0, nil, nil, nil],
          [0, 0, 1, 1, 0, 0],
          [1, 1, 0, 0, nil, nil],
          [0, 0, 1, 1, 0, nil],
          [1, 1, 0, 0, 1, 1],
          [0, 0, nil, nil, nil, nil],
          [1, 1, 0, 0, 1, 1]
        ]
      end
      subject(:not_over_board) { described_class.new(7, 6, grid) }

      it 'returns false' do
        expect(not_over_board).not_to be_tie
      end
    end

    context "when there's a winner" do
      let(:grid) do
        [
          [1, 1, 1, 1, nil, nil],
          [0, 0, 1, 1, 0, 0],
          [1, 1, 0, 0, nil, nil],
          [0, 0, 1, 1, 0, nil],
          [1, 1, 0, 0, 1, 1],
          [0, 0, nil, nil, nil, nil],
          [1, 1, 0, 0, 1, 1]
        ]
      end
      subject(:winner_board) { described_class.new(7, 6, grid) }

      it 'returns false' do
        expect(winner_board).not_to be_tie
      end
    end
  end

  describe '#game_over?' do
    context "when the game's not over" do
      let(:grid) do
        [
          [1, 1, 0, nil, nil, nil],
          [0, 0, 1, 1, 0, 0],
          [1, 1, 0, 0, nil, nil],
          [0, 0, 1, 1, 0, nil],
          [1, 1, 0, 0, 1, 1],
          [0, 0, nil, nil, nil, nil],
          [1, 1, 0, 0, 1, 1]
        ]
      end
      subject(:not_over_board) { described_class.new(7, 6, grid) }

      it 'returns false' do
        expect(not_over_board).not_to be_game_over
      end
    end

    context "when there's a tie" do
      let(:grid) do
        [
          [1, 1, 0, 0, 1, 1],
          [0, 0, 1, 1, 0, 0],
          [1, 1, 0, 0, 1, 1],
          [0, 0, 1, 1, 0, 0],
          [1, 1, 0, 0, 1, 1],
          [0, 0, 1, 1, 0, 0],
          [1, 1, 0, 0, 1, 1]
        ]
      end
      subject(:tie_board) { described_class.new(7, 6, grid) }

      it 'returns true' do
        expect(tie_board).to be_game_over
      end
    end

    context "when there's a winner" do
      let(:grid) do
        [
          [1, 0, 0, nil, nil, nil],
          [1, 0, 1, 1, 0, 0],
          [1, 1, 0, 0, nil, nil],
          [1, 0, 1, 1, 0, nil],
          [0, 1, 0, 0, 1, 1],
          [0, 0, nil, nil, nil, nil],
          [1, 1, 0, 0, 1, 1]
        ]
      end
      subject(:winner_board) { described_class.new(7, 6, grid) }

      it 'returns true' do
        expect(winner_board).to be_game_over
      end
    end
  end

  describe '#winner' do
    context 'when the first player wins' do
      let(:grid) do
        [
          [0, 1, 1, 1, nil, nil],
          [0, 0, 1, 1, 0, 0],
          [1, 1, 0, 0, nil, nil],
          [0, 0, 1, 0, 0, nil],
          [1, 1, 0, 0, 1, 1],
          [0, 0, nil, nil, nil, nil],
          [1, 1, 0, 0, 1, 1]
        ]
      end
      subject(:winner_board) { described_class.new(7, 6, grid) }

      it 'returns 0' do
        expect(winner_board.winner).to eq(0)
      end
    end

    context 'when the second player wins' do
      let(:grid) do
        [
          [1, 0, 0, nil, nil, nil],
          [1, 0, 1, 1, 0, 0],
          [1, 1, 0, 0, nil, nil],
          [1, 0, 1, 1, 0, nil],
          [0, 1, 0, 0, 1, 1],
          [0, 0, nil, nil, nil, nil],
          [1, 1, 0, 0, 1, 1]
        ]
      end
      subject(:winner_board) { described_class.new(7, 6, grid) }

      it 'returns 1' do
        expect(winner_board.winner).to eq(1)
      end
    end
  end
end
