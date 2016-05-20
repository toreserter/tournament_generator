module TournamentsHelper
  def state_label(tournament)
    case tournament.state
      when 'ready'
        content_tag(:span, "Ready", class: "label label-success") do
          "Ready"
        end
      when 'in_setup'
        content_tag(:span, class: "label label-warning") do
          "In setup"
        end
      else
        content_tag(:span, class: "label label-info") do
          "#{tournament.state}"
        end
    end
  end
end
