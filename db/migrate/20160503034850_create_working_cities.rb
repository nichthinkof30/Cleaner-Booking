class CreateWorkingCities < ActiveRecord::Migration
  def change
    create_table :working_cities do |t|
      t.integer :city_id
      t.integer :cleaner_id

      t.timestamps null: true
    end
    add_index :working_cities, :city_id
    add_index :working_cities, :cleaner_id
  end
end
