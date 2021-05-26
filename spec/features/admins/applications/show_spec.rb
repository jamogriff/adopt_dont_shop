require 'rails_helper'

RSpec.describe 'admin view of applications' do

  before :all do
    Pet.destroy_all
    Application.destroy_all
    @foothills = Shelter.create!(name: "Foothills Animal Shelter", city: "Golden", rank: 5, foster_program: true)
    @app = Application.create!(name: "Kelsie G", address: "3421 Sleepy Rd", city: "Boulder", state: "CO", zip: "81302", status: "In Progress", description: "I love animals. I enjoy watching shows on Saturday that all involve adopting dogs. I also enjoy watching clips on YouTube about adoption stories. I feel like I would be a terrific pet-owner and give a poor dog a forever home.")
    @barnaby = @foothills.pets.create!(name: "Barnaby", breed: "Cattle Dog", age: 1, adoptable: true)
    @sam = @foothills.pets.create!(name: "Sam", breed: "Labrador", age: 9, adoptable: true)
    @hodor = @foothills.pets.create!(name: "Hodor", breed: "Siamese", age: 4, adoptable: false)
  end

  it 'can approve a pet for adoption' do
    ApplicationPet.create!(application: @app, pet: @barnaby, status: @app.status)
    ApplicationPet.create!(application: @app, pet: @sam, status: @app.status)
    #[x] done

    #Approving a Pet for Adoption

    #As a visitor
    #When I visit an admin application show page ('/admin/applications/:id')
    #For every pet that the application is for, I see a button to approve the application for that specific pet
    #When I click that button
    #Then I'm taken back to the admin application show page
    #And next to the pet that I approved, I do not see a button to approve this pet
    #And instead I see an indicator next to the pet that they have been approved
    visit "/admins/applications/#{@app.id}"
    expect(page).to have_content @sam.name
    click_button "approve-#{@barnaby.id}"
    # Page then reloads
    expect(page).not_to have_button "approve-#{@barnaby.id}"
    within "div#pet-#{@barnaby.id}" do
      expect(page).to have_content "✓"
    end
  end

  it 'can reject pets' do
    ApplicationPet.create!(application: @app, pet: @barnaby, status: @app.status)
    ApplicationPet.create!(application: @app, pet: @sam, status: @app.status)
    #[x] done

    #Rejecting a Pet for Adoption

    #As a visitor
    #When I visit an admin application show page ('/admin/applications/:id')
    #For every pet that the application is for, I see a button to reject the application for that specific pet
    #When I click that button
    #Then I'm taken back to the admin application show page
    #And next to the pet that I rejected, I do not see a button to approve or reject this pet
    #And instead I see an indicator next to the pet that they have been rejected
    visit "/admins/applications/#{@app.id}"
    expect(page).to have_content @sam.name
    click_button "reject-#{@barnaby.id}"
    # Page then reloads
    expect(page).not_to have_button "reject-#{@barnaby.id}"
    expect(page).not_to have_button "approve-#{@barnaby.id}"
    within "div#pet-#{@barnaby.id}" do
      expect(page).to have_content "✘"
      expect(page).not_to have_content "✓"
    end
  end

  it 'takes away admin operations when all pets are approved' do
    ApplicationPet.create!(application: @app, pet: @barnaby, status: @app.status)
    ApplicationPet.create!(application: @app, pet: @sam, status: @app.status)
    #[ ] done

    #All Pets Accepted on an Application

    #As a visitor
    #When I visit an admin application show page
    #And I approve all pets for an application
    #Then I am taken back to the admin application show page
    #And I see the application's status has changed to "Approved"
    visit "/admins/applications/#{@app.id}"
    click_button "approve-#{@barnaby.id}"
    click_button "approve-#{@sam.id}"
    within "section#application-status" do
      expect(page).to have_content "Approved"
    end
  end

  it 'resolves application status when not all pets are approved' do
    ApplicationPet.create!(application: @app, pet: @barnaby, status: @app.status)
    ApplicationPet.create!(application: @app, pet: @sam, status: @app.status)
    #[ ] done

    #One or More Pets Rejected on an Application

    #As a visitor
    #When I visit an admin application show page
    #And I reject one or more pets for the application
    #And I approve all other pets on the application
    #Then I am taken back to the admin application show page
    #And I see the application's status has changed to "Rejected"
    visit "/admins/applications/#{@app.id}"
    click_button "approve-#{@barnaby.id}"
    click_button "reject-#{@sam.id}"
    within "section#application-status" do
      expect(page).to have_content "Rejected"
    end
  end

  it 'resolves conflicting application statuses when an application if approved' do
    @app_2 = Application.create!(name: "Kelsie G", address: "3421 Sleepy Rd", city: "Boulder", state: "CO", zip: "81302", status: "Pending", description: "I love animals. ")
    ApplicationPet.create!(application: @app, pet: @barnaby, status: "Pending")
    ApplicationPet.create!(application: @app_2, pet: @barnaby, status: "Pending")
    #[ ] done

    #As a visitor
    #When a pet has an "Approved" application on them
    #And when the pet has a "Pending" application on them
    #And I visit the admin application show page for the pending application
    #Then next to the pet I do not see a button to approve them
    #And instead I see a message that this pet has been approved for adoption
    #And I do see a button to reject them
    visit "/admins/applications/#{@app.id}"
    click_button "approve-#{@barnaby.id}"
    within "section#application-status" do
      expect(page).to have_content "Approved"
    end

    visit "/admins/applications/#{@app_2.id}"
    within "div#pet-#{@barnaby.id}" do
      expect(page).not_to have_button "approve-#{@barnaby.id}"
      expect(page).to have_content "This pet has been adopted!"
      expect(page).to have_button "reject-#{@barnaby.id}"
    end
  end
end
