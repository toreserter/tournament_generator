class MatchesController < ApplicationController

  before_action :set_tournament
  before_action :set_match

  def update
    update_with_track(@match) do
      @match.update(match_params)
    end


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

  def update_with_track(object, &block)
    hts_was = object.home_team_score
    ats_was = object.away_team_score
    block.call
    current_or_guest_user.create_activity action: 'match.update',
                                          parameters: {home_team_score: object.home_team_score,
                                                       away_team_score: object.away_team_score,
                                                       home_team_score_was: hts_was,
                                                       away_team_score_was: ats_was},
                                          recipient: object, owner: current_or_guest_user
  end
end
