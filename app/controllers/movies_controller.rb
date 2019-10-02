class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings=Movie.all_ratings
    redirectFlag=0
    if params[:order]
      @orderList=params[:order]
    else
      @orderList=session[:order]
      redirectFlag=1
      #redirect_to movies_path(order: session[:order],ratings: session[:ratings])
    end
    if params[:order]!= session[:order]
      session[:order]=@orderList
    end
    if @orderList=="title"
      @movies=Movie.all.order(@orderList)
      @highlight_title = "hilite"
    elsif @orderList=="release_date"
      @movies=Movie.all.order(@orderList)
      @highlight_date = "hilite"
    else
    @movies = Movie.all
    end
    #@ratings=params[:ratings].keys
    #puts @ratings
    #render plain: params[:ratings].inspect
    if params[:ratings]
      @ratings=params[:ratings]
      session[:ratings]=@ratings
      #puts "parampresent"
      #puts @ratings
      @movies=@movies.where(rating: @ratings.keys)
    else
      if session[:ratings]
        @ratings=session[:ratings]
        #puts "sessionpresent"
        #puts @ratings
        @movies=@movies.where(rating: @ratings.keys)
        redirectFlag=1
        #redirect_to movies_path(order: session[:order],ratings: session[:ratings])
      else
        @ratings=Hash[@all_ratings.collect {|rating| [rating, rating]}]
        #puts @ratings
        @movies=@movies
      end
    end
    if params[:ratings]!= session[:ratings]
      session[:ratings]=@ratings
    end
    if redirectFlag==1
      flash.keep
      redirect_to movies_path(order: session[:order],ratings: session[:ratings])
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
  
 
end
