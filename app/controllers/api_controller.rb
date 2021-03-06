
  class APIController < Grape::API

    prefix 'api'
    format :json

    mount UserAPI
    mount ArticleAPI
    mount RedirectAPI


  end
