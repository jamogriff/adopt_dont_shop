require 'rails_helper'

RSpec.describe 'admin shelters index page' do

  before(:all) do
    Shelter.destroy_all
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    @shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)
    @pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: false)
    @pet_2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @pet_3 = @shelter_3.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
    app_1 = Application.create!(name: "Kelsie G", address: "3421 Sleepy Rd", city: "Boulder", state: "CO", zip: "81302", status: "Pending", description: "I love animals.")
    app_2 = Application.create!(name: "Jamo G", address: "3421 Sleepy Rd", city: "Boulder", state: "CO", zip: "81302", status: "In Progress", description: "I love animals.")
    app_2.pets << @pet_2
    app_2.pets << @pet_1
    app_1.pets << @pet_3
  end

  it 'displays correct order' do
    visit '/admins/shelters'
    expect(@shelter_2.name).to appear_before(@shelter_3.name)
    expect(@shelter_3.name).to appear_before(@shelter_1.name)
  end

  it 'has a section for pending applications' do
    #For this story, you should fully leverage ActiveRecord methods in your query.

    #Shelters with Pending Applications

    #As a visitor
    #When I visit the admin shelter index ('/admin/shelters')
    #Then I see a section for "Shelter's with Pending Applications"
    #And in this section I see the name of every shelter that has a pending application
    visit '/admins/shelters'
    
    within 'section#pending' do
      expect(page).to have_content @shelter_3.name
      expect(page).not_to have_content @shelter_3.name
      expect(page).not_to have_content @shelter_3.name
    end
  end
end
