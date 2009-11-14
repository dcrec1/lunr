Feature: Manage documents

  Scenario: Create new document
    Given I have no documents
    When I post to '/documents.json' with 'document[field1]=diego&document[field2]=carrion'
    Then a new document with 'field1' equal to 'diego' should be created
    And the 'field2' of the document should equal to 'carrion'

  Scenario: Find a document
    Given a document exists with 'id' equal to '10'
    When I go to /documents/10.json
    Then I should get a JSON object with 'id' equal to '10'

  Scenario: Search documents
    Given I have this advertises:
    | id |       title      |
    | 2  | Ruby programming |
    | 4  | The Ruby way     |
    | 8  | Ruby refactoring |
    | 16 | The Rails way    |
    When I go to /documents/search/ruby.json
    Then I should get a JSON object for this advertises:
    | id |       title      |
    | 2  | Ruby programming |
    | 4  | The Ruby way     |
    | 8  | Ruby refactoring |
