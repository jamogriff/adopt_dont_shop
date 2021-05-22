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
    # check to see order etc
    # still needs a route
  end

end
