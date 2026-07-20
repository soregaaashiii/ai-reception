class CreateTenantFoundation < ActiveRecord::Migration[8.1]
  def change
    create_table :organizations do |t|
      t.string :name, null: false
      t.string :service_name, null: false, default: "AI受付"
      t.string :status, null: false, default: "trial"
      t.string :time_zone, null: false, default: "Asia/Tokyo"
      t.timestamps
    end

    create_table :locations do |t|
      t.references :organization, null: false, foreign_key: true
      t.string :name, null: false
      t.string :phone
      t.string :address
      t.boolean :primary, null: false, default: false
      t.timestamps
    end
    add_index :locations, %i[organization_id name], unique: true

    create_table :users do |t|
      t.references :organization, null: false, foreign_key: true
      t.string :name, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :role, null: false, default: "staff"
      t.boolean :active, null: false, default: true
      t.datetime :last_signed_in_at
      t.timestamps
    end
    add_index :users, "lower(email)", unique: true, name: "index_users_on_lower_email"
    add_index :users, %i[organization_id role]
  end
end
