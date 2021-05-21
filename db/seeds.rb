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

sam = foothills.pets.create!(name: "Sam", breed: "Labrador", age: 9, adoptable: true)
barnaby = foothills.pets.create!(name: "Barnaby", breed: "Cattle Dog", age: 1, adoptable: true)
hodor = foothills.pets.create!(name: "Hodor", breed: "Siamese", age: 4, adoptable: false)
bagel = dumb_friends.pets.create!(name: "Bagel", breed: "Tabby", age: 12, adoptable: true)
gogol = dumb_friends.pets.create!(name: "Gogol", breed: "Golden Retriever", age: 6, adoptable: true)
prince = dumb_friends.pets.create!(name: "Prince", breed: "Husky", age: 2, adoptable: false)

davids.veterinarians.create!(name: "David Crosby", review_rating: 4, on_call: false)
davids.veterinarians.create!(name: "Stephen Stills", review_rating: 5, on_call: false)
pinnacle.veterinarians.create!(name: "Miriam Sidney", review_rating: 3, on_call: true)
pinnacle.veterinarians.create!(name: "Marvo Diagletti", review_rating: 2, on_call: true)
pinnacle.veterinarians.create!(name: "Clyde", review_rating: 1, on_call: true)

# Applications begin here:
app1 = Application.create!(name: "Jamison G", address: "123 Wayward Way", city: "Denver", state: "CO", zip: "80122", status: "Pending", description: "I am a good person and have had several pets before. My mom can vouch for my excellent pet care.")
app2 = Application.create!(name: "Kelsie G", address: "3421 Sleepy Rd", city: "Boulder", state: "CO", zip: "81302", status: "In Progress", description: "I love animals. I enjoy watching shows on Saturday that all involve adopting dogs. I also enjoy watching clips on YouTube about adoption stories. I feel like I would be a terrific pet-owner and give a poor dog a forever home.")
app3 = Application.create!(name: "Simon Seymore", address: "4 Carp Dr", city: "Callahan", state: "CO", zip: "80915", status: "Rejected", description: "i have owned dogs in the past for my farm. i need a dog to hunt.")
app4 = Application.create!(name: "Gregor McKowski", address: "66 Garage Ln", city: "Englewood", state: "CO", zip: "80110", status: "Accepted", description: "I am a part-owner of DevTime Services where I primarily work from home. I have stable income and live in a neighborhood with numerous nearby parks.")

# Adding pets to applications
app1.pets << gogol
app1.pets << sam
app2.pets << barnaby
app2.pets << sam
app3.pets << bagel
app3.pets << prince
app4.pets << barnaby
app4.pets << hodor
