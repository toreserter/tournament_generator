class TournamentsController < ApplicationController
  before_action :set_tournament, only: [:show, :edit, :update, :destroy, :setup, :submit_setup]
  before_action :redirect_to_setup, only: [:show, :edit]
  before_action :redirect_to_tournament, only: [:edit, :setup]

  def index
    @tournaments = Tournament.all
  end

  def show
    @matches = @tournament.matches
  end

  def setup
    redirect_to tournament_path(@tournament) unless @tournament.in_setup?

  end


  def new
    @tournament = Tournament.new
    if params[:number_of_players]
      params[:number_of_players].to_i.times do
        @tournament.players.build
      end
    end
  end

  def edit
  end

  def create
    @tournament = Tournament.new(tournament_params)

    respond_to do |format|
      if @tournament.save
        format.html { redirect_to @tournament, notice: 'Tournament was successfully created.' }
        format.json { render :show, status: :created, location: @tournament }
      else
        format.html { render :new }
        format.json { render json: @tournament.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @tournament.update(tournament_params)
        format.html { redirect_to @tournament, notice: 'Tournament was successfully updated.' }
        format.json { render :show, status: :ok, location: @tournament }
      else
        format.html { render :edit }
        format.json { render json: @tournament.errors, status: :unprocessable_entity }
      end
    end
  end

  def submit_setup
    respond_to do |format|
      if @tournament.update(tournament_params.merge({:state => 'ready'}))
        format.html { redirect_to @tournament, notice: 'Tournament was successfully updated.' }
        format.json { render :show, status: :ok, location: @tournament }
      else
        format.html { render :edit }
        format.json { render json: @tournament.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @tournament.destroy
    respond_to do |format|
      format.html { redirect_to tournaments_url, notice: 'Tournament was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_tournament
    @tournament = Tournament.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def tournament_params
    params.require(:tournament).permit(:name, :tournament_type, :number_of_players, players_attributes: [:name, :team])
  end

  def redirect_to_setup
    if @tournament.in_setup?
      redirect_to setup_tournament_path(@tournament) and return
    end
  end

  def redirect_to_tournament
    if @tournament.ready?
      redirect_to tournament_path(@tournament) and return
    end
  end
end
