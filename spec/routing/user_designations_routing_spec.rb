require "rails_helper"

RSpec.describe UserDesignationsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/user_designations").to route_to("user_designations#index")
    end

    it "routes to #new" do
      expect(get: "/user_designations/new").to route_to("user_designations#new")
    end

    it "routes to #show" do
      expect(get: "/user_designations/1").to route_to("user_designations#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/user_designations/1/edit").to route_to("user_designations#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/user_designations").to route_to("user_designations#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/user_designations/1").to route_to("user_designations#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/user_designations/1").to route_to("user_designations#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/user_designations/1").to route_to("user_designations#destroy", id: "1")
    end
  end
end
