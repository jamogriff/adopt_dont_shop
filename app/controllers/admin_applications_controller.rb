class AdminApplicationsController < ApplicationController

  def show
    @app = Application.find(params[:id])
  end

  # Method executes dependent on what :operation parameter is sent
  def update
    @app = Application.find(params[:id])
    pet = Pet.find(params[:pet_id])

    # Find individual record of pet on application
    pet_app = ApplicationPet.where(application_id: @app.id, pet_id: pet.id)
    if params[:operation] == "approve"
      # Note that due to current AR associations, this update
      # doesn't get passed on to applications
      pet_app.update(status: "Approved")
      # Checks all pet statuses, if all approved, then updates status on application
      @app.approval_process
    elsif params[:operation] == "reject"
      pet_app.update(status: "Rejected")
    end
    render :show
  end

end
