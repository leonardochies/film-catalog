require 'rails_helper'

RSpec.describe "ImportJobs", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/import_jobs/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/import_jobs/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/import_jobs/create"
      expect(response).to have_http_status(:success)
    end
  end

end
