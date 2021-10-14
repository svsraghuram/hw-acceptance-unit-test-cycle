require 'rails_helper'
require 'support/action_controller_workaround'

describe Movie do
  describe 'movie model tests' do
    let!(:movie1) { FactoryGirl.create(:movie, id: 7, director: 'director1', rating: 'PG')}
    let!(:movie2) { FactoryGirl.create(:movie, id: 4, director: 'director2', rating: 'PG')}
    let!(:movie3) { FactoryGirl.create(:movie, id: 3, director: '', rating: 'R')}
    let!(:movie4) { FactoryGirl.create(:movie, id: 8, director: 'director1', rating: 'PG-13')}
    let!(:movie5) { FactoryGirl.create(:movie, id: 9, director: 'director1', rating: 'PG')}
    let!(:movie6) { FactoryGirl.create(:movie, id: 10, director: 'director2', rating: 'R')}

    it 'shows all ratings' do
        ratings = ['PG', 'R', 'PG-13']
        
        Movie.all_ratings().should =~ ratings
    end
    
    it 'filters movies with rating when ratings is not empty' do
        ratings = ['PG', 'R']
        
        expect(Movie.with_ratings(ratings).count).to eql(5)
    end
    
    it 'returns all movie when ratings is empty' do
        ratings = nil
        
        expect(Movie.with_ratings(ratings).count).to eql(6)
    end
    
    it 'returns similar movies when there is a valid director' do
        movie_id = 7
        
        expect(Movie.get_similar_movies(movie_id).count).to eql(3)
    end
    
    it 'returns nil when there is no valid director' do
        movie_id = 3
        
        expect(Movie.get_similar_movies(movie_id)).to eql(nil)
    end
  end
end