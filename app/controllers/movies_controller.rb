class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    # Read all the possible ratings in the Model
    @all_ratings = Movie.uniq.pluck(:rating)
    
    if params[:ratings] == nil
      params[:ratings] = session[:ratings]
    end
    
    if params[:sort] == nil
      params[:sort] = session[:sort]
    end
    
    # the very first time the webpage is opened
    if params[:ratings] == nil && params[:sort] == nil
      @movies = Movie.all
      @titleClass = false
      @releaseClass = false
      
    elsif params[:ratings] != nil && params[:sort] == nil
      @movies = Movie.where(rating: params[:ratings].keys)
      @titleClass = false
      @releaseClass = false
      session[:ratings] = params[:ratings]
      
    elsif params[:ratings] == nil && params[:sort] != nil
      
      if params[:sort] == "title"
        @movies = Movie.order(params[:sort])
        @titleClass = true
        @releaseClass = false
        session[:sort] = params[:sort]
        
      elsif params[:sort] == "release_date"
        @movies = Movie.order(params[:sort]).reverse_order
        @titleClass = false
        @releaseClass = true
        session[:sort] = params[:sort]
      end
      
    else # sorting and filtering simultaneously
      if params[:sort] == "title"
        @movies = Movie.where(rating: params[:ratings].keys).order(params[:sort])
        @titleClass = true
        @releaseClass = false
      
      elsif params[:sort] == "release_date"
        @movies = Movie.where(rating: params[:ratings].keys).order(params[:sort]).reverse_order
        @titleClass = false
        @releaseClass = true
      end
      session[:sort] = params[:sort]
      session[:ratings] = params[:ratings]
    end
    
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
