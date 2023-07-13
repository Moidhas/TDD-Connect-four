# frozen_string_literal: true
# rubocop: disable Metrics/BlockLength

require_relative '../lib/board'

describe Board do
  let(:p1) { instance_double(Player, id: 0) }
  let(:p2) { instance_double(Player, id: 1) }
  describe '#update_board' do
    context 'When column is not full' do
      subject(:empty_board) { described_class.new(p1, p2) }
      it 'updates board at col 0 with the correct ids' do
        allow(p1).to receive(:input_position).and_return(0)
        expect { empty_board.update_board(p1) }.to change { empty_board.instance_variable_get(:@state) }.to(
          [[0] + [nil] * 5,
           [nil] * 6,
           [nil] * 6,
           [nil] * 6,
           [nil] * 6,
           [nil] * 6,
           [nil] * 6]
        )
      end

      it 'stacks if col already has a piece in it' do
        allow(p1).to receive(:input_position).and_return(0)
        allow(p2).to receive(:input_position).and_return(0)
        empty_board.update_board(p1)
        expect { empty_board.update_board(p2) }.to change { empty_board.instance_variable_get(:@state) }.to([
            [0, 1] + [nil] * 4,
            [nil] * 6,
            [nil] * 6,
            [nil] * 6,
            [nil] * 6,
            [nil] * 6,
            [nil] * 6
        ])
      end

      context 'When checking for message sent' do
        before(:each) do
          allow(p1).to receive(:input_position).and_return(0)
        end

        it 'sends id to p1 once' do
          expect(p1).to receive(:id).once
          empty_board.update_board(p1)
        end

        it 'sends input_position to p1 once' do
          expect(p1).to receive(:input_position).once
          empty_board.update_board(p1)
        end
      end
    end

    context 'When column is full' do
      let(:full_col) { [[0] * 6, [nil] * 6, [nil] * 6, [nil] * 6, [nil] * 6, [nil] * 6, [nil] * 6] }
      subject(:full_board) { described_class.new(p1, p2, full_col) }

      it 'sends input_position to p2 twice' do
        allow(p2).to receive(:input_position).and_return(0, 1)
        expect(p2).to receive(:input_position).twice
        full_board.update_board(p2)
      end

      it 'sends input_position to p1 5 times' do
        allow(p1).to receive(:input_position).and_return(0, 0, 0, 0, 1)
        expect(p1).to receive(:input_position).exactly(5).times
        full_board.update_board(p1)
      end
    end
  end

  describe '#game_over?' do
    context 'When there are 4 of the same pieces in a col' do
      let(:four_col) { [[nil, 0, 0, 0, 0, nil], [nil] * 6, [nil] * 6, [nil] * 6, [nil] * 6, [nil] * 6, [nil] * 6] }
      subject(:end_col_game) { described_class.new(p1, p2, four_col) }
      it 'returns true' do
        expect(end_col_game).to be_game_over(p1)
      end

      context 'if player id is not 4 in a col' do
        it 'returns false' do
          expect(end_col_game).not_to be_game_over(p2)
        end
      end
    end

    context 'When there are 4 of the same pieces in a row' do
      let(:four_row) { [0] + [nil] * 5 }
      subject(:end_row_game) { described_class.new(p1, p2, Array.new(7) { four_row }) }

      it 'returns true' do
        expect(end_row_game).to be_game_over(p1)
      end

      context 'if player id is not 4 in a row' do
        it 'returns false' do
          expect(end_row_game).not_to be_game_over(p2)
        end
      end
    end

    context 'when the diagonal entries allow player to win' do
      let(:four_diagonal) do
        [[0, nil, nil, nil, nil, nil],
         [nil, 0, nil, nil, nil, nil],
         [nil, nil, 0, nil, nil, nil],
         [nil, nil, nil, 0, nil, nil],
         [nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil]]
      end

      subject(:diag_game) { described_class.new(p1, p2, four_diagonal) }

      it 'returns true' do
        expect(diag_game).to be_game_over(p1)
      end

      it 'returns false for the wrong id' do
        expect(diag_game).not_to be_game_over(p2)
      end
    end

    context 'Diagonal Case 2' do
      let(:four_diagonal) do
        [[nil, nil, nil, nil, nil, nil],
         [0, nil, nil, nil, nil, nil],
         [nil, 0, nil, nil, nil, nil],
         [nil, nil, 0, nil, nil, nil],
         [nil, nil, nil, 0, nil, nil],
         [nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil]]
      end

      subject(:diag_game) { described_class.new(p1, p2, four_diagonal) }

      it 'returns true' do
        expect(diag_game).to be_game_over(p1)
      end

      it 'returns false for the wrong id' do
        expect(diag_game).not_to be_game_over(p2)
      end
    end

    context 'Diagonal Case 3' do
      let(:four_diagonal) do
        [[nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil],
         [0, nil, nil, nil, nil, nil],
         [nil, 0, nil, nil, nil, nil],
         [nil, nil, 0, nil, nil, nil],
         [nil, nil, nil, 0, nil, nil],
         [nil, nil, nil, nil, nil, nil]]
      end

      subject(:diag_game) { described_class.new(p1, p2, four_diagonal) }

      it 'returns true' do
        expect(diag_game).to be_game_over(p1)
      end

      it 'returns false for the wrong id' do
        expect(diag_game).not_to be_game_over(p2)
      end
    end

    context 'Diagonal Case 4' do
      let(:four_diagonal) do
        [[nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil],
         [0, nil, nil, nil, nil, nil],
         [nil, 0, nil, nil, nil, nil],
         [nil, nil, 0, nil, nil, nil],
         [nil, nil, nil, 0, nil, nil]]
      end

      subject(:diag_game) { described_class.new(p1, p2, four_diagonal) }

      it 'returns true' do
        expect(diag_game).to be_game_over(p1)
      end

      it 'returns false for the wrong id' do
        expect(diag_game).not_to be_game_over(p2)
      end
    end

    context 'Diagonal Case 5' do
      let(:four_diagonal) do
        [[nil, 0, nil, nil, nil, nil],
         [nil, nil, 0, nil, nil, nil],
         [nil, nil, nil, 0, nil, nil],
         [nil, nil, nil, nil, 0, nil],
         [nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil]]
      end

      subject(:diag_game) { described_class.new(p1, p2, four_diagonal) }

      it 'returns true' do
        expect(diag_game).to be_game_over(p1)
      end

      it 'returns false for the wrong id' do
        expect(diag_game).not_to be_game_over(p2)
      end
    end

    context 'Diagonal Case 6' do
      let(:four_diagonal) do
        [[nil, nil, 0, nil, nil, nil],
         [nil, nil, nil, 0, nil, nil],
         [nil, nil, nil, nil, 0, nil],
         [nil, nil, nil, nil, nil, 0],
         [nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil]]
      end

      subject(:diag_game) { described_class.new(p1, p2, four_diagonal) }

      it 'returns true' do
        expect(diag_game).to be_game_over(p1)
      end

      it 'returns false for the wrong id' do
        expect(diag_game).not_to be_game_over(p2)
      end
    end

    context 'Final Diagonal Case' do
      let(:four_diagonal) do
        [[nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, 0, nil, nil],
         [nil, nil, 0, nil, nil, nil],
         [nil, 0, nil, nil, nil, nil],
         [0, nil, nil, nil, nil, nil]]
      end

      subject(:diag_game) { described_class.new(p1, p2, four_diagonal) }

      it 'returns true' do
        expect(diag_game).to be_game_over(p1)
      end

      it 'returns false for the wrong id' do
        expect(diag_game).not_to be_game_over(p2)
      end
    end
  end
end
