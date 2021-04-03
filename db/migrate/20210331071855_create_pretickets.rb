class CreatePretickets < ActiveRecord::Migration[6.0]
  def change
    create_table :pretickets do |t|
      t.string :ticket_id
      t.string :phonenumber
      

      t.timestamps
    end
  end
end
