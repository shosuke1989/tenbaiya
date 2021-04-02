class Post < ApplicationRecord   
    has_many :tickets
    validates :content, {presence: true,length: {maximum:140},uniqueness: true}
  end
  