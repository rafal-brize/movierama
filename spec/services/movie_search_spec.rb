require 'rails_helper'

RSpec.describe MovieSearch do
  it "returns all movies by default" do
    bob = create_user(name: 'bob')
    movie = create_movie(user: bob)

    expect(described_class.new.call).to eq [movie]
  end

  it "restricts movies to the owner if provided" do
    bob = create_user(name: 'bob')
    alex = create_user(name: 'alex')
    bobs_movie = create_movie(user: bob)
    alexs_movie = create_movie(user: alex)
    expect(described_class.new(creator_id: bob.id).call).to eq [bobs_movie]
    expect(described_class.new(creator_id: "fake_id").call).to be_empty
    expect(described_class.new.call).to match_array([bobs_movie, alexs_movie])
  end

  it "sorts movies by likers, same as default" do
    bob = create_user(name: 'bob')
    bobs_movie_1 = create_movie(user: bob, liker_count: 1)
    bobs_movie_2 = create_movie(user: bob, liker_count: 2)

    expect(described_class.new.call).to eq [bobs_movie_2, bobs_movie_1]
    expect(described_class.new(sort: 'likers').call).to eq [bobs_movie_2, bobs_movie_1]
  end

  it "sorts_movies by haters" do
    bob = create_user(name: 'bob')
    bobs_movie_1 = create_movie(user: bob, hater_count: 1)
    bobs_movie_2 = create_movie(user: bob, hater_count: 2)

    expect(described_class.new(sort: 'haters').call).to eq [bobs_movie_2, bobs_movie_1]
  end

  it "sorts_movies by date" do
    bob = create_user(name: 'bob')
    bobs_movie_1 = create_movie(user: bob, date: '2014-10-17')
    bobs_movie_2 = create_movie(user: bob, date: '2015-10-17')

    expect(described_class.new(sort: 'date').call).to eq [bobs_movie_2, bobs_movie_1]
  end

  def create_user(name:)
    User.create(name: name)
  end

  def create_movie(user:, **overrides)
    Movie.create(
      title:        'Teenage mutant nija turtles',
      description:  'Technically, we\'re turtles.',
      date:         '2014-10-17',
      user:         user,
      liker_count:  1,
      hater_count:  237,
      **overrides
    )
  end
end
