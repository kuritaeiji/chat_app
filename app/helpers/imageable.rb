module Imageable
  def attach_image(image)
    if image.present?
      binding.pry
      prefix = image.to_s[/(image|application)(\/.*)(?=\;)/]
      type = prefix.sub(/(image|application)(\/)/, '')
      data = Base64.decode64(image.to_s.sub(/data:#{prefix};base64,/, ''))
      filename = "#{Time.zone.now.strftime('%Y%m%d%H%M%S%L')}.#{type}"
      File.open("#{Rails.root}/tmp/#{filename}", 'wb') do |f|
        f.write(data)
      end
      avatar.attach(io: File.open("#{Rails.root}/tmp/#{filename}"), filename: filename)
      FileUtils.rm("#{Rails.root}/tmp/#{filename}")
    end
  end
end