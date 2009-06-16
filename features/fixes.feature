Feature: Making fun of TextMate 2's long development cycle
  In order to poke fun at this vapourware
  As an impatient dickhead
  I want to make up phony things that TextMate 2 will fix

  Background:
    Given there is a couple of pre-determined fixes
    When I go to the homepage
    
  Scenario: Viewing Fixes
    Then I should see a predetermined fix
    
  Scenario: Viewing a Fix
    When I follow "permalink"
    Then I should see a predetermined fix
    
  Scenario: Posting a fix
    When I fill in "text" with "Something Else"
    And I press "Suggest it!"
    Then I should see "Something Else"
  