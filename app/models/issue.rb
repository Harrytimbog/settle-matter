class Issue < ApplicationRecord
  belongs_to :user
end


has_many :options, dependent: :destroy
has_many :replies, dependent: :destroy
validates :question, :category, presence: true
validates :question, length: {
  maximum: 140
}
enum category: [ :easy, :medium, :hard ]
has_one_attached :photo

accepts_nested_attributes_for :options, allow_destroy: true

after_create :assign_expiration

scope :expired, -> { where("expired_at < ?", Time.zone.now) }

scope :active, ->  { where("expired_at > ?", Time.zone.now) }

def can_users_vote?
  self.expired_at > Time.zone.now
end

def remaining_time
  self.expired_at - created_at
end

def has_user_voted?(user)
  voted = false
  self.options.each do |option|
    if user.options.where("options_users.option_id = ?", option.id).any?
      voted = true
    end
  end
  voted
end

def user_voted_reply?(user)
  voted = false
  self.replies.each do |reply|
    if user.replies.where("replies_users.reply_id = ?", reply.id).any?
      voted = true
    end
  end
  voted
end

def self.top_3
  @dilemmas = Dilemma.all.active.sort_by { |dilemma| dilemma.replies.count }
  @dilemmas.first(3)
end

def self.sample
  @dilemma = Dilemma.all.sample
end

private

def assign_expiration
  if self.category == "easy"
    self.expired_at = self.created_at + 1.day
  elsif self.category == "medium"
    self.expired_at = self.created_at + 3.day
  elsif self.category == "hard"
    self.expired_at = self.created_at + 1.week
  end
  self.save
end
