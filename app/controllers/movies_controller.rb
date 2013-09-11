class MoviesController < ApplicationController
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    puts "**************** start index ********************"
    puts "params incoming: " + params.inspect
    
    @all_ratings = Hash[ *Movie.ratings.collect { |v| [ v, 1] }.flatten ] 
    @checked_ratings = params[:ratings].nil? ? @all_ratings : params[:ratings]
    set_checked_ratings  
    
    puts "after set-checked @all-ratings: #{@all_settings}"
    
    @checkedRatings = @all_ratings.select {|k,v| v == 1}.keys    # and array for the order clause
    puts "checkedRatings: #{@checkedRatings.inspect}"
    
    #sort_by_column  
    @sort_column = params[:sort] || session[:sort]

    puts "@all_ratings: " + @all_ratings.inspect
    puts "@checkedRatings: " +  @checkedRatings.inspect
    puts "@sort_column:" + @sort_column.inspect
    
    @movies = Movie.where(rating: @checkedRatings).order(@sort_column || "")   #the future!
    
    puts "************ end index ***************"
  end
  
  def set_checked_ratings 
    puts "@all_ratings BEFORE setting against params[:ratings]  " + @all_ratings.inspect
    
    @all_ratings.each do |k, v|
      unless @checked_ratings.has_key? k then @all_ratings[k] = 0 end
    end
    
    puts "@all_ratings AFTER setting against params[:ratings]  " + @all_ratings.inspect
    if @all_ratings.values.all? {|v| v == 0} then 
      @all_ratings.each do |key,value| @all_ratings[key] = 1 end
    end
    
    puts "@all_ratings after values.all?  " + @all_ratings.inspect
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
