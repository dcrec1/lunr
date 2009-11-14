Feature: Manage documents

  Scenario: Create new project
    Given I have no documents
    When I post to '/documents' with 'field1=diego&field2=carrion'
    Then a new document should be created
    And the 'field1' of the document should equal to 'diego'
    And the 'field2' of the document should equal to 'carrion'
