require 'httparty'

class GithubResultsController < ApplicationController
  def index; end

  def search
    unless repository_params[:repositories].present?
      flash[:alert] = 'Enter search text'
      return render action: :index
    end
    repositories = get_repositories("https://api.github.com/search/repositories?q=#{repository_params[:repositories]}&per_page=100")
    @repos = repositories['items'].paginate(page: params[:page], :per_page => 10)
    @total_count = @repos.length

    if @total_count == 0
      flash[:alert] = 'Search returned 0 results'
      return render action: :index
    end


    render action: :index
  end

  private

  def repository_params
    params.permit(:repositories, :button, :page)
  end

  def get_repositories(url)
    response = Rails.cache.fetch(url, :expires => 1.hour) do
      HTTParty.get(url)
    end
    # byebug
    JSON.parse(response.body)
  end
end
