# frozen_string_literal: true
class ViewingPartiesController < ApplicationController
  def new
    if current_user.nil?
      flash[:error] = "You must be logged in to view this page"
      redirect_to "/users/#{params[:user_id]}/movies/#{params[:movie_id]}"
    else
      @user = User.find(params[:user_id])
      @facade = MovieFacade.new(id: params[:movie_id])
      @other_users = User.other_users(@user.id)
    end
  end

  def create
    @user = User.find(params[:user_id])
    viewing_party = ViewingParty.new(party_params)
    
    if viewing_party.save && params[:duration] >= params[:movie_runtime]
      ViewingPartyUser.create!(user: @user, viewing_party: viewing_party, host: true)
      params[:user_ids].each do |id|
        ViewingPartyUser.create!(user: User.find(id), viewing_party: viewing_party) unless id == "" 
      end
      flash[:notice] = "Party has been Created!"
      redirect_to "/users/#{@user.id}"
    end
  end

  private
  def party_params
    params.permit(:duration, :date, :time, :movie_id, :movie_title, :movie_poster)
  end
end