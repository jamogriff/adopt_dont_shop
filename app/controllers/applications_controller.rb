class ApplicationsController < ApplicationController

  def index
  end

  def show
    @application = Application.find(params[:id])

    if params[:search].present?
      @pets = Pet.adoptable.search(params[:search])
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
    @application = Application.find(params[:id])
    # Needs to be fixed to provide error msg when description is blank
    if params[:description].present?
      @application.update(description: params[:description], status: params[:status])
    elsif params[:pet_id].present?
      pet = Pet.find(params[:pet_id])
      if !@application.pets.include?(pet)
      ApplicationPet.create!(pet: pet, application: @application)
      else
        return nil # not a great way to fix, since has no feedback, but prevents adding duplicates 
      end
    end
    redirect_to "/applications/#{params[:id]}"
  end

  private

  # will likely need to be tweaked for what forms needs to be required
  def app_params
    params.permit(:name, :address, :city, :state, :zip, :description, :status)
  end
end
