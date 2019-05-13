require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = ('a'..'z').to_a.sample(10)
    session[:current_user_id] = user.id
  end

  def score
    @answer = params[:answer]
    @letters = params[:grid].split
    @exist = included?(@answer, @letters)
    @english = english_word?(@answer)
  end

  private

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end
end
