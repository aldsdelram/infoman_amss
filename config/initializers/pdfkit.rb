PDFKit.configure do |config|
  config.wkhtmltopdf = Rails.root.join('public', 'wkhtmltopdf','bin').to_path+'\wkhtmltopdf.exe'
  config.default_options = {
    :page_size => 'Letter',
    :margin_top => '1in',
    :margin_bottom => '1in',
    :margin_left => '1in',
    :margin_right => '1in',
    :print_media_type => true
  }
end