class BooksController < ApplicationController
before_action :authenticate_user!
before_action :correct_user, only: [:edit, :update]
  def show
    	@show_book = Book.find(params[:id])
      @book = Book.new
      @user = @show_book.user
  end

  def index
      @books = Book.all
      @book = Book.new
      @user = current_user
  end

  def create
  	@book = Book.new(book_params)
    @book.user_id= current_user.id#Bookモデルのテーブルを使用しているのでbookコントローラで保存する。
  	if @book.save #入力されたデータをdbに保存する。
  		redirect_to book_path(@book), notice: "successfully created book!"#保存された場合の移動先を指定。
  	else
  		@books = Book.all
      @user = current_user
  		render 'index'
  	end
  end

  def edit
  	@book = Book.find(params[:id])
  end



  def update
  	@book = Book.find(params[:id])
  	if @book.update(book_params)
  		redirect_to @book, notice: "successfully updated book!"
  	else #if文でエラー発生時と正常時のリンク先を枝分かれにしている。
  		render "edit"
  	end
  end

  def destroy
  	@book = Book.find(params[:id])
  	@book.destroy
  	redirect_to books_path, notice: "successfully destroy book!"
  end

  private

  def book_params
  	params.require(:book).permit(:title, :body, :user_id)
  end

  def correct_user
    @book = Book.find(params[:id])
    if current_user.id != @book.user_id
       redirect_to books_path
    end
  end

end
