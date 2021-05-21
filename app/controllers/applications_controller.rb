class ApplicationsController < ApplicationController

  def index
  end

  def show
    @application = Application.find(params[:id])
  end

  def new
  end

  def create
    app = Application.create!(application_params)
    redirect_to "/applications/#{app.id}"
  end

  private

  # will likely need to be tweaked for what forms needs to be required
  def application_params
    params.permit(:name, :address, :city, :state, :zip, :description, :status)
  end
end
