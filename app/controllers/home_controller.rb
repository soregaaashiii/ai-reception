class HomeController < ApplicationController
  def show
    @organization = current_organization
  end
end
