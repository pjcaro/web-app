class CreateNews < ActiveRecord::Migration[5.2]
  def change
    create_table :news do |t|
      t.string :authors
      t.string :company
      t.string :contributor
      t.string :raw_title
      t.string :region
      t.string :subtype
      t.string :content

      t.timestamps
    end
  end
end
