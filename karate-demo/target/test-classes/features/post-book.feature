Feature: Input a New Book in to Database 

Background:
  * url baseUrl
  * def userPath = '/Account/v1/User'
  * def bookPath = '/BookStore/v1/Books'
  * def generateTokenPath = '/Account/v1/GenerateToken'
# ==============================================================
# 1. get available ISBN
# ==============================================================
  Given path bookPath
  When method GET
  Then status 200

  # Get random ISBN number
  * def books = response.books
  * def randomIndex = Math.floor(Math.random() * books.length)
  * def randomIsbn = books[randomIndex].isbn
  * print 'Random ISBN:', randomIsbn

# ==============================================================
# 2. register new User
# ==============================================================
  Given path userPath
  And header Content-Type = 'application/json'
  And request userPayload
  When method POST
  Then status 201
  * print 'Request:', userPayload
  * print 'Response:', response
  * def newUsername = response.username 
  * def newPassword = userPayload.password
  * def userId = response.userID

# ==============================================================
# 3. Generate token
# ==============================================================
  Given path generateTokenPath
  And header Content-Type = 'application/json'
  And request { userName: '#(newUsername)', password: '#(newPassword)'}
  When method post
  Then status 200
  * def token = response.token
  * print 'Generated Token:', token


  #Define Expected Response for Success Scenario
  * def expectedAddBookResponse =
  """
  {
    "books": [
      { "isbn": "#(randomIsbn)" }
    ]
  }
  """

# ==============================================================
# 4. Insert Book
# ==============================================================
Scenario Outline: Send API Store Book with <scenario>
  * def headers = { Authorization: '#("Bearer " + token)', 'Content-Type': 'application/json' }
  * def requestBody =
  """
  {
    "userId": <userIdParam>,
    "collectionOfIsbns": [
      { "isbn": <isbn> }
    ]
  }
  """

  Given path bookPath
  And headers headers
  And request requestBody
  When method POST
  Then status <expectedStatus>
  And match response == <expectedResponse>

  * print 'Request:', requestBody
  * print 'Response:', response

Examples:
  | scenario   | userIdParam      | isbn | expectedStatus | expectedResponse
  | valid data | '#(userId)'  | '#(randomIsbn)' | 201 | expectedAddBookResponse |
  | invalid user id | 'ID123123'  | '#(randomIsbn)' | 401 | { code: "1207", message: "User Id not correct!" } |
  | empty user id | ''  | '#(randomIsbn)' | 401 | { code: "1207", message: "User Id not correct!" } |
  | null user id | null  | '#(randomIsbn)' | 401 | { code: "1207", message: "User Id not correct!" } |
  | invalid isbn | '#(userId)'  | '1234567890123' | 400 | { code: "1205", message: "ISBN supplied is not available in Books Collection!" } |
  | empty isbn | '#(userId)'  | '' | 400 | { code: "1205", message: "ISBN supplied is not available in Books Collection!" } |
  | null isbn | '#(userId)'  | null | 400 | { code: "1205", message: "ISBN supplied is not available in Books Collection!" } |
  | unauthorized user id | '7e942179-a493-4daa-ba40-8ee312313491'  | '#(randomIsbn)' | 401 | { "code": "1200", "message": "User not authorized!" } |

  Scenario: Send API Store Book with existing data
    # Generate Token Existing user
    Given path generateTokenPath
    And header Content-Type = 'application/json'
    And request { userName: 'ninatest123!', password: 'P@sswordQA123!'}
    When method post
    Then status 200
    * def tokenExistingUser = response.token
    * print 'Generated Token:', tokenExistingUser

  # add list of book
    * def headers = { Authorization: '#("Bearer " + tokenExistingUser)', 'Content-Type': 'application/json' }
    * def requestBody = 
    """
    {
       "userId": '61ec1368-86b1-42fa-b755-65c77553c937',
       "collectionOfIsbns": [
         { "isbn": '9781449325862' }
        ]
    }
    """

  Given url baseUrl
  And path bookPath
  And headers headers
  And request requestBody
  When method post
  * print 'Request:', requestBody
  * print 'Response:', response
  Then status 400
  And match response == { code: "1210", message: "ISBN already present in the User's Collection!" }