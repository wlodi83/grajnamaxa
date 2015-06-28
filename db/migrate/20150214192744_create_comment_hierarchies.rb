class CreateCommentHierarchies < ActiveRecord::Migration
  def change
    create_table :comment_hierarchies, id: false do |t|
      t.integer :ancestor_id, null: false #ID of the parent/grandparent
      t.integer :descendant_id, null: false #ID of the target comment
      t.integer :generations, null: false #Number of generations between
    end

    #For "all progeny of..." and leaf selects:
    add_index :comment_hierarchies, [:ancestor_id, :descendant_id, :generations],
              unique: true, name: "comment_anc_desc_udx"

    #For "all ancestors of..." selects
    add_index :comment_hierarchies, [:descendant_id],
              name: "comment_desc_idx"
  end
end
