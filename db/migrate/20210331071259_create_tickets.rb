class CreateTickets < ActiveRecord::Migration[6.0]
  def change
    create_table :tickets do |t|
      t.string :post_id
      t.string :ticket_id
      t.integer :phonenumber
      t.integer :used

      t.timestamps
    end
  end
end
