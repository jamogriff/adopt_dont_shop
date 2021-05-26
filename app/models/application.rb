class Application < ApplicationRecord
  validates :name, presence: true
  validates :address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip, presence: true
  has_many :application_pets, dependent: :destroy
  has_many :pets, through: :application_pets

  def is_ready
    self.pets.count >= 1
  end

  def submitted
    self.status == "Pending"
  end

  def approval_check
    self.application_pets.all? { |p| p.status == "Approved" }
  end

  def approval_process
    if self.approval_check
      self.update(status: "Approved")
    else
      nil # is this necessary?
    end
  end

end
