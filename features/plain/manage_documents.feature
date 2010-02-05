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
    Given I have this documents:
    | id |       title      |
    | 2  | Ruby programming |
    | 4  | The Ruby way     |
    | 8  | Ruby refactoring |
    | 16 | The Rails way    |
    When I go to /documents/search.json?q=ruby
    Then I should get a JSON object for this documents:
    | id |       title      |
    | 2  | Ruby programming |
    | 4  | The Ruby way     |
    | 8  | Ruby refactoring |
    
  Scenario: List documents
    Given I have this documents:
    | id |       title       |
    | 4  | JRuby programming |
    | 8  | The JRuby way     |
    | 16 | JRuby refactoring |
    | 32 | The JRails way    |
    When I go to the homepage
    Then I should see this documents:
    | 4  |
    | 8  |
    | 16 |
    | 32 |
    
    Scenario: Suggest documents
      Given I have this documents:
      | id |       title      |
      | 2  | Ruby programming |
      | 4  | The Ruby way     |
      | 8  | Ruby refactoring |
      | 16 | The Rails way    |
      When I go to /documents/search.json?q=rubi+programing
      Then I should get a JSON object with 'suggest' equal to 'ruby programming'