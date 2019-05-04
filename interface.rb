# frozen_string_literal: true

require_relative 'deck'
require_relative 'user'
require_relative 'bank'

module Interface
  
  MENU = {
      1 => 'Взять карту',
      2 => 'Пропустить ход',
      3 => 'Показать карты',
      4 => 'Новая раздача',
      5 => 'Начать заново',
      6 => 'Выйти из игры'
    }.freeze

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

  def separator
    puts "-------------------------------------------"
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

  def main_info
    show_accounts
    message_bank
    puts "🂠  Карт в колоде: #{@current_deck.deck.size}"
    show_cards
  end

  def withseparator(_method_name)
    _method_name
    print "\n"
    separator
  end

  def show_accounts
    puts "На вашем счёте: #{@user.cash}$"
    puts "Счёт дилера: #{@dealer.cash}$"
  end

  def show_cards(user = nil)
    if user == @user
      puts 'У Вас в руке:'
      separator
      withseparator(cards_in_hand(@user))
      print "\n"
    elsif user == @dealer
      puts 'Карты дилера:'
      separator
      withseparator(cards_in_hand(@dealer))
      print "\n"
    else
      puts 'У Вас в руке:'
      separator
      withseparator(cards_in_hand(@user))
      print "\n"
      puts 'Карты дилера:'
      separator
      withseparator(cards_in_hand(@dealer))
      print "\n"
    end
  end

  def show_menu
    puts 'Выберите действие(введите цифру от 1 до 5):'
    @action_menu.each do |key, value|
      puts "#{key} 🖝  #{value}"
    end
  end
end
