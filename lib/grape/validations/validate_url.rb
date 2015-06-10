module Grape
  module Validations
    class ValidateUrl < Grape::Validations::Base
      def validate_param!(attr_name, params)
        unless params[attr_name] =~ URI::regexp(%w(http https))
          raise Grape::Exceptions::Validation, params: [@scope.full_name(attr_name)], message: "field must be http format"
        end
      end
    end
  end
end
