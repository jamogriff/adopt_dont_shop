require 'rails_helper'

RSpec.describe Pet, type: :model do
  describe 'relationships' do
    it { should belong_to(:shelter) }
    it { should have_many :application_pets }
    it { should have_many(:applications).through(:application_pets) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:age) }
    it { should validate_numericality_of(:age) }
  end

  before(:each) do
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    @pet_2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @pet_3 = @shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 3, adoptable: false)
  end

  describe 'class methods' do
    describe '#search' do
      it 'returns partial matches' do
        expect(Pet.search("Claw")).to eq([@pet_2])
      end
    end

    describe '#adoptable' do
      it 'returns adoptable pets' do
        skip "Fix this later"
        expect(Pet.adoptable).to eq([@pet_1, @pet_2])
      end
    end
  end

  describe 'instance methods' do
    describe '.shelter_name' do
      it 'returns the shelter name for the given pet' do
        expect(@pet_3.shelter_name).to eq(@shelter_1.name)
      end
    end

    describe '#is_approved' do
      it 'returns correct boolean' do
        app = Application.create!(name: "Kelsie G", address: "3421 Sleepy Rd", city: "Boulder", state: "CO", zip: "81302", status: "In Progress", description: "I love animals. ")
        pet1_record = ApplicationPet.create!(application: app, pet: @pet_1, status: "Approved")
        pet2_record = ApplicationPet.create!(application: app, pet: @pet_2, status: "Pending")

        expect(@pet_1.is_approved_on(app.id)).to eq true
        expect(@pet_2.is_approved_on(app.id)).to eq false
      end
    end

    describe '#is_rejected' do
      it 'returns correct boolean' do
        app = Application.create!(name: "Kelsie G", address: "3421 Sleepy Rd", city: "Boulder", state: "CO", zip: "81302", status: "In Progress", description: "I love animals. ")
        pet1_record = ApplicationPet.create!(application: app, pet: @pet_1, status: "Rejected")
        pet2_record = ApplicationPet.create!(application: app, pet: @pet_2, status: "Pending")

        expect(@pet_1.is_rejected_on(app.id)).to eq true
        expect(@pet_2.is_rejected_on(app.id)).to eq false
      end
    end

    it 'lists a pet\'s pending applications' do
        app_1 = Application.create!(name: "Kelsie G", address: "3421 Sleepy Rd", city: "Boulder", state: "CO", zip: "81302", status: "In Progress", description: "I love animals. ")
        app_2 = Application.create!(name: "Jamo G", address: "3421 Sleepy Rd", city: "Boulder", state: "CO", zip: "81302", status: "In Progress", description: "I love animals. ")
        ApplicationPet.create!(application: app_1, pet: @pet_1, status: "Pending")
        ApplicationPet.create!(application: app_2, pet: @pet_1, status: "Pending")
        expect(@pet_1.pending_applications.first.name).to eq app_1.name
        expect(@pet_1.pending_applications[1].name).to eq app_2.name
    end
  end
end
