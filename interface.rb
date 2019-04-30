# frozen_string_literal: true

require_relative 'deck'
require_relative 'deck_helper'
require_relative 'user'

class Menu
  include DeckHelper

  attr_accessor :deck

  def initialize
    @deck = Deck.new
    @select_item = {
      1 => 'Взять карту',
      2 => 'Показать карты',
      3 => 'Выйти из игры'
    }
    @separator = "-----------------------------"
  end

  def run
    puts 'Как Вас зовут?'
    name = gets.chomp
    puts "Добро пожаловать в игру, #{name}!"
    @user = User.new(name, 100)
    @user.take_card(2, @deck)
    @dealer = User.new('Dealer', 100)
    @dealer.take_card(2, @deck)

    puts "На вашем счёте: #{@user.cash}$" # Сделать метод?
    puts "Карт в колоде: #{@deck.deck.size}"
    puts 'У Вас в руке:'
    puts @separator
    with_separator(show_hand(@user))
    print "\n"

# for test
    # puts @separator
    # with_separator(show_hand(@dealer))
    # print "\n"

    puts 'Выберите действие:'
    @select_item.each do |key, value|
      puts "#{key} -> #{value}"
    end

    loop do
      choise = gets.chomp
      case choise
      when "1"

      when "2"

      when "3"
        puts 'Будем рады видеть Вас снова!'
        break
      else
        puts 'Неверный ввод!'
      end
    end
  end

  def with_separator(_method_name)
    _method_name
    print "\n"
    puts @separator
  end

  def show_hand(user)
    user.hand.each do |card, _index|
      print "| #{card[:name]} | "
    end
  end
end
