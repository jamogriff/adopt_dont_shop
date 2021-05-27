class Shelter < ApplicationRecord
  validates :name, presence: true
  validates :rank, presence: true, numericality: true
  validates :city, presence: true

  has_many :pets, dependent: :destroy

  def self.order_by_reverse_name
    find_by_sql("SELECT * FROM shelters ORDER BY name DESC;")
  end

  def self.order_by_recently_created
    order(created_at: :desc)
  end

  def self.order_by_number_of_pets
    select("shelters.*, count(pets.id) AS pets_count")
      .joins("LEFT OUTER JOIN pets ON pets.shelter_id = shelters.id")
      .group("shelters.id")
      .order("pets_count DESC")
  end

  def pet_count
    pets.count
  end

  def adoptable_pets
    pets.where(adoptable: true)
  end

  def alphabetical_pets
    adoptable_pets.order(name: :asc)
  end

  def shelter_pets_filtered_by_age(age_filter)
    adoptable_pets.where('age >= ?', age_filter)
  end

  # This method took about an hour to figure out
  def self.has_pending_applications
    joins(pets: [:applications]).where("applications.status = 'Pending'")
  end

  def adoptable_avg_age
    adoptable_pets.average(:age)
  end

  def adoptable_count
    adoptable_pets.count
  end

  def number_adopted
    pets.count - adoptable_pets.count
  end

  def pets_not_reviewed
    pets.joins(:application_pets).where("application_pets.status = 'Pending'")
  end

end
