class RedirectAPI < Grape::API



  namespace :shortlinks do
    format :json

    #$redis defined in initializers/redis.rb

    desc "Index Shortcodes"
    get do
      #here I want to get all key - values in json format
      $redis.with do |redis|
        redis.keys("shortcodes:*").map { |e| {(e.gsub("shortcodes:", "")) => (redis.get e)} }
      end
    end

    desc "Create Shortcode"
    params do
      requires :shortcode, type: String
      # validate_url is a custom validator
      # defined in lib/grape/validations/validate_url.rb
      # validator initiated in config/initializers/grape_validations.rb
      requires :url, validate_url: true
    end
    post do
      $redis.with do |redis|
        if redis.setnx "shortcodes:#{params[:shortcode]}", params[:url]
          true
        else
          raise Grape::Exceptions::Validation, params: [params[:shortcode]], message: "shortcode already exists"
        end
      end
    end

    namespace ':shortcode' do
      desc "Redirect shortcode to URL"
      get do
        $redis.with do |redis|
          @url = redis.get "shortcodes:#{params[:shortcode]}"
        end
        redirect @url || "/"
      end

      desc "Delete shortcode"

      params do
        #move in helper?
        $redis.with do |redis|
          @params = redis.keys("shortcodes:*").map { |e| e.gsub("shortcodes:", "")}
        end
        requires :shortcode, values: @params
      end
      delete do
        $redis.with do |redis|
          @url = redis.get "shortcodes:#{params[:shortcode]}"
          if @url != nil
            redis.del "shortcodes:#{params[:shortcode]}"
          else
            raise Grape::Exceptions::Validation, params: [params[:shortcode]], message: "shortcode does not exist"
          end
        end
      end

    end

  end
end
