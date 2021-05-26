require 'rails_helper'

RSpec.describe 'admin view of applications' do

  before :all do
    Pet.destroy_all
    Application.destroy_all
    @foothills = Shelter.create!(name: "Foothills Animal Shelter", city: "Golden", rank: 5, foster_program: true)
    @app1 = Application.create!(name: "Kelsie G", address: "3421 Sleepy Rd", city: "Boulder", state: "CO", zip: "81302", status: "In Progress", description: "I love animals. I enjoy watching shows on Saturday that all involve adopting dogs. I also enjoy watching clips on YouTube about adoption stories. I feel like I would be a terrific pet-owner and give a poor dog a forever home.")
    @barnaby = @foothills.pets.create!(name: "Barnaby", breed: "Cattle Dog", age: 1, adoptable: true)
    @sam = @foothills.pets.create!(name: "Sam", breed: "Labrador", age: 9, adoptable: true)
    @hodor = @foothills.pets.create!(name: "Hodor", breed: "Siamese", age: 4, adoptable: false)
  end

  it 'can approve a pet for adoption' do
    ApplicationPet.create!(application: @app1, pet: @barnaby, status: @app1.status)
    yes = ApplicationPet.create!(application: @app1, pet: @sam, status: @app1.status)
    #[ ] done

    #Approving a Pet for Adoption

    #As a visitor
    #When I visit an admin application show page ('/admin/applications/:id')
    #For every pet that the application is for, I see a button to approve the application for that specific pet
    #When I click that button
    #Then I'm taken back to the admin application show page
    #And next to the pet that I approved, I do not see a button to approve this pet
    #And instead I see an indicator next to the pet that they have been approved
    visit "/admins/applications/#{@app1.id}"
#save_and_open_page
    expect(page).to have_content @sam.name
    click_button "approve-#{@barnaby.id}"
    # Page then reloads
    expect(page).not_to have_button "approve-#{@barnaby.id}"
    within "div#pet-#{@barnaby.id}" do
      expect(page).to have_content "✓"
    end
  end

end
