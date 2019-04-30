# frozen_string_literal: true

require_relative 'deck'
require_relative 'deck_helper'
require_relative 'user'
require_relative 'bank'

class Menu
  # include DeckHelper

  attr_accessor :current_deck

  def initialize
    @current_deck = Deck.new
    @select_item = {
      1 => 'Взять карту',
      2 => 'Пропустить ход',
      3 => 'Показать карты',
      4 => 'Начать заново',
      5 => 'Выйти из игры'
    }
    def separator
      puts "-------------------------------------"
    end
  end

  def run
    puts 'Как Вас зовут?'
    name = gets.chomp
    puts "Добро пожаловать в игру, #{name}!"
    @bank = Bank.new
    @user = User.new(name, 100)
    user_move(2)
    @user.bet(@bank)
    @dealer = User.new('Dealer', 100)
    dealer_move(2)
    @dealer.bet(@bank)
    
    main_info
    # for test
    # puts @separator
    # with_separator(cards_in_hand(@dealer))
    # print "\n"

    puts 'Выберите действие:'
    @select_item.each do |key, value|
      puts "#{key} -> #{value}"
    end

    loop do
      choise = gets.chomp
      case choise
      when "1"
        user_move(1)
        main_info
      when "2"
        dealer_move(1)
        main_info
      when "3"
        puts 'Карты дилера:'
        separator
        with_separator(cards_in_hand(@dealer))
        print "\n"

        puts 'У Вас в руке:'
        separator
        with_separator(cards_in_hand(@user))
        print "\n"
      when "4"
        Menu.new.run
      when "5"
        puts 'Будем рады видеть Вас снова!'
        break
      else
        puts 'Неверный ввод!'
      end
    end
  end

  def main_info
    puts "На вашем счёте: #{@user.cash}$"
    puts "Счёт дилера: #{@dealer.cash}$"
    puts "Денег в банке: #{@bank.bank_amount}$"
    puts "Карт в колоде: #{@current_deck.deck.size}"
    puts 'У Вас в руке:'
    separator
    with_separator(cards_in_hand(@user))
    print "\n"
  end

  def with_separator(_method_name)
    _method_name
    print "\n"
    separator
  end

  def cards_in_hand(user)
    sum = 0
    user.hand.each do |card, _index|
      print "| #{card[:name]} | "
      sum += card[:number]
    end
    print "сумма очков: #{sum}"
  end

  def show_hand(user);end

  def dealer_move(num_of_cards)
    @dealer.take_card(num_of_cards, @current_deck)
  end

  def user_move(num_of_cards)
    @user.take_card(num_of_cards, @current_deck)
  end
end
