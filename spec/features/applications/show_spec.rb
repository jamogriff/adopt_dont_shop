require 'rails_helper'

RSpec.describe 'application info page' do

  before :all do
    Pet.destroy_all
    Application.destroy_all
    foothills = Shelter.create!(name: "Foothills Animal Shelter", city: "Golden", rank: 5, foster_program: true)
    @app1 = Application.create!(name: "Kelsie G", address: "3421 Sleepy Rd", city: "Boulder", state: "CO", zip: "81302", status: "In Progress", description: "I love animals. I enjoy watching shows on Saturday that all involve adopting dogs. I also enjoy watching clips on YouTube about adoption stories. I feel like I would be a terrific pet-owner and give a poor dog a forever home.")
    @barnaby = foothills.pets.create!(name: "Barnaby", breed: "Cattle Dog", age: 1, adoptable: true)
    @sam = foothills.pets.create!(name: "Sam", breed: "Labrador", age: 9, adoptable: true)
    @hodor = foothills.pets.create!(name: "Hodor", breed: "Siamese", age: 4, adoptable: false)
  end

  it 'should display correct applicant info' do
    skip "Test written for end state of application"
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

  it 'has a search functionality for pets' do
    #[x] done

    #Searching for Pets for an Application

    #As a visitor
    #When I visit an application's show page
    #And that application has not been submitted,
    #Then I see a section on the page to "Add a Pet to this Application"
    #In that section I see an input where I can search for Pets by name
    #When I fill in this field with a Pet's name
    #And I click submit,
    #Then I am taken back to the application show page
    #And under the search bar I see any Pet whose name matches my search
    visit "/applications/#{@app1.id}"
    within "section#add-a-pet" do
      expect(page).to have_content("Add a Pet to this Application")
      fill_in 'search', with: "Barnaby"
      click_button 'Search'
      expect(current_path).to eq "/applications/#{@app1.id}"
      expect(page).to have_content @barnaby.name
      expect(page).not_to have_content @sam.name
    end
  end

  it 'can add a pet to an application' do
    #[x] done

    #Add a Pet to an Application

    #As a visitor
    #When I visit an application's show page
    #And I search for a Pet by name
    #And I see the names Pets that match my search
    #Then next to each Pet's name I see a button to "Adopt this Pet"
    #When I click one of these buttons
    #Then I am taken back to the application show page
    #And I see the Pet I want to adopt listed on this application
    visit "/applications/#{@app1.id}"
    fill_in 'search', with: "Barnaby"
    click_button 'Search'
    click_button "add-#{@barnaby.id}"
    within "td#pets" do
      expect(page).to have_content(@barnaby.name)
    end
  end

  it 'should be able to submit an application' do
    #[x] done

    #Submit an Application

    #As a visitor
    #When I visit an application's show page
    #And I have added one or more pets to the application
    #Then I see a section to submit my application
    #And in that section I see an input to enter why I would make a good owner for these pet(s)
    #When I fill in that input
    #And I click a button to submit this application
    #Then I am taken back to the application's show page
    #And I see an indicator that the application is "Pending"
    #And I see all the pets that I want to adopt
    #And I do not see a section to add more pets to this application
    visit "/applications/#{@app1.id}"
    expect(page).not_to have_content("please describe why you would make a great pet owner below:") 
    click_button "add-#{@sam.id}"
    expect(page).to have_content("please describe why you would make a great pet owner below:") 
    click_button "add-#{@barnaby.id}"
    fill_in "description", with: "i need dog to love. i am sad, please help me"
    click_button "Submit Application"
    expect(page).to have_content("Pending")
    expect(page).to have_content @sam.name
    expect(page).to have_content @barnaby.name
    expect(page).not_to have_content("Add a Pet to this Application") 
  end
end  
