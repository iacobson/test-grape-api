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
      requires :url#, validate_url: true
    end
    post do
      $redis.with do |redis|
        redis.setnx "shortcodes:#{params[:shortcode]}", params[:url]
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
        requires :shortcode, type: String
      end
      delete do
        $redis.with do |redis|
          redis.del "shortcodes:#{params[:shortcode]}"
        end
      end

    end





  end

end
