class Validations::ValidateUrl < Grape::Validations::Validator
  def validate_param!(attr_name, params)
    unless params[attr_name] =~ URI::regexp(%w(http https))
      raise Grape::Exceptions::Validation, params: [@scope.full_name(attr_name)], message: "must be a url"
    end
  end
end
