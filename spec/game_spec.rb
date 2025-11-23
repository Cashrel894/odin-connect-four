# frozen_string_literal: true

require_relative '../lib/game'
require_relative '../lib/board'

describe Game do
  describe '#initialize' do
    # No need to test because it only does attribute bindings.
  end

  describe '#run' do
    # I don't know how to test this method qwq.
  end

  describe '#rotate_players!' do
    context 'when the current player is the first one' do
      subject(:rotate_game) { described_class.new(%w[X O], 0) }

      it 'makes the second one be the current player' do
        expect { rotate_game.rotate_players! }.to change { rotate_game.current_player }.to(1)
      end
    end

    context 'when the current player is the second one' do
      subject(:rotate_game) { described_class.new(%w[X O], 1) }

      it 'makes the first one be the current player' do
        expect { rotate_game.rotate_players! }.to change { rotate_game.current_player }.to(0)
      end
    end
  end

  describe '#player_input' do
    subject(:input_game) { described_class.new }
    let(:error_msg) { 'Input Error!' }

    context 'when given a valid input' do
      before do
        allow(input_game).to receive(:gets).and_return('2')
      end

      it 'returns the corresponding column id' do
        expect(input_game.player_input).to eql(2)
      end

      it 'does not display error message' do
        expect(input_game).not_to receive(:puts).with(error_msg)
        input_game.player_input
      end
    end

    context 'when first given an invalid input, then a valid one' do
      before do
        allow(input_game).to receive(:gets).and_return('100', '2')
      end

      it 'finally returns the valid column id' do
        expect(input_game.player_input).to eql(2)
      end

      it 'displays error message once' do
        expect(input_game).to receive(:puts).with(error_msg).once
        input_game.player_input
      end
    end

    context 'when first given 5 invalid inputs, then a valid one' do
      before do
        allow(input_game).to receive(:gets).and_return('100', '-5', 'wow', '5star', "\n", '2')
      end

      it 'finally returns the valid column id' do
        expect(input_game.player_input).to eql(2)
      end

      it 'displays error message five times' do
        expect(input_game).to receive(:puts).with(error_msg).exactly(5)
        input_game.player_input
      end
    end
  end

  describe '#display_board' do
    let(:board) { instance_double(Board) }
    let(:grid) do
      [
        [1, 0, 0],
        [0, nil, nil],
        [1, 1, nil]
      ]
    end
    before do
      allow(board).to receive(:grid).and_return(grid)
    end

    context 'when using default player marks' do
      subject(:display_game) { described_class.new(%w[X O], 0, board) }

      it 'prints the board in appropriate format' do
        board_string = "X..\nX.O\nOXO\n"
        expect { display_game.display_board }.to output(board_string).to_stdout
      end
    end

    context 'when using custom player marks' do
      subject(:display_game) { described_class.new(%w[0 1], 0, board) }

      it 'prints the board in appropriate format' do
        board_string = "0..\n0.1\n101\n"
        expect { display_game.display_board }.to output(board_string).to_stdout
      end
    end
  end
end
