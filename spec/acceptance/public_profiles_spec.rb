require 'acceptance/acceptance_helper'

feature 'Public proile pages' do
  background do
    user = Fabricate(:member, :name => 'Bouse')
    login_as(user)
  end

  scenario 'current user can easily view their public profile page' do
    click_link('My Public Profile')
    page.should have_css("h1.public_profile", :text => "Bouse")
  end
end