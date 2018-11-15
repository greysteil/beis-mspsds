class CreatePgheroStats < ActiveRecord::Migration[5.2]
  def change
    create_table :pghero_query_stats do |t| # rubocop:disable Rails/CreateTableWithTimestamps
      t.text :database
      t.text :user
      t.text :query
      t.integer :query_hash, limit: 8
      t.float :total_time
      t.integer :calls, limit: 8
      t.timestamp :captured_at
    end

    create_table :pghero_space_stats do |t| # rubocop:disable Rails/CreateTableWithTimestamps
      t.text :database
      t.text :schema
      t.text :relation
      t.integer :size, limit: 8
      t.timestamp :captured_at
    end

    add_index :pghero_space_stats, %i[database captured_at]
    add_index :pghero_query_stats, %i[database captured_at]
  end
end