module AdminsHelper
 def upload_image(image, base64)
    require 'fileutils'
    data =  base64
    image_data = Base64.decode64(data['data:image/png;base64,'.length .. -1])
    who = 'admins'
    file_name = "pic_#{Time.now.strftime("%Y%m%d%H%M%S")}.png"
    file_path = File.join(Rails.root, 'public', 'images', 'upload_images', who, file_name)
    File.open(file_path, 'wb') do |f|
      f.write image_data
    end
    return "upload_images/#{who}/"+file_name
  end
end
