class RedirectAPI < Grape::API


  namespace :shortlinks do
    format :json

    redis = Redis.new

    desc "Index Shortcodes"
    get do
      #here I want to get all key - values in json format
      redis.keys
    end

    desc "Create Shortcode"
    params do
      requires :shortcode, type: String
      requires :url #here I want to validate type: URL
    end
    post do
      redis.setnx params[:shortcode], params[:url]
    end

    namespace ':shortcode' do
      desc "Redirect shortcode to URL"
      get do
        url = redis.get params[:shortcode]
        redirect url || "/"
      end

      desc "Delete shortcode"
      params do
        requires :shortcode, type: String
      end
      delete do
        redis.del params[:shortcode]
      end

    end





  end

end
