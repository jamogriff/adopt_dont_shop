class ApplicationsController < ApplicationController

  def index
  end

  def show
    @application = Application.find(params[:id])

    if params[:search].present?
      @pets = Pet.search(params[:search])
    else
      @pets = Pet.adoptable
    end
  end

  def new
  end

  def create
    app = Application.new(app_params)
    # Conditional logic to check required fields from model
    if app.save
      redirect_to "/applications/#{app.id}"
    else
      redirect_to "/applications/new"
      flash[:alert] = "Error: #{error_message(app.errors)}"
    end
  end

  def update
    # Probably should add a check here to see if pet already exists
    # in Application.pets
    # Likewise, restructuring conditional to be more explicit WIP
    app = Application.find(params[:id])
    if params[:description].present?
      app.update(description: params[:description], status: params[:status])
    else
      added_pet = ApplicationPet.create!(pet: Pet.find(params[:pet_id]), application: app)
    end
    redirect_to "/applications/#{params[:id]}"
  end

  private

  # will likely need to be tweaked for what forms needs to be required
  def app_params
    params.permit(:name, :address, :city, :state, :zip, :description, :status)
  end
end
