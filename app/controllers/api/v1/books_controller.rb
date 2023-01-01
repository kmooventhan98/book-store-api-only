module Api
  module V1
    class BooksController < ApplicationController
      rescue_from ActiveRecord::RecordNotFound, with: :not_destroyed
      def index
        render json: Book.all, status: :ok
      end
      def create
        book = Book.new(book_params)
        if book.save
          render json: book, status: :created
        else
          render json: book.errors, status: :unprocessable_entity
        end
      end
      
      def destroy
        Book.find(params[:id]).destroy!
        head :ok
      end

      private
      def book_params
        params.require(:book).permit(:title, :author)
      end
      def not_destroyed(e)
        render json: {error: e.message}, status: :no_content
      end
    end
  end
end