Feature: It can load configuration from a configured directory
  In order for my application to run correctly,
  As a Developer,
  I need to be able to configure my application from files on disk

  Scenario: Load configuration
    Given I have configured Weave with a handler
    And I have configured Weave's File loader to load configuration from "secrets"
    And the directory exists
    And the following files exist there
    | file_name         | contents                  |
    | cookie_secret     | I am super Secur3         |
    | database_password | my-super-secret-password  |
    When I run Weave's File loader
    Then my application should be configured

  Scenario: Can load configuration even when directories exist in secrets directory
    Given I have configured Weave with a handler
    And I have configured Weave's File loader to load configuration from "secrets"
    And the directory exists
    And the following files exist there
      | file_name         | contents                  |
      | cookie_secret     | I am super Secur3         |
      | database_password | my-super-secret-password  |
    And the following directories exist there
      | directory_name    |
      | kubernetes.io     |
    When I run Weave's File loader
    Then my application should be configured
