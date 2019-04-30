# frozen_string_literal: true

require_relative 'deck'
require_relative 'deck_helper'
require_relative 'user'

class Menu
  include DeckHelper

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
    @user = User.new(name, 100, take_card(2))
    puts 'У Вас в руке:'
    puts @separator
    with_separator(show_hand)
    print "\n"

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

  def take_card(n)
    @current_hand ||= []
    n.times do |x|
      @current_hand << @deck.deck.last
      @deck.deck.pop
    end
    @current_hand
  end

  def show_hand
    @user.hand.each do |card, _index|
      print "| #{card[:name]} | "
    end
  end
end
