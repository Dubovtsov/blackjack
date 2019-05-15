# frozen_string_literal: true
require_relative 'modules/validation.rb'

class Card
  include Validation

  attr_reader :suit, :name
  attr_accessor :points
  validate :name, :presence
  validate :suit, :format, /^[♠♥♦♣]+$/

  def initialize(suit, points, name)
    @suit = suit
    @points = points
    @name = name
    validate!
  end
end
