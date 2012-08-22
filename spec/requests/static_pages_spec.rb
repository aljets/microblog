require 'spec_helper'

describe "StaticPages" do

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector('h1',   text: heading) }
    it { should have_selector('title',text: full_title(page_title)) }
  end

  describe "Home page" do
    before { visit root_path }
    let(:heading)     { 'microblog' }
    let(:page_title)  { '' }
    
    it_should_behave_like "all static pages"
    it { should_not have_selector('title', text: 'home') }

    describe "for signed-in users" do
      let!(:user) { FactoryGirl.create(:user) }

      before(:all) do
        10.times do
          FactoryGirl.create(:micropost, user: user, content: "Lorem Ips")
        end
      end

      after(:all) { User.delete_all }

      before do
        valid_signin user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          page.should have_selector("li##{item.id}", text: item.content)
        end
      end

      it "should display the micropost count" do
        page.should have_selector('span', text: '10 microposts')
      end

      describe "pagination" do
        
        it { should have_selector('div', class: 'pagination') }

        it "should list each micropost" do
          user.microposts.paginate(page: 1).each do |micropost|
            page.should have_selector('li', text: micropost.content)
          end
        end
      end

      describe "should pluralize appropriately" do
        before { 9.times { click_link "delete" } }
        
        it "should display 'micropost' and not 'microposts'" do
          page.should have_selector('span', text: '1 micropost')
          page.should_not have_selector('span', text: '1 microposts')
        end
      end
    end
  end
  
  describe "Help page" do
    before { visit help_path }

    let(:heading)     { 'Help' }
    let(:page_title)  { 'help' }
    
    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before { visit about_path }

    let(:heading)     { 'About Us' }
    let(:page_title)  { 'about us' }
    
    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before { visit contact_path }

    let(:heading)     { 'Contact' }
    let(:page_title)  { 'contact' }
    
    it_should_behave_like "all static pages"
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    page.should have_selector 'title', text: full_title('about us')
    click_link "Help"
    page.should have_selector 'title', text: full_title('help')
    click_link "Contact"
    page.should have_selector 'title', text: full_title('contact')
    click_link "Home"
    click_link "Sign up now!"
    page.should have_selector 'title', text: full_title('sign up')
  end
end
