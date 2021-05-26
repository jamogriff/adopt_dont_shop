class Pet < ApplicationRecord
  validates :name, presence: true
  validates :age, presence: true, numericality: true
  belongs_to :shelter
  has_many :application_pets, dependent: :destroy
  has_many :applications, through: :application_pets

  def shelter_name
    shelter.name
  end

  def self.adoptable
    where(adoptable: true)
  end

  def is_approved_on(app_id)
    record = self.application_pets.where(application_id: app_id)
    if record.first.status == "Approved"
      true
    else
      false
    end
  end
end
