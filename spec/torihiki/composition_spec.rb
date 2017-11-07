require "spec_helper"

RSpec.describe Torihiki::Composition do
  it { expect(subject.instance_variable_get(:@composition).frozen?).to be_truthy }
  it { is_expected.to respond_to :map }
  it { is_expected.to respond_to :call }

  context 'with lambdas' do
    let(:io) do
      subject
        .map(->(num) { num + 2 })
        .map(->(sum) { sum * 2 })
    end

    describe '#map' do
      it 'returns new object' do
        expect(io).not_to eq subject
      end

      it 'returns object with expanded composition' do
        expect(subject.instance_variable_get(:@composition).size).to be_zero
        expect(io.instance_variable_get(:@composition).size).to eq 2
      end
    end

    describe '#call' do
      it 'does all the calculation through the composition' do
        expect(io.call(0)).to eq 4
        expect(io.call(1)).to eq 6
        expect(io.call(2)).to eq 8
      end
    end
  end

  context 'with procs' do
    let(:io) do
      subject
        .map(proc { |num| num + 2 })
        .map(proc { |sum| sum * 2 })
    end

    describe '#map' do
      it 'returns new object' do
        expect(io).not_to eq subject
      end

      it 'returns object with expanded composition' do
        expect(subject.instance_variable_get(:@composition).size).to be_zero
        expect(io.instance_variable_get(:@composition).size).to eq 2
      end
    end

    describe '#call' do
      it 'does all the calculation through the composition' do
        expect(io.call(0)).to eq 4
        expect(io.call(1)).to eq 6
        expect(io.call(2)).to eq 8
      end
    end
  end

  context 'with blocks' do
    let(:io) do
      subject
        .map { |num| num + 2 }
        .map { |sum| sum * 2 }
    end

    describe '#map' do
      it 'returns new object' do
        expect(io).not_to eq subject
      end

      it 'returns object with expanded composition' do
        expect(subject.instance_variable_get(:@composition).size).to be_zero
        expect(io.instance_variable_get(:@composition).size).to eq 2
      end
    end

    describe '#call' do
      it 'does all the calculation through the composition' do
        expect(io.call(0)).to eq 4
        expect(io.call(1)).to eq 6
        expect(io.call(2)).to eq 8
      end
    end
  end

  context 'with callable' do
    module Callable
      class A
        def call(context)
          context + 2
        end
      end

      module B
        def self.call(context)
          context * 2
        end
      end
    end

    let(:io) do
      subject
        .map(Callable::A.new)
        .map(Callable::B)
    end

    describe '#map' do
      it 'returns new object' do
        expect(io).not_to eq subject
      end

      it 'returns object with expanded composition' do
        expect(subject.instance_variable_get(:@composition).size).to be_zero
        expect(io.instance_variable_get(:@composition).size).to eq 2
      end
    end

    describe '#call' do
      it 'does all the calculation through the composition' do
        expect(io.call(0)).to eq 4
        expect(io.call(1)).to eq 6
        expect(io.call(2)).to eq 8
      end
    end
  end

  context 'with noncallable' do
    module Noncallable; end

    let(:io) do
      subject.map(Noncallable)
    end

    describe '#map' do
      it 'raises an error' do
        expect { io }.to raise_error(
          Torihiki::ComposedNonCallableError,
          'Composition recieved a function which does not respond to method call'
        )
      end
    end
  end
end
