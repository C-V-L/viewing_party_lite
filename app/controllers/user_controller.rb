class UserController < ApplicationController
  def dashboard
    @user = User.find(params[:id])
    @viewing_parties = @user.viewing_parties
  end

  def discover
  end

  def new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to user_path(@user)
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def user_params
    params.permit(:name, :email)
  end
end