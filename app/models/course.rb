class Course < ApplicationRecord
  belongs_to :user
  belongs_to :category, counter_cache: true
  has_many :lessons, dependent: :destroy
  has_many :subscriptions, dependent: :restrict_with_error

  validates :name, :category, :short_description, :description, :language, :duration, :price, :user, presence: true

  def to_s
    name
  end

  scope :published, -> { where(published: true) }
  scope :approved, -> { where(approved: true) }
  scope :unpublished, -> { where(published: false) }
  scope :unapproved, -> { where(approved: false) }

  validates :level, inclusion: %w(beginner intermediate advanced)

  extend FriendlyId
  friendly_id :name, use: :slugged

  def update_rating
    if subscriptions.any?
      update_column :average_rating, (subscriptions.average(:rating).round(2).to_f)
    else
      update_column :average_rating, (0)
    end
  end

  def bought(user)
    self.subscriptions.where(user_id: [user.id], course_id: [self.id]).empty?
  end

end
