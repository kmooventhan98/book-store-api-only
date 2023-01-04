module Api
  module V1
    class BooksController < ApplicationController
      include ActionController::HttpAuthentication::Token
      rescue_from ActiveRecord::RecordNotFound, with: :not_destroyed
      MAX_PAGINATION_LIMIT = 100

      before_action :authenticate_user, only: [:create,:destroy]

      def index
        books = Book.limit(limit).offset(params[:offset])
        render json: BooksRepresenter.new(books).as_json, status: :ok
      end
      def create
        # binding.irb
        author = Author.create!(author_params)
        book = Book.new(book_params.merge(author_id: author.id))
        if book.save
          render json: BookRepresenter.new(book).as_json, status: :created
        else
          render json: book.errors, status: :unprocessable_entity
        end
      end
      
      def destroy
        Book.find(params[:id]).destroy!
        head :ok
      end

      private
      def authenticate_user
         #Authorization: Bearer
         
         token, _options = token_and_options(request)
         user_id = AuthenticationTokenService.decode(token)
         User.find(user_id)
         
      rescue ActiveRecord::RecordNotFound, JWT::DecodeError
        render status: :unauthorized
      end
      def limit
        [
          params.fetch(:limit,MAX_PAGINATION_LIMIT).to_i,MAX_PAGINATION_LIMIT
        ].min
      end
      def author_params
        params.require(:author).permit(:first_name,:last_name,:age)
      end
      def book_params
        params.require(:book).permit(:title)
      end
      def not_destroyed(e)
        render json: {error: e.message}, status: :no_content
      end
    end
  end
end