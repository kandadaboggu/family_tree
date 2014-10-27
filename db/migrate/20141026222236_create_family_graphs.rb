class CreateFamilyGraphs < ActiveRecord::Migration
  def change
    create_table :family_graphs do |t|
      t.string :name
      t.references :family_member, index: true
      t.string :ancestry

      t.timestamps
    end
  end
end
