class RemoveEmailFromProfiles < ActiveRecord::Migration[6.1]
  def change
    remove_column :profiles, :email, :string
  end
end
