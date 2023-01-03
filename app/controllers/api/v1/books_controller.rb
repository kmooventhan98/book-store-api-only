module Api
  module V1
    class BooksController < ApplicationController
      rescue_from ActiveRecord::RecordNotFound, with: :not_destroyed
      def index
        books = Book.all
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