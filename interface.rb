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
    puts player == @dealer ? 'Карты дилера:' : 'Ваши карты:'
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

  def message_bank
    puts "🏛  Денег в банке: #{@bank.bank_amount}$"
  end

  def show_account(user)
    message("На вашем счёте: #{user}$") if user == @user
    message("Счёт дилера: #{user}$")
  end

  def withseparator(_method_name)
    _method_name
    print "\n"
    separator
  end

  def show_cards(user = nil)
    if user == @user
      puts 'У Вас в руке:'
      separator
      withseparator(@user.cards_in_hand('show'))
      print "\n"
    elsif user == @dealer
      puts 'Карты дилера:'
      separator
      withseparator(@dealer.cards_in_hand)
      print "\n"
    else
      puts 'У Вас в руке:'
      separator
      withseparator(@user.cards_in_hand('show'))
      print "\n"
      puts 'Карты дилера:'
      separator
      withseparator(@dealer.cards_in_hand)
      print "\n"
    end
  end

  def show_menu
    puts 'Выберите действие(введите цифру от 1 до 5):'
    @munu.each do |key, value|
      puts "#{key} 🖝  #{value}"
    end
  end
end
