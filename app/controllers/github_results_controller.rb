require 'httparty'

class GithubResultsController < ApplicationController
  def index; end

  def search
    unless repository_params[:repositories].present?
      flash[:alert] = 'Enter search text'
      return render action: :index
    end
    @repositories = get_repositories("https://api.github.com/search/repositories?q=#{repository_params[:repositories]}")
    if @repositories['total_count'] == 0
      flash[:alert] = 'Search returned 0 results'
      return render action: :index
    end
    render action: :index
  end

  private

  def repository_params
    params.permit(:repositories, :button)
  end

  def get_repositories(url)
    response = Rails.cache.fetch(url, :expires => 1.hour) do
      HTTParty.get(url)
    end
    JSON.parse(response.body)
  end
end
