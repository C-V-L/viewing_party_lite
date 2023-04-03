# frozen_string_literal: true
class UsersController < ApplicationController
  def new; end

  def create
    user = user_params
    user[:email] = user[:email].downcase
    @user = User.new(user)
    if params[:password] == params[:password_confirmation] && @user.save
      flash[:notice] = "#{@user.name} has been created!"
      redirect_to user_path(@user)
    else
      flash[:notice] = "Cannot create! Please fill out all fields and make sure passwords match"
      redirect_to register_path
    end
  end

  def show
    @user = User.find(params[:id])
    @viewing_parties = @user.viewing_parties
    @other_users = User.other_users(@user.id)
  end

  private
  def user_params
    params.permit(:name, :email, :password)
  end
end