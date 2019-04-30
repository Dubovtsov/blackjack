# frozen_string_literal: true

class User
  attr_accessor :name, :cash, :hand
  def initialize(name, cash = 100, hand = [])
    @name = name
    @cash = cash
    @hand = []
    @hand = hand
  end
end
