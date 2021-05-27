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

  def is_rejected_on(app_id)
    record = self.application_pets.where(application_id: app_id)
    if record.first.status == "Rejected"
      true
    else
      false
    end
  end

  # Technically could have pulled app_id from join table,
  # but wanted to practice selective joins
  # NOTE: Due to joining with Join table, duplicate output is present and #uniq was added to output
  def pending_applications
    pending_apps = applications.select('applications.id, applications.name, applications.city').joins(:application_pets).where("application_pets.status = 'Pending'")
    pending_apps.uniq
  end
end
