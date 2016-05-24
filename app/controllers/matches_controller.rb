class MatchesController < ApplicationController

  before_action :set_tournament
  before_action :set_match

  def update
    @match.update(match_params)

    respond_to do |format|
      format.js { redirect_to tournament_path(@match.tournament), notice: 'Match was successfully updated.' }
    end
  end

  def simulate
    @match.simulate
    respond_to do |format|
      format.js { redirect_to tournament_path(@match.tournament), notice: 'Match simulated.' }
    end
  end

  private
  def set_tournament
    @tournament = Tournament.find(params[:tournament_id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_match
    @match = Match.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def match_params
    params.require(:match).permit(:home_team_score, :away_team_score, :home_team_id, :away_team_id, :tournament_id)
  end
end
