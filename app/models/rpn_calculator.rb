# RPN Calculator Model
# Author: Jimmy Lin
#
# Implements Reverse Polish Notation (RPN) evaluation algorithm using stack-based processing.
# RPN eliminates parentheses and operator precedence, making it ideal for data engineering
# applications including expression parsing, compiler design, and computational systems.
#
# Algorithm: O(n) time complexity, O(n) space complexity
# 1. Tokenize expression into numbers and operators
# 2. Process left-to-right: numbers → stack, operators → pop/compute/push
# 3. Validate single result remains

class RpnCalculator
  # Supported operators with their corresponding operations
  OPERATORS = {
    '+' => :add,
    '-' => :subtract,
    '*' => :multiply,
    '/' => :divide,
    '^' => :exponentiate
  }.freeze

  # Custom exception for RPN calculation errors
  class RpnError < StandardError; end

  # Evaluates a Reverse Polish Notation expression
  # @param expression [String] The RPN expression to evaluate (e.g., "10 3 +")
  # @return [Numeric] The calculated result
  # @raise [RpnError] If the expression is invalid or contains errors
  def self.evaluate(expression)
    return 0 if expression.nil? || expression.strip.empty?

    tokens = tokenize(expression)
    stack = []

    tokens.each do |token|
      if number?(token)
        stack.push(parse_number(token))
      elsif operator?(token)
        perform_operation(stack, token)
      else
        raise RpnError, "Invalid token: '#{token}'"
      end
    end

    validate_final_result(stack)
  end

  private

  # Tokenizes the input expression into individual elements
  # @param expression [String] The input expression
  # @return [Array<String>] Array of tokens (numbers and operators)
  def self.tokenize(expression)
    expression.strip.split(/\s+/)
  end

  # Checks if a token represents a number (including negative numbers)
  # @param token [String] The token to check
  # @return [Boolean] True if the token is a valid number
  def self.number?(token)
    # Matches integers and floating-point numbers (positive and negative)
    token.match?(/\A-?\d+(\.\d+)?\z/)
  end

  # Checks if a token is a supported operator
  # @param token [String] The token to check
  # @return [Boolean] True if the token is a supported operator
  def self.operator?(token)
    OPERATORS.key?(token)
  end

  # Parses a string token into a numeric value
  # @param token [String] The numeric token
  # @return [Numeric] The parsed number (Integer or Float)
  def self.parse_number(token)
    token.include?('.') ? token.to_f : token.to_i
  end

  # Performs the specified operation on the stack
  # @param stack [Array] The operand stack
  # @param operator [String] The operator to apply
  # @raise [RpnError] If there are insufficient operands
  def self.perform_operation(stack, operator)
    raise RpnError, "Insufficient operands for operator '#{operator}'" if stack.size < 2

    # Pop operands in reverse order (second operand first, then first operand)
    operand2 = stack.pop
    operand1 = stack.pop

    result = case operator
             when '+'
               operand1 + operand2
             when '-'
               operand1 - operand2
             when '*'
               operand1 * operand2
             when '/'
               divide_with_validation(operand1, operand2)
             when '^'
               exponentiate_with_validation(operand1, operand2)
             end

    stack.push(result)
  end

  # Performs division with zero-division validation
  # @param dividend [Numeric] The number to be divided
  # @param divisor [Numeric] The number to divide by
  # @return [Numeric] The division result
  # @raise [RpnError] If division by zero is attempted
  def self.divide_with_validation(dividend, divisor)
    raise RpnError, "Division by zero" if divisor.zero?

    dividend.to_f / divisor
  end

  # Performs exponentiation with validation for edge cases
  # @param base [Numeric] The base number
  # @param exponent [Numeric] The exponent
  # @return [Numeric] The exponentiation result
  # @raise [RpnError] If the operation results in invalid values
  def self.exponentiate_with_validation(base, exponent)
    # Handle special cases
    if base.zero? && exponent < 0
      raise RpnError, "Cannot raise zero to a negative power"
    end

    result = base ** exponent

    # Check for overflow or invalid results (only for Float results)
    if result.is_a?(Float)
      if result.infinite?
        raise RpnError, "Result too large (overflow)"
      elsif result.nan?
        raise RpnError, "Invalid mathematical operation"
      end
    end

    result
  end

  # Validates that the final result is correct (exactly one value in stack)
  # @param stack [Array] The final stack after evaluation
  # @return [Numeric] The final result
  # @raise [RpnError] If the stack doesn't contain exactly one result
  def self.validate_final_result(stack)
    case stack.size
    when 0
      raise RpnError, "No result calculated (empty expression)"
    when 1
      stack.first
    else
      raise RpnError, "Invalid expression: too many operands (#{stack.size} remaining)"
    end
  end
end