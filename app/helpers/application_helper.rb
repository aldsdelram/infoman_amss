module ApplicationHelper

  def paginate(collection, options = {})
    options[:renderer] ||= SearchPaginationHelper::LinkRenderer
    options[:next_label] ||= '&raquo;'
    options[:previous_label] ||= '&laquo;'
    options[:inner_window]   ||= 5
    options[:outer_window] ||= 2

    will_paginate(collection, options)
  end
end
