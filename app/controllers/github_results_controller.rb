require 'httparty'

class GithubResultsController < ApplicationController
  def index; end

  def search
    unless repository_params[:repositories].present?
      flash[:alert] = 'Enter search text'
      return render action: :index
    end
    # @total_count = 0
    # current_page = 1
    # @repos = []
    # while @total_count < 1000
    #   result = get_repositories("https://api.github.com/search/repositories?q=#{repository_params[:repositories]}&per_page=100&page=#{current_page}")
    #   page_count = result['items'].length
    #   @total_count += result['items'].length
    #   @repos += result['items']
    #   current_page += 1
    #   break if page_count < 100
    # end

    @loading = true
    repositories = get_repositories("https://api.github.com/search/repositories?q=#{repository_params[:repositories]}&per_page=100")
    @loading = false
    @repos = repositories['items']
    @total_count = @repos.length

    if @total_count == 0
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
    # byebug
    JSON.parse(response.body)
  end
end
