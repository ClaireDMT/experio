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
    authorize @order
  end

  def edit
    @booking = Booking.find(params[:booking_id])
    authorize @order
  end

  def create
    @booking = Booking.new(booking_params)
    authorize @order
    @experience = Experience.find(params[:experience_id])
    @booking.experience = @experience
    @booking.user = current_user
    if @booking.save
      redirect_to experience_booking_payement_path(@experience, @booking)
    else
      render "orderss/show"
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
    @booking = Booking.find(params[:id])
    authorize @booking
    @booking.status = "accepted"
    @booking.save
    respond_to do |format|
      format.html { redirect_to bookings_path }
      format.js # <-- will render `app/views/reviews/create.js.erb`
    end
  end

  def decline
    @booking = Booking.find(params[:id])
    authorize @booking
    @booking.status = "declined"
    @booking.save
    respond_to do |format|
      format.html { redirect_to bookings_path }
      format.js # <-- will render `app/views/reviews/create.js.erb`
    end
  end

  private

  def booking_params
    params.require(:booking).permit(:date, :number_of_participants)
  end
end
