Feature: It can load configuration from environment variables
  In order for my application to run correctly,
  As a Developer,
  I need to be able to configure my application from environment variables

  Scenario: Load configuration
    Given I have created my own Weave module
    And I have configured Weave's Environment loader to load environment variables with prefix "WEAVE_"
    And the following environment variables exist
    | key               | value                     |
    | database_host     | my-database-host.com      |
    | database_port     | 6666                      |
    When I run Weave's Environment loader
    Then my application should be configured

  Scenario: No environment prefix configured nor variables filter
    Given I have created my own Weave module
    And I have not configured the environment prefix
    And I have not configured the variables filter with keyword "only"
    When I run Weave's Environment loader
    Then it shouldn't fail and return an empty list

  Scenario: No environment prefix configured but a variables filter list is provided
    Given I have created my own Weave module
    And I have configured the following variables in variables filter
    | key |
    | database_host |
    | database_port |
    And the following environment variables exist
    | key               | value               |
    | DATABASE_HOST     | another-db-host.io  |
    | database_port     | 4242                |
    | full_universe     | 42                  |
    And I have not configured the environment prefix
    When I run Weave's Environment loader
    Then my application should be configured
