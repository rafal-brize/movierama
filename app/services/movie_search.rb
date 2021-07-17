class MovieSearch
  def initialize(scope: Movie.all, creator: nil, current_user: nil, sort: nil, filter: nil)
    @scope = scope
    @creator = creator
    @current_user = current_user
    @sort = sort
    @filter = filter
  end

  def call
    scope.to_a
  end

  attr_reader :scope, :creator, :current_user, :sort, :filter
end
