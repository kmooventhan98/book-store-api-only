require 'rails_helper'
describe "books API" do
    describe 'GET /books' do
        before do
            FactoryBot.create(:book, title: "oops with Java", author: "balagurusamy")
            FactoryBot.create(:book, title: "ruby programming", author: "matzz ritwik")
        end
        it 'returns all book' do
            get '/api/v1/books'
            expect(response).to have_http_status(:success)
            expect(JSON.parse(response.body).size).to eq(2)
        end
    end
    describe 'POST /books' do
        it 'create a book' do
            expect {
                post '/api/v1/books', params:{ book: {title: "ruby programming", author: "ritz"}}
            }.to change {Book.count}.from(0).to(1)
            expect(response).to have_http_status(:created)
        end
    end

    describe 'DELETE /books/:id' do
        let!(:book) {FactoryBot.create(:book, title: "oops with Java", author: "balagurusamy") }
        it 'deletes a book' do
            expect {
                delete "/api/v1/books/#{book.id}"
            }.to change {Book.count}.from(1).to(0)
            expect(response).to have_http_status(:ok)
        end
    end

end
