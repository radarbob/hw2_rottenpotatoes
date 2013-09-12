class MoviesController < ApplicationController
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index 
     @all_ratings = Movie.ratings # an array
    
    # params.ratings is nil if we didn't come from /Movies 
    # use session.ratings if all CBs are un-checked or params.ratings is nil
    # as a last resort check all CBs.
    
    @checked_ratings = params[:ratings].nil? ? 
              session[:ratings].nil? ? @all_ratings : session[:ratings] :
              (params[:ratings].is_a? Hash) ? params[:ratings].keys : params[:ratings]
    
    session[:ratings] = @checked_ratings    
    @checkedRatings = @checked_ratings
    @sort_column = params[:sort] || session[:sort]      #sort_by_column 

    @movies = Movie.where(rating: @checkedRatings).order(@sort_column || "")   #the future!
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  
  def sort_by_column
    if params[:sort] == 'title' then @sort_column = {:sort=>"title"} end 
    if params[:sort] == 'release_date' then @sort_column = {:sort=>"release_date"} end
  end
end   #MoviesController
