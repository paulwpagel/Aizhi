class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.string :title
      t.string :authors
      t.string :description
      #paperclip
      t.string :article_file_name# Original filename
      t.string :article_content_type # Mime type
      t.integer :article_file_size # File size in bytes
      t.timestamps
    end
  end

  def self.down
    drop_table :articles
  end
end
