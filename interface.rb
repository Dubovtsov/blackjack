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
  
    show_menu

    loop do
      choise = gets.chomp
      case choise
      when "1"
        if points(@user) < 17
          user_move(1)
          main_info
          puts "Ход дилера."
          if points(@dealer) < 17
            dealer_move(1)
            main_info
          else
            separator
            puts "У дилера достаточно карт."
            main_info
          end
        else
          separator
          puts "Достаточно!"
          puts "Ход дилера."
          if points(@dealer) < 17
            dealer_move(1)
            main_info
          else
            puts "У дилера достаточно карт."
            main_info
          end
          show_menu
        end
      when "2"
        dealer_move(1)
        main_info
      when "3"
        puts 'Карты дилера:'
        separator
        with_separator(cards_in_hand(@dealer, "show"))
        print "\n"

        puts 'Ваши карты:'
        separator
        with_separator(cards_in_hand(@user))
        print "\n"
      when "4"
        separator
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
    puts 'Карты дилера:'
    separator
    with_separator(cards_in_hand(@dealer))
    print "\n"
  end

  def with_separator(_method_name)
    _method_name
    print "\n"
    separator
  end

  def show_menu
    puts 'Выберите действие:'
    @select_item.each do |key, value|
      puts "#{key} -> #{value}"
    end
  end

  def cards_in_hand(user, show_dealer = nil)
    sum = 0
    user.hand.each do |card, _index|
      if show_dealer.nil?
        print user == @user ? "| #{card[:name]} | " : "| * |"
      else
        print "| #{card[:name]} | "
      end
      sum += card[:number] if user == @user
      sum += card[:number] unless show_dealer.nil?
    end
    print "сумма очков: #{sum}" if user == @user
    print "сумма очков: #{sum}" unless show_dealer.nil?
  end

  def points(user)
    sum = 0
    user.hand.each do |card, _index|
      sum += card[:number]
    end
    sum
  end

  def dealer_move(num_of_cards)
    @dealer.take_card(num_of_cards, @current_deck)
  end

  def user_move(num_of_cards)
    @user.take_card(num_of_cards, @current_deck)
  end
end
