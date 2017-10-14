Feature: It can load configuration from Hashicorp's Vault
  In order for my application to run correctly,
  As a Developer,
  I need to be able to configure my application with secrets from Vault

  Scenario: Load configuration from Vault
    Given I have created my own Weave module
    And I have configured Weave's Vault loader to load from a single location, "/secret/vault"
    And the locations exists
    And the following secrets exist there
    | location      | secret            | contents                  |
    | /secret/vault | vault_secret_1    | Vault is awesome          |
    When I run Weave's Vault loader
    Then my application should be configured
