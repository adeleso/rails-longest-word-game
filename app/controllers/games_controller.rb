require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = ('a'..'z').to_a.sample(10)
  end

  def score
    @answer = params[:answer]
    @letters = params[:grid].split
    @exist = included?(@answer, @letters)
    @english = english_word?(@answer)
    @score = @answer.size + previous_score
    save_score(@score)
    @score = previous_score
  end

  def previous_score
    (cookies[:score] || 0).to_i
  end

  def save_score(score)
    cookies[:score] = score
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
