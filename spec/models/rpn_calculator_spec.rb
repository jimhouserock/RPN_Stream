require 'rails_helper'

# Comprehensive test suite for RPN Calculator
# Author: Jimmy Lin
#
# Tests cover all basic operations, edge cases, error conditions,
# and the specific sample inputs from the requirements.

RSpec.describe RpnCalculator, type: :model do
  describe '.evaluate' do
    context 'with valid basic operations' do
      it 'performs addition correctly' do
        expect(RpnCalculator.evaluate('10 3 +')).to eq(13)
        expect(RpnCalculator.evaluate('5 7 +')).to eq(12)
        expect(RpnCalculator.evaluate('0 0 +')).to eq(0)
      end

      it 'performs subtraction correctly' do
        expect(RpnCalculator.evaluate('10 3 -')).to eq(7)
        expect(RpnCalculator.evaluate('3 10 -')).to eq(-7)
        expect(RpnCalculator.evaluate('5 5 -')).to eq(0)
      end

      it 'performs multiplication correctly' do
        expect(RpnCalculator.evaluate('10 3 *')).to eq(30)
        expect(RpnCalculator.evaluate('4 5 *')).to eq(20)
        expect(RpnCalculator.evaluate('0 10 *')).to eq(0)
      end

      it 'performs division correctly' do
        expect(RpnCalculator.evaluate('10 2 /')).to eq(5.0)
        expect(RpnCalculator.evaluate('15 3 /')).to eq(5.0)
        expect(RpnCalculator.evaluate('7 2 /')).to eq(3.5)
      end

      it 'performs exponentiation correctly' do
        expect(RpnCalculator.evaluate('2 3 ^')).to eq(8)
        expect(RpnCalculator.evaluate('10 2 ^')).to eq(100)
        expect(RpnCalculator.evaluate('5 0 ^')).to eq(1)
        expect(RpnCalculator.evaluate('4 0.5 ^')).to eq(2.0)
      end
    end    # Test cases from the problem statement requirements
    context 'with sample inputs from requirements' do
      it 'evaluates "10 3 +" to 13' do
        expect(RpnCalculator.evaluate('10 3 +')).to eq(13)
      end

      it 'evaluates "10 3 2 + -" to 5' do
        expect(RpnCalculator.evaluate('10 3 2 + -')).to eq(5)
      end

      it 'evaluates "10 3 * 2 ^" to 900' do
        expect(RpnCalculator.evaluate('10 3 * 2 ^')).to eq(900)
      end
    end

    context 'with complex expressions' do
      it 'handles multiple operations in sequence' do
        expect(RpnCalculator.evaluate('15 7 1 1 + - / 3 * 2 1 1 + + -')).to eq(5)
        expect(RpnCalculator.evaluate('1 2 + 3 4 + *')).to eq(21) # (1+2) * (3+4) = 3 * 7 = 21
      end

      it 'handles nested calculations' do
        expect(RpnCalculator.evaluate('2 3 + 4 5 + *')).to eq(45) # (2+3) * (4+5) = 5 * 9 = 45
        expect(RpnCalculator.evaluate('10 5 / 2 +')).to eq(4.0) # 10/5 + 2 = 2 + 2 = 4
      end
    end

    context 'with negative numbers' do
      it 'handles negative operands correctly' do
        expect(RpnCalculator.evaluate('-5 3 +')).to eq(-2)
        expect(RpnCalculator.evaluate('5 -3 +')).to eq(2)
        expect(RpnCalculator.evaluate('-5 -3 +')).to eq(-8)
        expect(RpnCalculator.evaluate('-10 2 /')).to eq(-5.0)
      end
    end

    context 'with floating-point numbers' do
      it 'handles decimal numbers correctly' do
        expect(RpnCalculator.evaluate('3.5 2.5 +')).to eq(6.0)
        expect(RpnCalculator.evaluate('10.5 2 /')).to eq(5.25)
        expect(RpnCalculator.evaluate('1.5 2.0 *')).to eq(3.0)
      end
    end

    context 'with single numbers' do
      it 'returns the number itself' do
        expect(RpnCalculator.evaluate('42')).to eq(42)
        expect(RpnCalculator.evaluate('3.14')).to eq(3.14)
        expect(RpnCalculator.evaluate('-7')).to eq(-7)
      end
    end

    context 'with error conditions' do
      it 'raises error for division by zero' do
        expect { RpnCalculator.evaluate('5 0 /') }.to raise_error(RpnCalculator::RpnError, 'Division by zero')
        expect { RpnCalculator.evaluate('10 5 5 - /') }.to raise_error(RpnCalculator::RpnError, 'Division by zero')
      end

      it 'raises error for insufficient operands' do
        expect { RpnCalculator.evaluate('5 +') }.to raise_error(RpnCalculator::RpnError, "Insufficient operands for operator '+'")
        expect { RpnCalculator.evaluate('+') }.to raise_error(RpnCalculator::RpnError, "Insufficient operands for operator '+'")
        expect { RpnCalculator.evaluate('5 6 + +') }.to raise_error(RpnCalculator::RpnError, "Insufficient operands for operator '+'")
      end

      it 'raises error for too many operands' do
        expect { RpnCalculator.evaluate('1 2 3 +') }.to raise_error(RpnCalculator::RpnError, 'Invalid expression: too many operands (2 remaining)')
        expect { RpnCalculator.evaluate('1 2 3 4 + +') }.to raise_error(RpnCalculator::RpnError, 'Invalid expression: too many operands (2 remaining)')
      end

      it 'raises error for invalid tokens' do
        expect { RpnCalculator.evaluate('5 a +') }.to raise_error(RpnCalculator::RpnError, "Invalid token: 'a'")
        expect { RpnCalculator.evaluate('5 6 %') }.to raise_error(RpnCalculator::RpnError, "Invalid token: '%'")
        expect { RpnCalculator.evaluate('hello world') }.to raise_error(RpnCalculator::RpnError, "Invalid token: 'hello'")
      end

      it 'raises error for invalid exponentiation' do
        expect { RpnCalculator.evaluate('0 -1 ^') }.to raise_error(RpnCalculator::RpnError, 'Cannot raise zero to a negative power')
      end
    end

    context 'with edge cases' do
      it 'handles empty or nil input' do
        expect(RpnCalculator.evaluate('')).to eq(0)
        expect(RpnCalculator.evaluate('   ')).to eq(0)
        expect(RpnCalculator.evaluate(nil)).to eq(0)
      end

      it 'handles extra whitespace' do
        expect(RpnCalculator.evaluate('  10   3   +  ')).to eq(13)
        expect(RpnCalculator.evaluate('5    7    *')).to eq(35)
      end

      it 'handles zero values correctly' do
        expect(RpnCalculator.evaluate('0')).to eq(0)
        expect(RpnCalculator.evaluate('0 5 +')).to eq(5)
        expect(RpnCalculator.evaluate('5 0 -')).to eq(5)
        expect(RpnCalculator.evaluate('0 5 *')).to eq(0)
      end

      it 'handles large numbers correctly' do
        expect(RpnCalculator.evaluate('1000000 2000000 +')).to eq(3000000)
        expect(RpnCalculator.evaluate('999 1000 *')).to eq(999000)
      end

      it 'handles very small decimal numbers' do
        expect(RpnCalculator.evaluate('0.001 0.002 +')).to be_within(0.0001).of(0.003)
        expect(RpnCalculator.evaluate('0.1 0.2 +')).to be_within(0.0001).of(0.3)
      end

      it 'handles expressions from streaming data examples' do
        expect(RpnCalculator.evaluate('5 2 * 3 +')).to eq(13)  # (5 * 2) + 3
        expect(RpnCalculator.evaluate('3 2 ^ 1 +')).to eq(10)  # (3^2) + 1
        expect(RpnCalculator.evaluate('7 3 + 2 *')).to eq(20)  # (7 + 3) * 2
      end
    end
  end
end