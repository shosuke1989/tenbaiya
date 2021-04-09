class Preticket < ApplicationRecord
    validates :phonenumber, {presence: true,numericality: true,length: {is: 11}}

end
