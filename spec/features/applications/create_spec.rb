require 'rails_helper'

RSpec.describe 'application creation' do

  describe 'the new view' do
    it 'renders the new form' do
      visit "/applications/new"

      expect(page).to have_content('New Application')
      expect(find('form')).to have_content('Name')
      expect(find('form')).to have_content('Address')
      expect(find('form')).to have_content('City')
      expect(find('form')).to have_content('State')
      expect(find('form')).to have_content('Zip code')
    end
  end

  describe 'application creation' do
    context 'given complete and valid data' do
      it 'creates application and redirects to the application show page' do
        #When I fill in this form with my:
          #- Name
          #- Street Address
          #- City
          #- State
          #- Zip Code
        #And I click submit
        #Then I am taken to the new application's show page
        #And I see my Name, address information, and description of why I would make a good home
        #And I see an indicator that this application is "In Progress"
        visit "/applications/new"

        fill_in 'name', with: 'John Smith'
        fill_in 'address', with: '666 Vampire Dr'
        fill_in 'city', with: 'Dayton'
        fill_in 'state', with: 'Ohio'
        fill_in 'zip', with: '40221'
        click_button 'Start Application'
        new_app_id = Application.last.id
        expect(page).to have_current_path("/applications/#{new_app_id}")
        expect(page).to have_content "In Progress"
      end
    end

    context 'given incomplete data' do
      it 'renders the new form' do
        visit "/applications/new"

        click_button 'Start Application'
        expect(page).to have_current_path("/applications/new")
        expect(page).to have_content("Error: Name can't be blank, Address can't be blank, City can't be blank, State can't be blank, Zip can't be blank")
      end
    end
  end
end
