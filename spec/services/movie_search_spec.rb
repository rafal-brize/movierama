require 'rails_helper'

RSpec.describe MovieSearch do
  it "returns all movies by default" do
    bob = create_user
    movie = create_movie(user: bob)

    expect(described_class.new.call).to eq [movie]
  end

  def create_user
    User.create(
      uid:  'null|67890',
      name: 'Bob'
    )
  end

  def create_movie(user:)
    Movie.create(
      title:        'Teenage mutant nija turtles',
      description:  'Technically, we\'re turtles.',
      date:         '2014-10-17',
      user:         user,
      liker_count:  1,
      hater_count:  237
    )
  end
end
