require 'rails_helper'

RSpec.describe Application do

  before :each do
      foothills = Shelter.create!(name: "Foothills Animal Shelter", city: "Golden", rank: 5, foster_program: true)
      @app = Application.create!(name: "Kelsie G", address: "3421 Sleepy Rd", city: "Boulder", state: "CO", zip: "81302", status: "In Progress", description: "I love animals. I enjoy watching shows on Saturday that all involve adopting dogs. I also enjoy watching clips on YouTube about adoption stories. I feel like I would be a terrific pet-owner and give a poor dog a forever home.")
      @barnaby = foothills.pets.create!(name: "Barnaby", breed: "Cattle Dog", age: 1, adoptable: true)
      @sam = foothills.pets.create!(name: "Sam", breed: "Labrador", age: 9, adoptable: true)
      @hodor = foothills.pets.create!(name: "Hodor", breed: "Siamese", age: 4, adoptable: false)
  end

  describe 'relationships' do
    it { should have_many :application_pets }

    it { should have_many(:pets).through(:application_pets) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:address) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:zip) }
  end

  describe 'methods' do
    it 'returns correct boolean dependent on pets added' do
      expect(@app.is_ready).to eq false
      ApplicationPet.create!(application: @app, pet: @sam)
      expect(@app.is_ready).to eq true
      ApplicationPet.create!(application: @app, pet: @barnaby)
      expect(@app.is_ready).to eq true
    end

    it 'flags when application has been submitted' do
      ApplicationPet.create!(application: @app, pet: @sam)
      ApplicationPet.create!(application: @app, pet: @barnaby)
      expect(@app.submitted).to eq false
      @app.update(status: "Pending")
      expect(@app.submitted).to eq true
    end

    describe '#approval_check' do
      it 'returns false when not all pet applications are approved' do
        ApplicationPet.create!(application: @app, pet: @sam, status: "Approved")
        ApplicationPet.create!(application: @app, pet: @barnaby, status: "Pending")
        expect(@app.approval_check).to eq false
      end

      it 'returns true when all pet applications are approved' do
        ApplicationPet.create!(application: @app, pet: @sam, status: "Approved")
        ApplicationPet.create!(application: @app, pet: @barnaby, status: "Approved")
        expect(@app.approval_check).to eq true
      end
    end

    describe '#rejects_exist' do
      it 'returns true when any pet applications are rejected' do
        ApplicationPet.create!(application: @app, pet: @sam, status: "Approved")
        ApplicationPet.create!(application: @app, pet: @barnaby, status: "Rejected")
        expect(@app.rejects_exist).to eq true
      end

      it 'returns false when no pet applications are rejected' do
        ApplicationPet.create!(application: @app, pet: @sam, status: "Approved")
        ApplicationPet.create!(application: @app, pet: @barnaby, status: "Approved")
        expect(@app.rejects_exist).to eq false
      end
    end

    describe '#review_complete' do
      it 'returns true if all application records are accepted or rejected' do
        ApplicationPet.create!(application: @app, pet: @sam, status: "Approved")
        ApplicationPet.create!(application: @app, pet: @barnaby, status: "Rejected")
        expect(@app.review_complete).to eq true
      end

      it 'returns false if not all applications have been reviewed' do
        ApplicationPet.create!(application: @app, pet: @sam, status: "Approved")
        ApplicationPet.create!(application: @app, pet: @barnaby, status: "Pending")
        expect(@app.review_complete).to eq false
      end
    end

    describe '#approval_process' do
      it 'approves applications and sets pet adoptable attr' do
        ApplicationPet.create!(application: @app, pet: @sam, status: "Approved")
        ApplicationPet.create!(application: @app, pet: @barnaby, status: "Approved")
        expect(@app.status).not_to eq 'Approved'
        expect(@sam.adoptable).to eq true
        @app.approval_process # updates pet attr in database
        expect(@app.status).to eq 'Approved'
        # Reload is used to query the database again for the updated value-- otherwise Rails just uses the original attributes when @sam was created.
        expect(@sam.reload.adoptable).to eq false
      end

      it 'rejects applications' do
        ApplicationPet.create!(application: @app, pet: @sam, status: "Approved")
        ApplicationPet.create!(application: @app, pet: @barnaby, status: "Rejected")
        expect(@app.status).to eq @app.status
        @app.approval_process
        expect(@app.status).to eq 'Rejected'
      end
      
      it 'does nothing until all apps have been reviewed' do
        ApplicationPet.create!(application: @app, pet: @sam, status: "Pending")
        ApplicationPet.create!(application: @app, pet: @barnaby, status: "Rejected")
        expect(@app.status).to eq @app.status
        @app.approval_process
        expect(@app.status).to eq @app.status
      end
    end
  end
end
