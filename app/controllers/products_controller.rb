class ProductsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index search show]
  before_action :set_product, only: %i[edit update show_owner destroy]

  def index
    @products = Product.where.not(category: "accessories")
  end

  def search
    if params[:product][:category].present?
      @products = Product.where(category: params[:product][:category])
    else
      @products = Product.where.not(category: "accessories")
    end
  end

  def index_owner
    @products = Product.where(user: current_user)
  end

  def show_owner
  end

  def show
    @product = Product.find(params[:id])
    @booking = Booking.new
    @product_assignment = ProductAssignment.new
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    @product.user = current_user

    if @product.save
      redirect_to owner_product_path(@product)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      redirect_to owner_product_path(@product)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    redirect_to owner_products_path, status: :see_other
  end

  private

  def product_params
    params.require(:product).permit(:category, :name, :description, :price, :image_url, :product_type)
  end

  def set_product
    @product = Product.find(params[:id])
  end
end
