# frozen_string_literal: true
# rubocop:disable Metrics/BlockLength

require_relative '../lib/player'

describe Player do
  subject(:player) { described_class.new }

  describe '#input_position' do
    context 'when input is out of range' do
      before(:each) do
        out_of_range = 7
        in_range = 5
        allow(player).to receive(:input_troubles).and_return(out_of_range, in_range)
      end

      it 'loops until it gets a valid input' do
        expect(player).to receive(:input_troubles).twice
        player.input_position
      end

      it 'returns the first valid input' do
        result = player.input_position
        expect(result).to eq(5)
      end
    end
  end

  describe '#input_troubles' do
    before(:each) do
      allow(player).to receive(:print)
    end

    context 'when input is not a number' do
      before(:each) do
        allow(player).to receive(:puts)
      end

      it 'returns -1 for letters' do
        letter = 'a'
        allow(player).to receive(:gets).and_return(letter)
        result = player.input_troubles
        expect(result).to eq(-1)
      end

      it 'returns -1 for things similar to numbers' do
        similar = '1,2'
        allow(player).to receive(:gets).and_return(similar)
        result = player.input_troubles
        expect(result).to eq(-1)
      end
    end

    context 'when input is a number' do
      it 'returns that number' do
        number = '0'
        allow(player).to receive(:gets).and_return(number)
        result = player.input_troubles
        expect(result).to eq(0)
      end

      it 'returns that number' do
        number = '9'
        allow(player).to receive(:gets).and_return(number)
        result = player.input_troubles
        expect(result).to eq(9)
      end
    end
  end
end
