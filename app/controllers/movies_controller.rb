class MoviesController < ApplicationController
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Hash[ *Movie.ratings.collect { |v| [ v, 1] }.flatten ] 
    @checked_ratings = params[:ratings].nil? ? @all_ratings : params[:ratings]
    set_checked_ratings
    
    @checkedRatings = @all_ratings.select {|k,v| v == 1}.keys    # and array for the order clause
    #sort_by_column  
    @sort_column = params[:sort] || session[:sort]

    @movies = Movie.where(rating: @checkedRatings).order(@sort_column || "")   #the future!
  end
  
  def set_checked_ratings 
    @all_ratings.each do |k, v|
      unless @checked_ratings.has_key? k then @all_ratings[k] = 0 end
    end
    
    if @all_ratings.values.all? {|v| v == 0} then 
      @all_ratings.each do |key,value| @all_ratings[key] = 1 end
    end
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
