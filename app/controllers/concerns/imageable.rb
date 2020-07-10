module Imageable
  def attach_image(image)
    if image
      image_match = image.match(/^data:(.*?);(?:.*?),(.*)$/)
      mime_type, encoded_image = image_match.captures
      extension = mime_type.split('/').second
      decoded_image = Base64.decode64(encoded_image)
      filename = "avater#{id}.#{extension}"
      image_path = "#{Rails.root}/tmp/storage/#{filename}"
      File.open(image_path, 'wb') do |f|
        f.write(decoded_image)
      end
      avatar.detach if avatar.attached?
      avatar.attach({ io: File.open(image_path), filename: filename, content_type: mime_type })
      FileUtils.rm(image_path)
    end
  end

  def convert_image_to_url(args)
    variant_image = args[:variant] ? avatar.send(:variant, args[:variant]).processed : avatar
    self.avatar_url = variant_image.service_url

    # encoded_image = Base64.encode64(variant_image.download)
    # blob = ActiveStorage::Blob.find_by(id: avatar[:id])
    # self.encoded_avatar = "data:#{blob[:content_type]};base64,#{encoded_image}"
  end
end