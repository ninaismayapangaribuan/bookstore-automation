Feature: Create User API 

Background:
  * url baseUrl + '/Account/v1/User'

Scenario: As a User, I should successfully register a new account with valid request.
  Given request userPayload
  And header Content-Type = 'application/json'
  When method POST
  Then status 201
  And match response.userID != null
  And match response.username != null
  * print 'Request:', userPayload
  * print 'Response:', response

Scenario Outline: As a User, I should not successfully register a new account with <name>.
  Given request <payload>
  And header Content-Type = 'application/json'
  When method POST
  Then status <expectedStatus>
  And match response contains <expectedResponse>
  * print 'Request:', <payload>
  * print 'Response:', response


Examples:
  | name           | payload                                           | expectedStatus | expectedResponse |
  | empty password | { userName: 'UserTestRabu01', password: '' }        | 400            | { "code": "1200", "message": "UserName and Password required." } |
  | empty username | { userName: '', password: 'Karate@1234' }          | 400            | { "code": "1200", "message": "UserName and Password required." } |
  | null password  | { userName: 'UserTestRabu01', password: null }      | 400            | { "code": "1200", "message": "UserName and Password required." } |
  | null username  | { userName: null, password: 'Karate@1234' }        | 400            | { "code": "1200", "message": "UserName and Password required." } |
  | existing username  | { userName: 'userrandomtest1', password: 'Karate@1234' }        | 406            | { "code": "1204", "message": "User exists!" } |
  | invalid password format  | { userName: 'userrandomtest5', password: 'inipassword' }        | 400            | { "code": "1300", "message": "Passwords must have at least one non alphanumeric character, one digit ('0'-'9'), one uppercase ('A'-'Z'), one lowercase ('a'-'z'), one special character and Password must be eight characters or longer." } |