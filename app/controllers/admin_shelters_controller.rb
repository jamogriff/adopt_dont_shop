class AdminSheltersController < ApplicationController

  def index
    @shelters = Shelter.order_by_reverse_name
    @shelters_with_apps = Shelter.has_pending_applications
  end
end
