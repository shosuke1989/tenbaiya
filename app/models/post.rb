class Post < ApplicationRecord  
    validates :content, {presence: true,length: {maximum:140},uniqueness: true}
  
    #belongs_to :buy
  
    has_many :tickets
  
  
  end
  