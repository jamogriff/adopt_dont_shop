require 'rails_helper'

RSpec.describe Shelter, type: :model do
  describe 'relationships' do
    it { should have_many(:pets) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:rank) }
    it { should validate_numericality_of(:rank) }
  end

  before(:each) do
    Shelter.destroy_all
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    @shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)
    @pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: false)
    @pet_2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @pet_3 = @shelter_3.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
    @pet_4 = @shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 5, adoptable: true)
  end

  describe 'class methods' do
    describe '#search' do
      it 'returns partial matches' do
        expect(Shelter.search("Fancy")).to eq([@shelter_3])
      end
    end

    describe '#order_by_reverse_name' do
      it 'orders by reverse alphabetical' do
        expect(Shelter.order_by_reverse_name).to eq([@shelter_2, @shelter_3, @shelter_1])
      end
    end

    describe '#order_by_recently_created' do
      it 'returns shelters with the most recently created first' do
        skip "Implemented prior to project start"
        expect(Shelter.order_by_recently_created).to eq([@shelter_3, @shelter_2, @shelter_1])
      end
    end

    describe '#order_by_number_of_pets' do
      it 'orders the shelters by number of pets they have, descending' do
        skip "Implemented prior to project start"
        expect(Shelter.order_by_number_of_pets).to eq([@shelter_1, @shelter_3, @shelter_2])
      end
    end
  end

  describe 'instance methods' do
    describe '.adoptable_pets' do
      it 'only returns pets that are adoptable' do
        expect(@shelter_1.adoptable_pets).to eq([@pet_2, @pet_4])
      end
    end

    describe '.alphabetical_pets' do
      it 'returns pets associated with the given shelter in alphabetical name order' do
        expect(@shelter_1.alphabetical_pets).to eq([@pet_4, @pet_2])
      end
    end

    describe '.shelter_pets_filtered_by_age' do
      it 'filters the shelter pets based on given params' do
        expect(@shelter_1.shelter_pets_filtered_by_age(5)).to eq([@pet_4])
      end
    end

    describe '.pet_count' do
      it 'returns the number of pets at the given shelter' do
        expect(@shelter_1.pet_count).to eq(3)
      end
    end

    describe '::info' do
      it 'returns name and address only' do
        expect(Shelter.info_on(@shelter_1.id).name).to eq @shelter_1.name
        expect(Shelter.info_on(@shelter_1.id).city).to eq @shelter_1.city
      end
    end

    describe '#has_pending_applications' do
      it 'returns shelters' do
        app_1 = Application.create!(name: "Kelsie G", address: "3421 Sleepy Rd", city: "Boulder", state: "CO", zip: "81302", status: "Pending", description: "I love animals.")
        app_2 = Application.create!(name: "Jamo G", address: "3421 Sleepy Rd", city: "Boulder", state: "CO", zip: "81302", status: "In Progress", description: "I love animals.")
        app_2.pets << @pet_2
        app_2.pets << @pet_1
        app_1.pets << @pet_3

        expect(Shelter.has_pending_applications).to eq([@shelter_3])
      end
    end

    describe 'statistical methods' do
      it 'returns average age of adoptable pets' do
        exp_val = 8 / 2.to_f
        expect(@shelter_1.adoptable_avg_age).to eq exp_val
      end

      it 'returns count of adoptable pets' do 
        expect(@shelter_1.adoptable_count).to eq 2
      end

      it 'returns count of adopted pets' do 
        expect(@shelter_1.number_adopted).to eq 1
      end
    end

    describe 'methods for admin view of a shelter' do
      it 'lists the pets not reviewed' do
        @app_1 = Application.create!(name: "Kelsie G", address: "3421 Sleepy Rd", city: "Boulder", state: "CO", zip: "81302", status: "Pending", description: "I love animals.")
        @app_2 = Application.create!(name: "Jamo G", address: "3421 Sleepy Rd", city: "Boulder", state: "CO", zip: "81302", status: "Pending", description: "I love animals.")
        @app_record_1 = ApplicationPet.create!(application: @app_2, pet: @pet_2, status: "Pending")
         @app_record_2 = ApplicationPet.create!(application: @app_2, pet: @pet_1, status: "Approved")
         @app_record_3 = ApplicationPet.create!(application: @app_1, pet: @pet_4, status: "Pending")
        expect(@shelter_1.pets_not_reviewed).to eq [@pet_2, @pet_4]
      end
    end
  end
end
