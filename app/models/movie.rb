class Movie < ActiveRecord::Base
  @@ratings = %w[G PG PG-13 R X]
  
  def Movie.ratings
    return @@ratings
  end
    
end
