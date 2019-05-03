# frozen_string_literal: true

class Bank
  attr_accessor :bank_amount

  def initialize
    @bank_amount = 0
  end

  def gain(user)
    user.cash += @bank_amount
    @bank_amount = 0
  end

  def return_bet(name)
    name.cash += 10
    @bank_amount = 0
  end
end
