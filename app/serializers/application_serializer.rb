class ApplicationSerializer < ActiveModel::Serializer
  def self.attributes(*args)
    args << :id unless args.include?(:id)
    args << :type unless args.include?(:type)
    super(*args)
  end

  def type
    object.class.name.underscore.pluralize
  end
end
