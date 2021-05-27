require 'rails_helper'

RSpec.describe 'admin view of single shelter' do

  before :all do
    ApplicationPet.destroy_all
    Application.destroy_all
    Pet.destroy_all
    @shelter = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)
    @pet_1 = @shelter.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: false)
    @pet_2 = @shelter.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @pet_3 = @shelter.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
    @app_1 = Application.create!(name: "Kelsie G", address: "3421 Sleepy Rd", city: "Boulder", state: "CO", zip: "81302", status: "Pending", description: "I love animals.")
    @app_2 = Application.create!(name: "Jamo G", address: "3421 Sleepy Rd", city: "Boulder", state: "CO", zip: "81302", status: "Pending", description: "I love animals.")
    @app_3 = Application.create!(name: "Kevin", address: "3421 Sleepy Rd", city: "Boulder", state: "CO", zip: "81302", status: "Pending", description: "I love animals.")
    ApplicationPet.create!(application: @app_2, pet: @pet_2, status: "Pending")
    ApplicationPet.create!(application: @app_2, pet: @pet_3, status: "Approved")
    ApplicationPet.create!(application: @app_1, pet: @pet_3, status: "Pending")
    ApplicationPet.create!(application: @app_3, pet: @pet_3, status: "Pending")
  end

  describe 'showing pets that need to be reviewed' do
    it 'has list of pets that need to be reviewed' do
      visit "/admins/shelters/#{@shelter.id}"
      within 'section#action-area' do
        expect(page).not_to have_content @pet_1.name
        expect(page).to have_content @pet_2.name
        expect(page).to have_content @pet_3.name
      end
    end

    it 'has links to each pets applications' do
      visit "/admins/shelters/#{@shelter.id}"
      save_and_open_page
      within "div#pet-#{@pet_2.id}" do
        click_link "#{@app_2.name} from #{@app_2.city}"
        expect(current_path).to eq "/admins/applications/#{@app_2.id}"
      end
      visit "/admins/shelters/#{@shelter.id}"
      within "div#pet-#{@pet_3.id}" do
        click_link "#{@app_1.name} from #{@app_1.city}"
        expect(current_path).to eq "/admins/applications/#{@app_1.id}"
      end
      visit "/admins/shelters/#{@shelter.id}"
      within "div#pet-#{@pet_3.id}" do
        click_link "#{@app_3.name} from #{@app_3.city}"
        expect(current_path).to eq "/admins/applications/#{@app_3.id}"
      end
    end

  end

end
