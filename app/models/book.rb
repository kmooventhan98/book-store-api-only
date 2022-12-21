class Book < ApplicationRecord
    validates: author, presence: true, length: {mininum:3}
    validates: title, presence: :true,length: {minimum:3, maximum:30}
end
