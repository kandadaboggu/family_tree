class FamilyGraph < ActiveRecord::Base
  has_ancestry
  belongs_to :family_member, :class_name => 'User'
  after_save :update_dependencies


  def owner_node
    root.descendants.find_by(name: 'self')
  end

  def owner
    root.family_member
  end

private

  def update_dependencies
    idx = tree_owner.gender == "male" ? 1 : 2
    r = this.name
    RELATIONSHIP_PAIRS.each do |(ar1, *frs1), (ar2, *frs2)|
      next unless (frs1.include?(r) || frs2.include?(r))
      ar, fr = if frs1.include?(r)
        [ar2, frs2[idx]]
     else
        [ar1, frs1[idx]]
      end
      inverse_node = family_member.family_tree.owner_node
      inverse_node.send(ar).create(name: fr, family_member: owner)
    end
  end

  RELATIONSHIP_PAIRS = {
    %w(siblings  brother sister) => %w(siblings brother sister  ),
    %w(siblings  husband wife  ) => %w(siblings husband wife    ),
    %w(children  father  mother) => %w(parent   son     daughter),
  }

end
