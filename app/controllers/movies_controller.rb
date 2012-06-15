class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end


  def index
    @all_ratings=Movie.select(:rating).map{|r| r.rating}.uniq
    logger.debug('all_ratings:'+@all_ratings.to_s)
      if(params[:sort_by] != nil)
        @movies = Movie.order(params[:sort_by])
        @sorted_by = params[:sort_by]
        session[:sort_by] = @sorted_by
      elsif(session[:sort_by] != nil)
        @movies = Movie.order(session[:sort_by])
      else
        @movies = Movie.all
      end
      if(params[:ratings] != nil)
        @movies.each{ |movie| logger.debug("params[#{:ratings}][#{movie.rating}]: "+params[:ratings][movie.rating].inspect)}
        @movies = @movies.find_all{|movie| params[:ratings][movie.rating] == "1"}
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

end
