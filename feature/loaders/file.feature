Feature: It can load configuration from a configured directory
  In order for my application to run correctly,
  As a Developer,
  I need to be able to configure my application from files on disk

  Scenario: Load configuration from a single directory
    Given I have configured Weave with a handler
    And I have configured Weave's file loader to load from a single directory, "/tmp/secrets"
    And the directory exists
    And the following files exist there
    | file_name         | contents                  |
    | cookie_secret     | I am super Secur3         |
    | database_password | my-super-secret-password  |
    When I run Weave's File loader
    Then my application should be configured

  Scenario: Can load configuration even when directories exist in secrets directory
    Given I have configured Weave with a handler
    And I have configured Weave's file loader to load from a single directory, "/tmp/secrets"
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

  Scenario: Load configuration from multiple file directories
    Given I have configured Weave with a handler
    And I have configured weave to load configuration from
    | directory      |
    | /tmp/secrets-a |
    | /tmp/secrets-b |
    And the directories exist
    And the following files exist in the directories
    | directory      | file_name         | contents                  |
    | /tmp/secrets-a | cookie_secret     | I am super Secur3         |
    | /tmp/secrets-b | database_password | my-super-secret-password  |
    When I run Weave's File loader
    Then my application should be configured