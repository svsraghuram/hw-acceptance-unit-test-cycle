require 'rails_helper'
require 'support/action_controller_workaround'

describe MoviesController do
  describe 'show a movie' do
    let!(:movie) { FactoryGirl.create(:movie) }

    it 'shows a movie' do
      get :show, id: movie.id
      expect(assigns(:movie)).to eql(movie)
      expect(response).to render_template(:show)
    end
  end
  
  describe 'get homepage' do
    it 'shows all movies' do
      get :index
      expect(response).to render_template(:index)
      expect(assigns(:movies).count).to eql(Movie.count)
    end
    
    it 'shows filtered movies' do
      get :index, {:submit_clicked => true, :ratings => { :PG => 1}}
      expect(response).to render_template(:index)
      expect(assigns(:movies).count).to eql(Movie.with_ratings(['PG']).count)
    end
    
    it 'shows sorted movies' do
      get :index, {:sort => 'release_date'}
      expect(response).to render_template(:index)
      expect(assigns(:sort)).to eql('release_date')
    end
  end
  
  describe 'show similar movies' do
    let(:movie) { FactoryGirl.create(:movie) }
    let(:movie1) { FactoryGirl.create(:movie, id: 7)}
    let(:movie2) { FactoryGirl.create(:movie, id: 4)}
    let(:movie3) { FactoryGirl.create(:movie, id: 3)}
    let(:movie4) { FactoryGirl.create(:movie, id: 8, director: '')}
    
    it 'should call Movie.get_similar_movies' do
      movie
      expect(Movie).to receive(:get_similar_movies).with(movie.id.to_s)
      get :similar, { :id => movie.id.to_s }
    end

    it 'should return similar movies if there is director' do
      movies = [movie1, movie2, movie3]
      
      Movie.stub(:get_similar_movies).with(movie1.id.to_s).and_return(movies)
      get :similar, { :id => movie1.id.to_s }
      expect(assigns(:similar_movies)).to eql(movies)
    end

    it "should redirect to home page if director isn't known" do
      movie4
      
      Movie.stub(:get_similar_movies).with(movie4.id.to_s).and_return(nil)
      get :similar, { id: movie4.id.to_s }
      expect(response).to redirect_to(movies_path)
    end
  end
  
  describe 'create a movie' do
    let(:create_movie) { post :create, :movie => FactoryGirl.attributes_for(:movie) }

    it 'creates a movie' do
        expect { create_movie }.to change { Movie.count }.by(1)
    end
    
    it 'redirects to movies path' do
        expect(create_movie).to redirect_to(movies_path)
    end
    
    it 'flashes success message' do
        expect( create_movie.request.flash[:notice] ).to_not be_nil
    end
  end
  
  describe 'delete a movie' do
    let!(:movie) { FactoryGirl.create(:movie) }

    it 'destroys a movie' do
      expect { delete :destroy, id: movie.id }.to change(Movie, :count).by(-1)
      expect(response).to redirect_to(movies_path)
    end
  end
end