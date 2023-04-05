# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Movie Show Page' do
  before(:each) do
    @user = User.create!(name: 'Bob', email: 'bob@bob.bob', password: 'bob')
    VCR.use_cassette(:movie_details, serialize_with: :json) do
      visit "/users/#{@user.id}/movies/238"
    end
  end

  xdescribe 'As a visitor when I visit a movie show page' do
    describe 'I should see the movie details' do
      it 'should have a title, runtime, vote_average, genres, and summary' do
        expect(page).to have_content('The Godfather')
        expect(page).to have_content('2h 55m')
        expect(page).to have_content('8.7')
        expect(page).to have_content('Drama')
        expect(page).to have_content('Crime')
        expect(page).to have_content('Spanning the years 1945 to 1955, a chronicle of the fictional Italian-American Corleone crime family')
      end

      it 'should have a list of cast members' do
        expect(page).to have_content('Marlon Brando')
        expect(page).to have_content('Al Pacino')
        expect(page).to have_css('.cast_member', count: 10)
      end
    end

    describe 'I should see buttons to create a viewing party and to return to the Discover page' do
      it 'should have a button that takes me to a form to create a new viewing party' do
        VCR.use_cassette(:viewing_party_new, serialize_with: :json) do
          click_button 'Create A Viewing Party for The Godfather'
          
          expect(current_path).to eq("/users/#{@user.id}/movies/238/viewing-party/new")
        end
      end
      
      it 'should have a button that takes me back to the discover page' do
        click_button 'Discover Page'
        
        expect(current_path).to eq(user_discover_path(@user))
      end
    end
  end
  
  describe 'As a visitor when I visit a movie show page' do
    describe 'If I am not logged in and try to create a party' do
      it 'I should see a message that I must be logged in to create a viewing party' do
        VCR.use_cassette(:viewing_party_new_redirected, serialize_with: :json) do
          click_button 'Create A Viewing Party for The Godfather'
          
          expect(current_path).to eq("/users/#{@user.id}/movies/238")
        end
      end

    end
  end
end
