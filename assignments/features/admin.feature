Feature: Admin
  As an admin, I would want to see recently registered users, ban user and see statistics of the users.

  Scenario: Check recently registered users.

    Admin should be able to view users.

    Given I am an admin
    And there are some users registered
    And I am signed in
    When I visit manage users page
    Then I should see a link for "Recently Registered Users"
    When I click the link for the "Recently Registered Users"
    Then I should see recently registered users

  Scenario: Ban registered user.

    Admin should be able to ban registered user

    Given I am an admin
    And I am signed in
    And there is a user
    When I visit ban users page
    Then I should see the "Ban" link beside the user id
    When I click the link for the "Ban" for the user
    Then the user should be banned

  Scenario: View user registration statistics

    Admin should be able to see the stats on user registrations

    Given I am an admin
    And I am signed in
    And there are many users registered
    When I visit view user statistics page
    Then I should be able to see user registration statistics