require 'spec_helper'

describe "StaticPages" do

  describe "Home page" do

    it "should have the h1 'microblog'" do
      visit '/static_pages/home'
      page.should have_selector('h1', :text => 'microblog')
    end

    it "should have the right title 'home'" do
      visit '/static_pages/home'
      page.should have_selector('title',
                                :text=> "home")
    end
  end
  
  describe "Help page" do
    
    it "should have the h1 'Help'" do
      visit '/static_pages/help'
      page.should have_selector('h1', :text => 'Help')
    end

    it "should have the right title 'help'" do
      visit '/static_pages/help'
      page.should have_selector('title', :text => 'help')
    end

  end

  describe "About page" do

    it "should have the h1 'About Us'" do
      visit '/static_pages/about'
      page.should have_selector('h1', :text => 'About Us')
    end

    it "should have the right title 'about us'" do
      visit '/static_pages/about'
      page.should have_selector('title', :text => "about us")
    end

  end
end
