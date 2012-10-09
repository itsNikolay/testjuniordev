class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.string :slug
      t.text :description
      t.text :text
      t.boolean :published, :default => false

      t.timestamps
    end
    add_index :posts, :slug, :unique => true
  end
end
