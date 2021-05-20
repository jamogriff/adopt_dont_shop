# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
foothills = Shelter.create!(name: "Foothills Animal Shelter", city: "Golden", rank: 5, foster_program: true)
dumb_friends = Shelter.create!(name: "Dumb Friend's League", city: "Aurora", rank: 3, foster_program: false)
davids = VeterinaryOffice.create!(name: "David's Vet Practice", max_patient_capacity: 13, boarding_services: false)
pinnacle = VeterinaryOffice.create!(name: "Pinnacle Pet", max_patient_capacity: 70, boarding_services: true)

foothills.pets.create!(name: "Sam", breed: "Labrador", age: 9, adoptable: true)
foothills.pets.create!(name: "Barnaby", breed: "Cattle Dog", age: 1, adoptable: true)
foothills.pets.create!(name: "Hodor", breed: "Siamese", age: 4, adoptable: false)
dumb_friends.pets.create!(name: "Bagel", breed: "Tabby", age: 12, adoptable: true)
dumb_friends.pets.create!(name: "Gogol", breed: "Golden Retriever", age: 6, adoptable: true)
dumb_friends.pets.create!(name: "Prince", breed: "Husky", age: 2, adoptable: false)

davids.veterinarians.create!(name: "David Crosby", review_rating: 4, on_call: false)
davids.veterinarians.create!(name: "Stephen Stills", review_rating: 5, on_call: false)
pinnacle.veterinarians.create!(name: "Miriam Sidney", review_rating: 3, on_call: true)
pinnacle.veterinarians.create!(name: "Marvo Diagletti", review_rating: 2, on_call: true)
pinnacle.veterinarians.create!(name: "Clyde", review_rating: 1, on_call: true)
