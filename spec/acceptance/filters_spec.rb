require 'rails_helper'
require 'capybara/rails'
require 'support/pages/movie_list'
require 'support/with_user'

RSpec.describe 'filters movie list', type: :feature do

  let(:page) { Pages::MovieList.new }

  before do
    author = User.create(
      uid: 'null|12345',
      name: 'Bob'
    )
    @m_empire = Movie.create(
      title: 'Empire strikes back',
      description: 'Who\'s scruffy-looking?',
      date: '1980-05-21',
      created_at: Time.parse('2014-10-01 10:30 UTC').to_i,
      user: author,
      liker_count: 50,
      hater_count: 2
    )
    @m_turtles = Movie.create(
      title: 'Teenage mutant nija turtles',
      description: 'Technically, we\'re turtles.',
      date: '2014-10-17',
      created_at: Time.parse('2014-10-01 10:35 UTC').to_i,
      user: author,
      liker_count: 1,
      hater_count: 237
    )

    @titles = [@m_empire, @m_turtles].map(&:title)
  end

  context 'when logged in' do
    with_logged_in_user

    before { page.open }

    it 'can filter by my_liked' do
      page.like('Empire strikes back')
      page.filter_by('my_liked')
      expect(page.movie_titles).to eq([@m_empire.title])
    end

    it 'can filter by my_hated' do
      page.hate('Teenage mutant nija turtles')
      page.filter_by('my_hated')
      expect(page.movie_titles).to eq([@m_turtles.title])
    end

    describe "within user list" do
      before do
        page.within first(".mr-movie") do
          page.click_link "Bob"
        end
      end

      it 'can filter by my_liked' do
        page.like('Empire strikes back')
        page.filter_by('my_liked')
        expect(page.movie_titles).to eq([@m_empire.title])
      end

      it 'can filter by my_hated' do
        page.hate('Teenage mutant nija turtles')
        page.filter_by('my_hated')
        expect(page.movie_titles).to eq([@m_turtles.title])
      end
    end
  end

  context "when not logged in" do
    before { page.open }

    it 'cannot filter' do
      expect(page).not_to have_filter
    end
  end
end




