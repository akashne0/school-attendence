module ApplicationHelper
  def boolean_label(value)
    case value
     when true
        content_tag(:span, "True", class:"badge badge-success")
     when false 
       content_tag(:span,"False", class:"badge badge-danger")
    end
  end
end
