module ApplicationHelper
  def tags(game)
    html = ""
    game.tag_list.map do |tag|
      html << content_tag(:span, class: "label label-default", style: "display: inline-block;") {
        link_to tag, tag_path(tag), style: "color: white;"
      }
      html << "&nbsp;"
    end
    html
  end

  def alert_class_for(flash_type)
    {
      :success => 'alert-success',
      :error => 'alert-danger',
      :alert => 'alert-warning',
      :notice => 'alert-info'
    }[flash_type.to_sym] || flash_type.to_s
  end

  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = "Grajnamaxa.pl - Gry Online, Darmowe Gry, Super Gry!"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  def meta_keywords(tags = '')
    base_tag = "gry online, darmowe gry, darmowe gry online, gry logiczne, gry akcji, gry przygodowe, gry dla dzieci, gry sportowe"
    if tags.empty?
      base_tag
    else
      "#{tags}"
    end
  end

  def meta_description(description = '')
    base_description = "Codziennie nowe gry! Gry akcji, gry przygodowe, gry logiczne, gry dla dziewczyn, gry sportowe, gry multiplayery, quizy i wiele innych."
    if description.empty?
      base_description
    else
      "#{description}"
    end
  end
end
