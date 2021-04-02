class Ticket < ApplicationRecord
   belongs_to :post
   validates :ticket_id, {presence: true, uniqueness: true}
end
