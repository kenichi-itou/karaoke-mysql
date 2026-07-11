class AddDetailsToReservations < ActiveRecord::Migration[7.1]
  def change
    add_column :reservations, :name, :string
    add_column :reservations, :room_number, :string
    add_column :reservations, :phone, :string
    add_column :reservations, :facility, :string
    add_column :reservations, :adult_count, :integer
    add_column :reservations, :child_count, :integer
  end
end
