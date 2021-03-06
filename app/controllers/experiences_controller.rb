class ExperiencesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]
  def index
    skip_policy_scope
    @experiences = Experience.all
    if params[:query].present?
      @experiences = Experience.search_by_title_description_address_and_category(params[:query]).where.not(latitude: nil, longitude: nil)
    else
      @experiences = Experience.where.not(latitude: nil, longitude: nil)
    end
    @markers = @experiences.map do |experience|
      {
        lng: experience.longitude,
        lat: experience.latitude
      }
    end
  end

  def show
    @experience = Experience.find(params[:id])
    @marker = {
      lng: @experience.longitude,
      lat: @experience.latitude,
      image_url: helpers.asset_url('logo-blue.png')
    }
    @booking = Booking.new
    authorize @experience
  end

  def new
    @experience = Experience.new
    authorize @experience
  end

  def edit
    @experience = Experience.find(params[:id])
    authorize @experience
  end

  def manage
    @experiences = policy_scope(Experience).order(created_at: :desc)
    @markers = @experiences.map do |experience|
      {
        lng: experience.longitude,
        lat: experience.latitude
      }
    end
  end

  def create
    @experience = Experience.new(experiences_params)
    authorize @experience
    @experience.user = current_user
    if @experience.save
      redirect_to experience_path(@experience)
    else
      render :new
    end
  end

  def update
    @experience.update(experiences_params)
    authorize @experience
    redirect_to experience_path(@experience)
  end

  def destroy
    @experience = Experience.find(params[:id])
    @experience.destroy
    authorize @experience
    if @experience.destroy
      redirect_to manage_path
    else
      redirect_to manage_path
    end
  end

  private

  def experiences_params
    params.require(:experience).permit(:title, :description, :address, :price, :capacity_min, :validity_date, :category, :user_id, :photo, :duration)
  end
end
