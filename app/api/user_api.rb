class UserAPI < Grape::API

  #helper API::Helpers::UserHelper

  namespace :users do
    format :json


    desc "Index Users"
    get do
      User.all
    end

    desc "Create User"
    params do
      requires :name, type: String
    end
    post do
      user = User.new(declared(params))
      user.save
      user

    end

    namespace ':id' do

      desc "Show User"
      params do
        requires :id
      end
      get do
        user = User.find(params[:id])
      end

      desc "Update User"
      params do
        requires :id
        optional :name, type: String
      end
      put do
        user = User.find(params[:id])
        user.update(declared(params))
        user
      end

      desc "Delete User"
      params do
        requires :id
      end
      delete do
        user = User.find(params[:id])
        user.destroy
      end

    end
  end
end
