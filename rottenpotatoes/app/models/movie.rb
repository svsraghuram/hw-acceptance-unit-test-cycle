class Movie < ActiveRecord::Base
    def self.with_ratings(ratings_list)
    # if ratings_list is an array such as ['G', 'PG', 'R'], retrieve all
    #  movies with those ratings
    # if ratings_list is nil, retrieve ALL movies
        if(ratings_list && ratings_list.length)
            where(rating: ratings_list)
        else 
            all
        end
    end
    
    def self.all_ratings
        #return all ratings present
        select(:rating).map(&:rating).uniq
    end
    
    def self.get_similar_movies(movie_id)
        director = Movie.find_by(id: movie_id).director
        
        return nil if director.blank? || director.nil?
        
        Movie.where(director: director)
    end
end