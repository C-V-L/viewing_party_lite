# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'New User Registration Page' do
  before(:each) do
    visit '/register'
  end

  xcontext "When a user visits the '/register' path" do
    it "I see a form to create a new user, once created I am take back to that user's dashboard" do
      fill_in 'Name', with: 'Pete'
      fill_in 'Email', with: 'pete@email.com'

      click_on 'Create User'
      expect(page).to have_content('Pete has been created!')
      expect(current_path).to eq("/users/#{User.last.id}")
    end

    it "If I do not fill out the form and try to submit, I should stay on the create page" do
      fill_in 'Name', with: nil
      fill_in 'Email', with: nil
      click_on 'Create User'
      
      expect(page).to have_content('Cannot create! Please fill out all fields')
      expect(current_path).to eq('/register')
    end
  end

  describe 'register with login' do
    it 'I can register and be logged in' do
      name = "funbucket13"
      email = "funbucket13@fb.com"
      password = "test"
  
      fill_in :name, with: name
      fill_in :email, with: email
      fill_in :password, with: password
      fill_in :password_confirmation, with: password
  
      click_on "Create User"
      expect(current_path).to eq("/users/#{User.last.id}")
      expect(page).to have_content("#{User.last.name} has been created!")
    end
    describe 'sad path' do
      it 'If passwords dont match, user not created' do
        name = "funbucket13"
        email = "funbucket13@fb.com"
        password = "test"
        wrong_password = "wrong"

        fill_in :name, with: name
        fill_in :email, with: email
        fill_in :password, with: password
        fill_in :password_confirmation, with: wrong_password
    
        click_on "Create User"
        expect(current_path).to eq("/register")
        expect(page).to have_content("Cannot create! Please fill out all fields and make sure passwords match")
      end
    end
  end
end
