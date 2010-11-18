module ApplicationHelper
  def button(title,options={})
    url = "#" unless options[:url]
    icon = id = "";
    icon = "<span class=\"ui-icon "+options[:icon]+"\"></span>" if options[:icon]
    id = " id=\"#{options[:id]}\"" if options[:id]
    "<a class=\"ib-button ui-state-default ui-corner-all\"#{id} href=\"#{url_for(url)}\" alt=\"#{title}\">#{icon}#{title}</a>".html_safe
  end
end
