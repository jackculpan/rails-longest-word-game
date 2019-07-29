require 'open-uri'
require 'nokogiri'

class GamesController < ApplicationController
  def new
    @letters = (0...10).map { ('A'..'Z').to_a[rand(26)] }
  end

  def score
    @score = 0
    @answer = params[:answer].upcase!
    @letters = params[:letters]
    @result = {}

    # if @letters.include?(@answer) == false
    #   return @result = { answer: @answer, score: 0, message: "not in the grid" }
    # end

    @in_grid = @answer.chars.each do |c|
      @answer.count(c) <= @letters.count(c)
    end

    if parse(@answer)["found"] == false
      return @result = { answer: @answer, score: @score, message: "not an english word" }
    elsif parse(@answer)["found"] == true
      if @in_grid
        @score = @answer.chars.length
        @result = { answer: @answer, score: @score, message: "well done this is an english word" }
      else
        @result = { answer: @answer, score: @score, message: "not in the grid" }
      end
    end
  end

  def parse(answer)
    url = "https://wagon-dictionary.herokuapp.com/#{answer}"
    attempt_serialized = open(url).read
    return outcome = JSON.parse(attempt_serialized)
  end
end
