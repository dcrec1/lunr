Feature: Manage documents

  Scenario: Create new project
    Given I have no documents
    When I post to '/documents.json' with 'document[field1]=diego&document[field2]=carrion'
    Then a new document with 'field1' equal to 'diego' should be created
    And the 'field2' of the document should equal to 'carrion'
