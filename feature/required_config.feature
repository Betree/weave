Feature: It can be configured with required configuration
  In order to detect errors with my applications configuration early
  As a Developer
  I need to be able to mark configuration parameters as required

  Scenario: Load configuration with all required fields
    Given I have created my own Weave module
    And I have configured Weave to use the Environment loader

    And I have configured Weave's Environment loader to load environment variables with prefix "WEAVE_"
    And the following environment variables exist
    | key               | value                     |
    | database_host     | my-database-host.com      |

    When I run my Weave module's configure/0
    Then my application shouldn't raise an error

  Scenario: Load configuration with missing required fields
    Given I have created my own Weave module
    And I have configured Weave to use the File loader

    And I have configured Weave's file loader to load from a single directory, "/tmp/secrets"
    And the directory exists
    And the following files exist there
    | file_name         | contents                  |
    | cookie_secret     | I am super Secur3         |

    Then my application should exit with an error when configuring
