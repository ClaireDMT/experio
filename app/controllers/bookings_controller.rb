class BookingsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :delete]
  def index
    @mybookings = policy_scope(Booking).where(user: current_user)
    @bookings_as_owner = current_user.bookings_as_owner
    @review = Review.new
  end

  def new
    # @experience = Experience.find(params[:id])
    @booking = Booking.new
    authorize @booking
  end

  def create
    @booking = Booking.new(booking_params)
    authorize @booking
    @experience = Experience.find(params[:experience_id])
    @booking.experience = @experience
    @booking.user = current_user
    if @booking.save
      redirect_to experience_booking_payement_path(@experience, @booking)
    else
      render "experiences/show"
    end
  end

  def destroy
    @booking = Booking.find(params[:id])
    @booking.destroy
    # Penser a renvoyer vers la home page !! (Alex)
    redirect_to root_path
  end

  def payement
    @booking = Booking.find(params[:booking_id])
    authorize @booking
  end

  def accept
  end

  private

  def booking_params
    params.require(:booking).permit(:date, :number_of_participants)
  end
end
