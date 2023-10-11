Given('I am an admin') do
  @admin = FactoryBot.create :admin
end

Given('there are some users registered') do
  @users = FactoryBot.create_list :user, (1+rand(6))
end

Given('I am signed in') do
  visit '/'
  click_link 'Sign in'
  fill_in 'st123456', with: @admin.uid
  fill_in 'Password', with: @admin.password
  click_button 'Log in'
end

When('I visit manage users page') do
  visit examscheduler_manage_users_path
end

Then('I should see a link for {string}') do |string|
  save_and_open_page
  expect(page).to have_link(string)
end

When('I click the link for the {string}') do |string|
  click_link string
end

Then('I should see recently registered users') do
  expect(page).to have_css('table tbody tr')
  save_and_open_page
end

Given('there is a user') do
  @user = FactoryBot.create :user
end

When('I visit ban users page') do
  visit examscheduler_ban_users_path
end

Then('I should see the {string} link beside the user id') do |string|
  expect(page).to have_content(@user.uid)
  @row = page.find('tr', text: @user.uid)
  expect(@row).to have_content(string)
end

When('I click the link for the {string} for the user') do |string|
  @row.click_link string
  save_and_open_page
end


Then('the user should be banned') do
  click_link 'Sign out'
  click_link 'Sign in'
  fill_in 'st123456', with: @user.uid
  fill_in 'Password', with: @user.password
  click_button 'Log in'
  expect(page).to have_content("Your account is locked.")
  save_and_open_page
end

Given('there are many users registered') do
  @users = FactoryBot.create_list :user, (1+rand(500))
end

When('I visit view user statistics page') do
  visit examscheduler_user_stats_path
end

Then('I should be able to see user registration statistics') do
  expect(page).to have_content('User Registration Statistics')
  save_and_open_page
end
