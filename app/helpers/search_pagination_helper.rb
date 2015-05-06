
module SearchPaginationHelper
  class LinkRenderer < WillPaginate::ViewHelpers::LinkRenderer
    protected



    def page_number(page)
      unless page == current_page
        tag :li,
          link(page, page, :rel=> rel_value(page))
      else
        tag :li ,
          link(page.to_s + "<span class=\"sr-only\">(current)</span>".html_safe ,
         '#' ,:rel => rel_value(page)),
        :class=> "active"
      end
    end

    def html_container(html)
        tag(:ul, html, :class=>"pagination")
    end

    def previous_or_next_page(page, text, classname)
      if page
        tag(:li,
          link(text, page, :class=>classname)
        )
      else
        tag(:li,
          link(text, '#', :class=>classname),
          :class=>"disabled")
      end
    end


  end
end
