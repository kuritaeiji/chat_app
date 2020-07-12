class ImageExtensionValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    extensions = ['image/jpg', 'image/jpeg', 'image/png']
    if value.attached? && !extensions.any? { |extension| value.content_type.match(extension) }
      record.errors[attribute] << 'には画像しか使用できません。'
    end
  end
end