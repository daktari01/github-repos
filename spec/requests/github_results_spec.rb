require 'rails_helper'

RSpec.describe "GithubResults", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/github_results/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /search", type: :request do
    let(:params) do
      {
        repositories: 'test'
      }
    end
    let(:missing_params) do
      {
        repositories: ''
      }
    end
    let(:no_result_params) do
      {
        repositories: 'gdhhsskaoannriuyehnisk'
      }
    end
    it "returns http success" do
      get "/search", params: params
      expect(response).to have_http_status(:success)
    end

    it "returns error message when no parameter is passed" do
      get "/search", params: missing_params
      expect(response.body).to include('Enter search text')
    end

    it "returns warning message when no result is returned" do
      get "/search", params: no_result_params
      expect(response.body).to include('Search returned 0 results')
    end
  end

end
