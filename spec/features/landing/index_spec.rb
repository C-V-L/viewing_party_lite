# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Landing Page Index' do
  
  xcontext 'As a user when I visit the landing page' do
    before(:each) do
      @user_1 = User.create!(name: 'Joe', email: 'joe@email.com', password: 'password')
      @user_2 = User.create!(name: 'Bob', email: 'bob@email.com', password: 'password')
      @user_3 = User.create!(name: 'Dan', email: 'dan@email.com', password: 'password')
      visit root_path
    end

    it 'I see the title of the application' do
      expect(page).to have_content('Viewing Party')
    end

    it 'I see a button to create a new user' do
      expect(page).to have_button('Create New User')
    end

    it "I see a list of existing users, that links to the user's dashboard" do
      within('#existing_users') do
        expect(page).to have_content('Joe')
        expect(page).to have_content('Bob')
        expect(page).to have_content('Joe')
      end
    end

    it 'I see a link to go back to the landing page' do
      within('#nav_bar') do
        expect(page).to have_link('Home')
        click_link('Home')
      end
      expect(current_path).to eq(root_path)
    end
  end
  
  describe 'authorization challenges' do
    describe 'as a logged in user' do
      before :each do
        @user = User.create!(name: "funbucket13", email: "fb@fb.com", password: "test")
        @user2 = User.create!(name: "funnypants", email: "funny@pants.com", password: "test")
        @user3 = User.create!(name: "sillygoose", email: "silly@goose.com", password: "test")
        visit root_path
        click_on "I already have an account"    
        fill_in :email, with: @user.email
        fill_in :password, with: @user.password
        click_on "Log In"
      end

      it 'I cannot see the login or register links' do
        expect(current_path).to eq(root_path)
        expect(page).to have_content("Welcome, #{@user.name}")
        expect(page).to have_content("Log Out")
        expect(page).to_not have_content("I already have an account")
        expect(page).to_not have_content("Register")
      end

      it 'I can log out' do
        click_link "Log Out"
        expect(current_path).to eq(root_path)
        expect(page).to have_content("You have been logged out!")
        expect(page).to have_content("I already have an account")
        expect(page).to have_content("Register")
        expect(page).to_not have_content("Log Out")
      end

      it 'I see a list of user emails but no links to their show pages' do
        within('#existing_users') do
          expect(page).to have_content(@user2.email)
          expect(page).to_not have_link(@user2.email)
          expect(page).to have_content(@user3.email)
          expect(page).to_not have_link(@user3.email)
        end
      end

      it 'If I am not logged in, I do not see any other user info' do
        click_link "Log Out"
        expect(page).to_not have_content(@user2.email)
        expect(page).to_not have_content(@user3.email)
      end
    end
  end
end
