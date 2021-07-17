require 'rails_helper'

RSpec.describe MoviesController, :type => :controller do

  describe "GET index" do
    xit "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET new" do
    xit "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST create" do
    xit "returns http success" do
      post :create
      expect(response).to have_http_status(:success)
    end
  end

end
