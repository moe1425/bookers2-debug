class SearchesController < ApplicationController
   before_action :authenticate_user!

  def search
    @range = params[:range]

    if @range == "User"
      @records = User.looks(params[:search], params[:word])
    elsif @range == 'book'
      @records = Book.looks(params[:search], params[:word])
    elsif @range == 'tag'
      @records = Tag.looks(params[:search], params[:word])
    end
  end
end