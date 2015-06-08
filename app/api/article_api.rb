class ArticleAPI < Grape::API

  #helper API::Helpers::UserHelper

  namespace :articles do
    format :json


    desc "Index Articles"
    get do
      Article.all
    end

    desc "Create Article"
    params do
      requires :user_id, type: Integer
      requires :content
    end
    post do
      article = Article.new(declared(params))
      article.save
      article

    end

    namespace ':id' do

      desc "Show Article"
      params do
        requires :id
      end
      get do
        article = Article.find(params[:id])
      end

      desc "Update Article"
      params do
        requires :id
        optional :content, type: String
      end
      put do
        article = Article.find(params[:id])
        article.update(declared(params, include_missing: false))
        article
      end

      desc "Delete Article"
      params do
        requires :id
      end
      delete do
        article = Article.find(params[:id])
        article.destroy
      end

    end
  end
end
