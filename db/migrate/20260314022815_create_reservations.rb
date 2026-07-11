class CreateReservations < ActiveRecord::Migration[7.1]
  def change
    create_table :reservations do |t|
      t.date :date
      t.time :start_time
      t.time :end_time

      t.timestamps
    end
  end
end
