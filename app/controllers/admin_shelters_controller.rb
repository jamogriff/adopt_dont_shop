class AdminSheltersController < ApplicationController

  def index
    @shelters = Shelter.order_by_reverse_name
    @shelters_with_apps = Shelter.has_pending_applications.order(:name)
  end

  def show
    @shelter = Shelter.find(params[:id])
  end
end
