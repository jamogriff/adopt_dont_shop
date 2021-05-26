class AdminApplicationsController < ApplicationController

  def show
    @app = Application.find(params[:id])
  end

  def approve
    @app = Application.find(params[:id])
    pet = Pet.find(params[:pet_id])

    # Find individual record of pet on application
    pet_app = ApplicationPet.where(application_id: @app.id, pet_id: pet.id)

    # Note that due to current AR associations, this update
    # doesn't get passed on to applications
    pet_app.update(status: "Approved")
    render :show
  end

end
