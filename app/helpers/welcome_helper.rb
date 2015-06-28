module WelcomeHelper
  def games_list(games)
    html = ""
    html << content_tag(:ul, class: "media-list") {
    games.each do |game|
      concat(content_tag(:li, class: "media") do
        concat(link_to image_tag(game.screen.url(:thumb)), game_url(game), class: "media-left")
        concat(content_tag(:div, class: "media-body") do
          concat(content_tag(:h4, class: "media-heading") do
            game.title
          end)
          concat(rating_for game, "rating", disable_after_rate: true)
          concat(content_tag(:p) do
            raw tags(game)
          end)
        end)
      end)  
    end
    }
    html
  end

  def users_list(users)
    html = ""
    html << content_tag(:ul, class: "media-list") {
    users.each do |user|
      concat(content_tag(:li, class: "media") do
        concat(link_to image_tag(user.avatar.url(:thumb), class: "round-image-50"), nil, class: "media-left")
        concat(content_tag(:div, class: "media-body") do
          concat(content_tag(:h4, class: "media-heading") do
            user.username
          end)
          concat(content_tag(:p) do
            time_ago_in_words(user.created_at) + " temu"
          end)
        end)
      end)  
    end
    }
    html
  end

  def comments_list(comments)
    html = ""
    comments.each do |comment|
      concat(content_tag(:blockquote) do
        concat(content_tag(:h4) do
          link_to comment.game.title, game_url(comment.game)
        end)
        concat(content_tag(:em) do
          '"' + comment.body + '"'
        end)
        concat(content_tag(:footer) do
          comment.author + " " + time_ago_in_words(comment.created_at) + " temu"
        end)
      end)
    end
    html
  end
end
