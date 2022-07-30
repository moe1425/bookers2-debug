class Tag < ApplicationRecord
  has_many :book_tags, dependent: :destroy, foreign_key: 'tag_id'
  has_many :books, through: :book_tags

    scope :merge_books, -> (tags){ }

  def self.looks(search, word)

    if search == "perfect_match"
      tags = Tag.where(name: word)
    elsif search == "forward_match"
      tags = Tag.where('name LIKE ?', "#{word}%")
    elsif search == "backward_match"
      tags = Tag.where('name LIKE ?', "%#{word}")
    else
      tags = Tag.where('name LIKE ?', "%#{word}%")
    end

    return tags.inject(init = []) {|result, tag| result + tag.books}

  end

end