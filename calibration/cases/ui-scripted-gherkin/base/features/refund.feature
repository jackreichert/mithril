Feature: Refund approved payments

  Scenario: Support refunds a paid order
    Given a paid order for customer "Ada"
    When support refunds the order
    Then the customer should receive a refund receipt
    And the order should be marked refunded