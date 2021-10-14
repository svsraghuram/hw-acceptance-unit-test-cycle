class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # clear session on load
    if request.env['PATH_INFO'] == '/'
      session.clear
    end
      
    sort = params[:sort]
    submit_clicked = params[:submit_clicked]
    
    @all_ratings = Movie.all_ratings
    generatedRatings = {}
    @all_ratings.each{ |rating| generatedRatings[rating] = 1 }
    
    ratings = {}
    
    if(submit_clicked)
      if(!params[:ratings])
        ratings = generatedRatings
        session[:ratings] = nil
      else
        ratings = params[:ratings]
        session[:ratings] = ratings
      end
    elsif(params[:ratings]) 
      ratings = params[:ratings]
      
      session[:ratings] = ratings
    elsif(session[:ratings])
      ratings = session[:ratings]
    else
      ratings = generatedRatings
      session[:ratings] = nil
    end
    
    if(sort)
      session[:sort] = sort
    elsif session[:sort]
      sort = session[:sort]
    end
    
    case sort
      when "movies_title"
        @movies = Movie.order(:title)
        @sort = "movies_title"
      when "release_date"
        @movies = Movie.order(:release_date)
        @sort = "release_date"
      else
        @movies = Movie.all
        @sort = ''
    end
    
    @ratings_to_show = ratings == generatedRatings ? [] : ratings.keys
    @movies = @movies.with_ratings(ratings.keys)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  
  def similar
    @movie = Movie.find(params[:id])
    
    if @movie.director.nil? || @movie.director.empty?
      redirect_to movies_path
      flash[:warning] = "'#{@movie.title}' has no director info"
    end
    
    @similar_movies = Movie.get_similar_movies(params[:id]) || []
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date, :director)
  end
end