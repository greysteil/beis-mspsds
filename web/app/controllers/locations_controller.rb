class LocationsController < ApplicationController
  before_action :set_location, only: %i[show edit update remove destroy]
  before_action :create_location, only: %i[create]

  # GET /locations/1
  # GET /locations/1.json
  def show
    @business = @location.business
  end

  # GET /locations/new
  def new
    @business = Business.find(params[:business_id])
    @location = @business.locations.build
  end

  # GET /locations/1/edit
  def edit
    @business = @location.business
  end

  # POST /locations
  # POST /locations.json
  def create
    respond_to do |format|
      if @location.save
        format.html do
          redirect_to business_path(@location.business),
                      notice: "Location was successfully created."
        end
        format.json { render :show, status: :created, location: @location }
      else
        format.html { render :new }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /locations/1
  # PATCH/PUT /locations/1.json
  def update
    authorize @location
    respond_to do |format|
      if @location.update(location_params)
        format.html { redirect_to @location.business, notice: "Location was successfully updated." }
        format.json { render :show, status: :ok, location: @location }
      else
        format.html { render :edit }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  def remove
    @business = @location.business
  end

  # DELETE /locations/1
  # DELETE /locations/1.json
  def destroy
    authorize @location
    @location.destroy
    respond_to do |format|
      format.html do
        redirect_to @location.business, notice: "Location was successfully destroyed."
      end
      format.json { head :no_content }
    end
  end

private

  def create_location
    business = Business.find(params[:business_id])
    @location = business.locations.create(location_params)
    @location.source = UserSource.new(user: current_user)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_location
    @location = Location.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def location_params
    params.require(:location).permit(:business_id, :name, :address, :phone_number, :locality, :country, :postal_code)
  end
end
