class MovieSearch
  ALL = 'all'.freeze

  def initialize(scope: Movie.all, creator_id: nil, current_user: nil, sort: nil, filter: nil)
    @scope = scope
    @creator_id = creator_id == ALL ? nil : creator_id
    @current_user = current_user
    @sort = sort || 'likers'
    @filter = filter == ALL ? nil : filter

    raise ArgumentError("Need current user to filter") if @filter.present? && @current_user.blank?
  end

  def call
    apply_creator_scope
    apply_sort
    apply_filter

    scope.to_a
  end

  private

  def apply_creator_scope
    @scope = Movie.find(user_id: creator_id) if creator_id
  end

  def apply_sort
    @scope = case sort
             when 'likers'
               scope.sort(by: 'Movie:*->liker_count', order: 'DESC')
             when 'haters'
               scope.sort(by: 'Movie:*->hater_count', order: 'DESC')
             when 'date'
               scope.sort(by: 'Movie:*->created_at', order: 'DESC')
             else
               scope
             end
  end

  def apply_filter
    @scope = case filter
             when 'my_liked'
               scope.to_a.select { |movie| movie.likers.include?(current_user) }
             when 'my_hated'
               scope.to_a.select { |movie| movie.haters.include?(current_user) }
             else
               scope
             end
  end

  attr_reader :scope, :creator_id, :current_user, :sort, :filter
end
