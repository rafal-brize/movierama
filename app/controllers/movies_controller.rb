class MoviesController < ApplicationController
  def index
    @movies = MovieSearch.new(
      scope: Movie.all, creator_id: _index_params[:user_id],
      current_user: current_user, sort: _index_params[:by], filter: _index_params[:filter]
    ).call
  end

  def new
    authorize! :create, Movie

    @movie = Movie.new
    @validator = NullValidator.instance
  end

  def create
    authorize! :create, Movie

    attrs = _create_params.merge(user: current_user)
    @movie = Movie.new(attrs)
    @validator = MovieValidator.new(@movie)

    if @validator.valid?
      @movie.save
      flash[:notice] = "Movie added"
      redirect_to root_url
    else
      flash[:error] = "Errors were detected"
      render 'new'
    end
  end

  private

  def _index_params
    params.permit(:by, :user_id, :filter)
  end

  def _create_params
    params.permit(:title, :description, :date)
  end
end
