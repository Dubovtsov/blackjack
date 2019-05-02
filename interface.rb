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
      puts "-------------------------------------------"
    end
  end

  def message_dealer_move
    puts "🗩  Ход дилера 🗩"
  end

  def message_skip
    puts "🗩  Дилер пропускает ход 🗩"
  end

  def message_bank
    puts "🏛  Денег в банке: #{@bank.bank_amount}$"
  end

  def run
    puts 'Как Вас зовут?'
    name = gets.chomp
    puts "Добро пожаловать в игру, #{name}!"
    separator
    @bank = Bank.new
    @user = User.new(name, 100)
    user_move(2)
    @user.bet(@bank)
    @dealer = User.new('Dealer', 100)
    dealer_move(2)
    @dealer.bet(@bank)
    main_info  
    show_menu

    loop do
      choise = gets.chomp
      case choise
      when "1"
        system "clear"
        if @user.points < 17
          user_move(1)
          show_cards(@user)
          message_dealer_move
          if @dealer.points < 17
            dealer_move(1)
            show_cards(@dealer)
            show_menu
          else
            separator
            message_skip
            show_cards
            show_menu
          end
        else
          separator
          puts "🗩  Достаточно! 🗩"
          message_dealer_move
          if @dealer.points < 17
            dealer_move(1)
            show_cards(@dealer)
          else
            message_skip
            show_cards(@dealer)
          end
          show_menu
        end
      when "2"
        message_dealer_move
        if @dealer.points < 17
          dealer_move(1)
          show_cards
        else
          separator
          message_skip
          show_cards
        end
      when "3"
        system "clear"
        puts 'Карты дилера:'
        separator
        with_separator(cards_in_hand(@dealer, "show"))
        print "\n"

        puts 'Ваши карты:'
        separator
        with_separator(cards_in_hand(@user))
        print "\n"

        if @user.points > @dealer.points && @user.points <= 21 ||
            @user.points <= 21 && @dealer.points > 21
          puts "🗩  Вы выиграли! 🗩"
          @bank.gain(@user)
          puts "На вашем счёте: #{@user.cash}$"
          puts "Счёт дилера: #{@dealer.cash}$"
          message_bank
        elsif @user.points == @dealer.points && @user.points <= 21
          puts "🗩  Ничья! 🗩"
          @user.cash += 10
          @user.cash += 10
          @bank.bank_amount = 0
          message_bank
        elsif @user.points < @dealer.points && @dealer.points <= 21 ||
            @user.points > @dealer.points && @dealer.points <= 21
          puts "🗩  Вы проиграли! 🗩"
          @bank.gain(@dealer)
          puts "На вашем счёте: #{@user.cash}$"
          puts "Счёт дилера: #{@dealer.cash}$"
          message_bank
        else
          puts "🗩  Перебор! 🗩"
          main_info
        end
        separator
        show_menu
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
    show_accounts
    message_bank
    puts "🂠  Карт в колоде: #{@current_deck.deck.size}"
    show_cards
  end

  def with_separator(_method_name)
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
      with_separator(cards_in_hand(@user))
      print "\n"
    elsif user == @dealer
      puts 'Карты дилера:'
      separator
      with_separator(cards_in_hand(@dealer))
      print "\n"
    else
      puts 'У Вас в руке:'
      separator
      with_separator(cards_in_hand(@user))
      print "\n"
      puts 'Карты дилера:'
      separator
      with_separator(cards_in_hand(@dealer))
      print "\n"
    end
  end

  def show_menu
    puts 'Выберите действие(введите цифру от 1 до 5):'
    @select_item.each do |key, value|
      puts "#{key} 🖝  #{value}"
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

  def dealer_move(num_of_cards)
    @dealer.take_card(num_of_cards, @current_deck)
  end

  def user_move(num_of_cards)
    @user.take_card(num_of_cards, @current_deck)
  end
end
