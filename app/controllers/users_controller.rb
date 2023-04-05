# frozen_string_literal: true
class UsersController < ApplicationController
  def new; end

  def create
    user = user_params
    user[:email] = user[:email].downcase
    @user = User.new(user)
    if @user.save
      flash[:notice] = "#{@user.name} has been created!"
      session[:user_id] = @user.id
      redirect_to user_path(@user)
    else
      flash[:notice] = "Cannot create! Please fill out all fields and make sure passwords match"
      redirect_to register_path
    end
  end

  def login_form
  end

  def login
    user = User.find_by(email: params[:email])
    if user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome, #{user.name}!"
      redirect_to root_path
    else
      flash[:error] = "Sorry, your credentials are bad."
      render :login_form
    end
  end

  def logout
    session.delete(:user_id)
    flash[:logout] = "You have been logged out!"
    redirect_to root_path
  end

  def show
    @user = User.find(params[:id])
    if session[:user_id] == @user.id
      @viewing_parties = @user.viewing_parties
      @other_users = User.other_users(@user.id)
    else
      flash[:error] = "You must be logged in to view this page"
      redirect_to root_path
    end
  end

  private
  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end
end