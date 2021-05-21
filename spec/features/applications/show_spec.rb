require 'rails_helper'

RSpec.describe 'application info page' do

  before :all do
    foothills = Shelter.create!(name: "Foothills Animal Shelter", city: "Golden", rank: 5, foster_program: true)
    @app1 = Application.create!(name: "Jamison G", address: "123 Wayward Way", city: "Denver", state: "CO", zip: "80122", status: "Pending", description: "I am a good person and have had several pets before. My mom can vouch for my excellent pet care.")
    @app2 = Application.create!(name: "Kelsie G", address: "3421 Sleepy Rd", city: "Boulder", state: "CO", zip: "81302", status: "In Progress", description: "I love animals. I enjoy watching shows on Saturday that all involve adopting dogs. I also enjoy watching clips on YouTube about adoption stories. I feel like I would be a terrific pet-owner and give a poor dog a forever home.")
    @barnaby = foothills.pets.create!(name: "Barnaby", breed: "Cattle Dog", age: 1, adoptable: true)
    @sam = foothills.pets.create!(name: "Sam", breed: "Labrador", age: 9, adoptable: true)
    @hodor = foothills.pets.create!(name: "Hodor", breed: "Siamese", age: 4, adoptable: false)
    ApplicationPet.create!(application: @app1, pet: @barnaby)
    ApplicationPet.create!(application: @app1, pet: @sam)
    ApplicationPet.create!(application: @app2, pet: @hodor)
    ApplicationPet.create!(application: @app2, pet: @barnaby)
  end

  it 'should display correct applicant info' do
    #[x] done

    #Application Show Page

    #As a visitor
    #When I visit an applications show page
    #Then I can see the following:
    #- Name of the Applicant
    #- Full Address of the Applicant including street address, city, state, and zip code
    #- Description of why the applicant says they'd be a good home for this pet(s)
    #- names of all pets that this application is for (all names of pets should be links to their show page)
    #- The Application's status, either "In Progress", "Pending", "Accepted", or "Rejected"
    visit "/applications/#{@app1.id}"

    expect(page).to have_content @app1.name
    expect(page).to have_content @app1.address
    expect(page).to have_content @app1.state
    expect(page).to have_content @app1.zip
    expect(page).to have_content @app1.city
    expect(page).to have_content @app1.status
    expect(page).to have_content @app1.description
    expect(page).to have_content @barnaby.name
    expect(page).to have_content @sam.name
    expect(page).not_to have_content @hodor.name
    click_link @barnaby.name
    expect(current_path).to eq "/pets/#{@barnaby.id}"
  end

end  
