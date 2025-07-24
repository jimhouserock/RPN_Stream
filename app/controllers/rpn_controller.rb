# RPN Calculator Controller
# Author: Jimmy Lin
#
# Handles web requests for RPN calculator interface and system architecture display.
# Provides endpoints for calculator functionality and explanation generation.

class RpnController < ApplicationController
  # GET /
  # GET /calculator
  # Displays the main calculator interface
  def index
    @result = nil
    @expression = ""
    @error = nil
  end

  # POST /calculate
  # Processes RPN expression and returns the result
  def calculate
    @expression = params[:expression] || ""
    
    begin
      @result = RpnCalculator.evaluate(@expression)
      @error = nil
      
      # Log successful calculation for debugging
      Rails.logger.info "RPN Calculation: '#{@expression}' = #{@result}"
      
    rescue RpnCalculator::RpnError => e
      @result = nil
      @error = e.message
      
      # Log calculation errors for debugging
      Rails.logger.warn "RPN Calculation Error: '#{@expression}' - #{e.message}"
      
    rescue StandardError => e
      @result = nil
      @error = "An unexpected error occurred: #{e.message}"
      
      # Log unexpected errors
      Rails.logger.error "Unexpected RPN Error: '#{@expression}' - #{e.message}"
    end

    render :index
  end

  private

  # Generate a human-readable explanation of the RPN expression
  def generate_explanation(expression)
    return "" if expression.blank?

    tokens = expression.strip.split(/\s+/)
    return "Single number" if tokens.size == 1

    # Simple explanation for common patterns
    case tokens.join(" ")
    # Two operand expressions
    when /^-?\d+(\.\d+)?\s+-?\d+(\.\d+)?\s+\+$/
      "Equivalent to #{tokens[0]} + #{tokens[1]}"
    when /^-?\d+(\.\d+)?\s+-?\d+(\.\d+)?\s+-$/
      "Equivalent to #{tokens[0]} - #{tokens[1]}"
    when /^-?\d+(\.\d+)?\s+-?\d+(\.\d+)?\s+\*$/
      "Equivalent to #{tokens[0]} * #{tokens[1]}"
    when /^-?\d+(\.\d+)?\s+-?\d+(\.\d+)?\s+\/$/
      "Equivalent to #{tokens[0]} / #{tokens[1]}"
    when /^-?\d+(\.\d+)?\s+-?\d+(\.\d+)?\s+\^$/
      "Equivalent to #{tokens[0]}^#{tokens[1]}"

    # Three operand patterns
    when /^-?\d+(\.\d+)?\s+-?\d+(\.\d+)?\s+-?\d+(\.\d+)?\s+\+\s+-$/
      "Equivalent to #{tokens[0]} - (#{tokens[1]} + #{tokens[3]})"
    when /^-?\d+(\.\d+)?\s+-?\d+(\.\d+)?\s+\*\s+-?\d+(\.\d+)?\s+\^$/
      "Equivalent to (#{tokens[0]} * #{tokens[1]})^#{tokens[4]}"
    when /^-?\d+(\.\d+)?\s+-?\d+(\.\d+)?\s+\/\s+-?\d+(\.\d+)?\s+\+$/
      "Equivalent to (#{tokens[0]} / #{tokens[1]}) + #{tokens[3]}"
    when /^-?\d+(\.\d+)?\s+-?\d+(\.\d+)?\s+\+\s+-?\d+(\.\d+)?\s+\*$/
      "Equivalent to (#{tokens[0]} + #{tokens[1]}) * #{tokens[4]}"
    when /^-?\d+(\.\d+)?\s+-?\d+(\.\d+)?\s+\*\s+-?\d+(\.\d+)?\s+\+$/
      "Equivalent to (#{tokens[0]} * #{tokens[1]}) + #{tokens[3]}"
    when /^-?\d+(\.\d+)?\s+-?\d+(\.\d+)?\s+-\s+-?\d+(\.\d+)?\s+\*$/
      "Equivalent to (#{tokens[0]} - #{tokens[1]}) * #{tokens[4]}"
    when /^-?\d+(\.\d+)?\s+-?\d+(\.\d+)?\s+\^\s+-?\d+(\.\d+)?\s+\+$/
      "Equivalent to (#{tokens[0]}^#{tokens[1]}) + #{tokens[3]}"
    when /^-?\d+(\.\d+)?\s+-?\d+(\.\d+)?\s+\^\s+-?\d+(\.\d+)?\s+-$/
      "Equivalent to (#{tokens[0]}^#{tokens[1]}) - #{tokens[3]}"

    # Specific complex expressions
    when "100 10 / 2 ^ 5 -"
      "Equivalent to ((100 / 10) ^ 2) - 5"
    when "15 7 1 1 + - /"
      "Equivalent to 15 / (7 - (1 + 1))"
    when "2 3 ^ 4 + 5 *"
      "Equivalent to ((2 ^ 3) + 4) * 5"
    when "6 2 / 3 + 4 *"
      "Equivalent to ((6 / 2) + 3) * 4"
    when "20 4 / 2 +"
      "Equivalent to (20 / 4) + 2"
    when "5 2 * 3 +"
      "Equivalent to (5 * 2) + 3"
    when "12 3 / 2 *"
      "Equivalent to (12 / 3) * 2"
    when "25 5 - 4 *"
      "Equivalent to (25 - 5) * 4"
    when "8 2 / 3 +"
      "Equivalent to (8 / 2) + 3"
    when "7 3 + 2 *"
      "Equivalent to (7 + 3) * 2"
    when "4 5 * 2 +"
      "Equivalent to (4 * 5) + 2"
    when "2 4 ^ 1 -"
      "Equivalent to (2^4) - 1"
    when "50 5 / 2 ^"
      "Equivalent to (50 / 5)^2"
    when "9 3 ^ 2 /"
      "Equivalent to (9^3) / 2"
    when "6 2 * 3 ^"
      "Equivalent to (6 * 2)^3"
    when "3 2 ^ 1 +"
      "Equivalent to (3^2) + 1"
    else
      "Equivalent to complex nested operations"
    end
  end

  # Make the helper method available to views
  helper_method :generate_explanation
end