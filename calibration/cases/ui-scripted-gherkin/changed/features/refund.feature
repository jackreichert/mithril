Feature: Refund approved payments

  Scenario: Support refunds a paid order
    Given a paid order for customer "Ada"
    When support refunds the order
    Then the customer should receive a refund receipt
    And the order should be marked refunded

  Scenario: Refund from the order detail page
    Given I open Chrome at "/admin/orders"
    And I type "Ada" into the search input with id "#q"
    And I click the third row in the results table
    When I click the blue "Refund" button
    And I wait 500 milliseconds
    And I click the modal button with data-testid "confirm-refund"
    Then I should see a green toast in the top right corner
    And the css selector ".status-pill.refunded" should be visible