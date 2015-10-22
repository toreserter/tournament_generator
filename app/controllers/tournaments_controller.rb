class TournamentsController < ApplicationController
  before_action :set_tournament, only: [:show, :edit, :update, :destroy, :setup, :submit_setup, :simulate]
  before_action :redirect_to_setup, only: [:show, :edit]
  before_action :redirect_to_tournament, only: [:edit, :setup]

  def index
    @tournaments = Tournament.all
    @page_title = "Tournaments"
  end

  def show
    get_matches
    get_scores
  end

  def simulate
    @tournament.simulate_all
    respond_to do |format|
      format.js { redirect_to tournament_path(@tournament), notice: 'Tournament simulated.' }
    end
  end

  def setup
    redirect_to tournament_path(@tournament) unless @tournament.in_setup?
    @players = @tournament.players
  end

  def new
    @tournament = Tournament.new
    # if params[:number_of_players]
    #   params[:number_of_players].to_i.times do
    #     @tournament.players.build
    #   end
    # end
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
        @tournament.set_fixture
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

  protected

  def get_scores
    @players = @tournament.players.order_players
  end

  def get_matches
    @matches = @tournament.matches
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_tournament
    @tournament = Tournament.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def tournament_params
    params.require(:tournament).permit(:name, :tournament_type, :number_of_players, players_attributes: [:name, :team, :id])
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
