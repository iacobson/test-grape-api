require 'rails_helper'

describe RedirectAPI do


  describe "GET shortlinks index" do

    before :each do
      post "/api/shortlinks", {shortcode: "short1", url:"http://www.short1.ro"}
      post "/api/shortlinks", {shortcode: "short2", url:"http://www.short2.ro"}
    end

    it "returns an array of statuses" do
      get "/api/shortlinks"
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)).to eql([{"short1"=>"http://www.short1.ro"}, {"short2"=>"http://www.short2.ro"}])
    end
  end

  describe "POST Create Shortcode" do

    it "returns error if url is not http format" do
      post "/api/shortlinks", {shortcode: "short1", url:"www.short1.ro"}
      expect(response.status).to eq(400)
      expect(JSON.parse(response.body)).to eql({"error"=>"url field must be http format"})
    end

    it "returns error if shortlink already exists" do
      post "/api/shortlinks", {shortcode: "short1", url:"http://www.short1.ro"}
      post "/api/shortlinks", {shortcode: "short1", url:"http://www.short2.ro"}
      expect(response.status).to eq(500)
      expect(JSON.parse(response.body)).to eql({"error"=>"shortcode already exists"})
    end

    it "creates a correct url" do
      post "/api/shortlinks", {shortcode: "short1", url:"http://www.short1.ro"}
      expect(response.status).to eq(201)
      $redis.with do |redis|
        expect(redis.get("shortcodes:short1")).to eq("http://www.short1.ro")
      end
    end
  end

  describe "GET Redirect to url" do
    before :each do
      post "/api/shortlinks", {shortcode: "short1", url:"http://www.short1.ro"}
    end

    it "resirects to root if shortlink is wrong" do
      get "/api/shortlinks/wrong"
      expect(response).to redirect_to("/")
    end

    it "redirects to longurl if shortlink is correct" do
      get "/api/shortlinks/short1"
      expect(response).to redirect_to("http://www.short1.ro")
    end
  end

  describe "DELETE shortcode" do
    before :each do
      post "/api/shortlinks", {shortcode: "short1", url:"http://www.short1.ro"}
    end

    it "returns error if shortcode not correct" do
      delete "/api/shortlinks/wrong"
      expect(response.status).to eq(500)
      expect(JSON.parse(response.body)).to eql({"error"=>"shortcode does not exist"})
    end

    it "deletes the shortcode if correct" do
      delete "/api/shortlinks/short1"
      expect(response.status).to eq(200)
      $redis.with do |redis|
        expect(redis.get("shortcodes:short1")).to be nil
      end
    end
  end

end
