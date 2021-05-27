class AddDefaultValtoJoin < ActiveRecord::Migration[5.2]
  def change
    change_column :application_pets, :status, :string, :default => "Pending"
  end
end
