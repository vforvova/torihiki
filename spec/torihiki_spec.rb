require "spec_helper"

RSpec.describe Torihiki do
  it "has a version number" do
    expect(Torihiki::VERSION).not_to be nil
  end

  context 'when included' do
    class TransactionClass
      include Torihiki
    end

    subject { TransactionClass }

    it { is_expected.to respond_to :map }
    it { is_expected.to respond_to :call }

    describe 'operation inside' do
      class A < TransactionClass
        map ->(context) { context * 2 }
      end

      it 'returns expected value' do
        expect(A.call(1)).to eq 2
      end

      it 'contains one operation' do
        composition = A.send(:io).instance_variable_get(:@composition)
        expect(composition.size).to eq 1
      end
    end

    describe 'operation as pipeline' do
      class B < TransactionClass
        map ->(context) { context * 2 }
      end
      B.map ->(context) { context * 3 }

      it 'returns correct result' do
        expect(B.call(1)).to eq 6
      end

      it 'contains three operations' do
        composition = B.send(:io).instance_variable_get(:@composition)
        expect(composition.size).to eq 2
      end
    end

    describe 'handler registration' do
      class C < TransactionClass
        def self.tap(input)
          map ->(context) { input.call(context); context; }
        end

        tap ->(context) { context * 2 }
      end

      it 'returns correct result' do
        expect(C.call(1)).to eq 1
      end
    end
  end
end
