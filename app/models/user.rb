class User < ActiveRecord::Base
  validates_presence_of :name, :gender
  validates :gender, inclusion: { in: %w(male female)}

  has_one :family_graph, dependent: :destroy, foreign_key: 'family_member_id'

  before_validation  :init_user_data
  after_create  :add_family_graph


private
  def init_user_data
    self.gender = self.gender.downcase if gender_changed?
  end

  def add_family_graph
    return if family_graph.present?
    create_family_graph(name: 'owner').tap do |tree|
      tree.children.create(name: 'self', family_member: self)
    end
  end
end
