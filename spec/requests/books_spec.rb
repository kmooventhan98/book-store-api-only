require 'rails_helper'

describe "books API",  type: :request do
    let!(:first_author) {FactoryBot.create(:author,first_name: "Bala", last_name: "guru", age: 45)}
    let!(:second_author) {FactoryBot.create(:author,first_name: "matzz", last_name: "ritwik", age: 45)}
    describe 'GET /books' do
        before do
            FactoryBot.create(:book, title: "oops with Java", author: first_author)
            FactoryBot.create(:book, title: "ruby programming", author: second_author)
        end

        it 'returns all book' do
            get '/api/v1/books'

            expect(response).to have_http_status(:success)
            expect(response_body.size).to eq(2)
            expect(response_body).to eq(
                [{
                    "id"=> 1,
                    "title"=> "oops with Java",
                    "author_name"=> "Bala guru",
                    "author_age"=> 45
                },
                {
                    "id"=> 2,
                    "title"=> "ruby programming",
                    "author_name"=> "matzz ritwik",
                    "author_age"=> 45
                }]
            )
        end

        it 'return a subset of books based on pagination limit' do
            get '/api/v1/books', params: {limit:1}
            expect(response).to have_http_status(:success)
            expect(response_body.size).to eq(1)
            expect(response_body).to eq(
                [{
                    "id"=> 1,
                    "title"=> "oops with Java",
                    "author_name"=> "Bala guru",
                    "author_age"=> 45
                }]
            )
        end
        it 'return a subset of books based on pagination offset' do
            get '/api/v1/books', params: {limit:1,offset:1}
            expect(response).to have_http_status(:success)
            expect(response_body.size).to eq(1)
            expect(response_body).to eq(
                [{
                    "id"=> 2,
                    "title"=> "ruby programming",
                    "author_name"=> "matzz ritwik",
                    "author_age"=> 45
                }]
            )
        end
    end

    describe 'POST /books' do
        it 'create a book' do
            expect {
                post '/api/v1/books', params:{ 
                    book: {title: "ruby programming"},
                    author: {first_name: 'Andy', last_name: 'Weir', age: '48'}
                }
            }.to change {Book.count}.from(0).to(1)
            
            expect(response).to have_http_status(:created)
            expect(Author.count).to eq(3)
            expect(response_body).to eq(
                {
                    "id"=> 1,
                    "title"=> "ruby programming",
                    "author_name"=> "Andy Weir",
                    "author_age"=> 48
                }
            )
        end
    end

    describe 'DELETE /books/:id' do
        let!(:book) {FactoryBot.create(:book, title: "oops with Java", author: first_author) }
        it 'deletes a book' do
            expect {
                delete "/api/v1/books/#{book.id}"
            }.to change {Book.count}.from(1).to(0)
            expect(response).to have_http_status(:ok)
        end
    end

end
