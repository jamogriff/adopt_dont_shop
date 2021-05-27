class AdminSheltersController < ApplicationController

  def index
    @shelters = Shelter.order_by_reverse_name
    @shelters_with_apps = Shelter.has_pending_applications.order(:name)
  end

  def show
    @shelter = Shelter.find(params[:id])
    @details = Shelter.info_on(@shelter.id) # Not really sure why this was requested other than to practice SQL
  end
end
