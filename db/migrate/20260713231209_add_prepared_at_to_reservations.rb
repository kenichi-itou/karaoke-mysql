class AddPreparedAtToReservations < ActiveRecord::Migration[7.1]
  def change
    add_column :reservations, :prepared_at, :datetime
  end
end
