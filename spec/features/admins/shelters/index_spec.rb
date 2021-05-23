require 'rails_helper'

RSpec.describe 'admin shelters index page' do

  before(:each) do
    Shelter.destroy_all
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    @shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)
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
    
  end
end
