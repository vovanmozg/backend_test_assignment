class CreateAiResults < ActiveRecord::Migration[6.1]
  def change
    create_table :ai_results do |t|
      t.references :car, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.float :rank_score
      t.boolean :top
      t.datetime :created_at, null: false, default: -> { 'NOW()' }
    end
  end
end
