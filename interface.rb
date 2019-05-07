# frozen_string_literal: true

require_relative 'deck'
require_relative 'user'
require_relative 'bank'
require_relative 'game'

class Interface
  MENU = {
    1 => 'Взять карту',
    2 => 'Пропустить ход',
    3 => 'Показать карты',
    4 => 'Новая раздача',
    5 => 'Начать заново',
    6 => 'Выйти из игры'
  }.freeze

  attr_reader :menu

  def initialize
    @menu = MENU
  end

  def loading
    3.times do
      sleep 0.5
      print ' - '
    end
    puts ''
  end

  def user_input(input)
    puts "#{input}:"
    gets.chomp
  end

  def system_clear
    system 'clear'
  end

  def separator
    puts '-------------------------------------------'
  end

  def message_cards(player)
    puts player.name == 'Dealer' ? 'Карты дилера:' : 'Ваши карты:'
  end

  def message(output)
    puts "🗩  #{output} 🗩"
  end

  def message_dealer_move
    puts '🗩  Ход дилера 🗩'
  end

  def message_skip
    puts '🗩  Дилер пропускает ход 🗩'
  end

  def message_bank(bank_amount)
    puts "🏛  Денег в банке: #{bank_amount}$"
  end

  def show_account(_message, _user_account)
    puts "#{_message} #{_user_account}$"
  end

  def withseparator(_method_name)
    _method_name
    print "\n"
    separator
  end

  def show_cards(cards_in_hand)
    withseparator(cards_in_hand)
  end

  def show_menu
    puts 'Выберите действие(введите цифру от 1 до 5):'
    @menu.each do |key, value|
      puts "#{key} 🖝  #{value}"
    end
  end
end
