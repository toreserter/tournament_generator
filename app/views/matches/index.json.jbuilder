json.array!(@matches) do |match|
  json.extract! match, :id, :home_team_score, :away_team_score, :home_team_id, :away_team_id, :tournament_id_id
  json.url match_url(match, format: :json)
end
