Feature: Delete Specific Books in a User 

Background:
  * url baseUrl
  * def userPath = '/Account/v1/User'
  * def bookPath = '/BookStore/v1/Books'
  * def generateTokenPath = '/Account/v1/GenerateToken'
  * def singleBookPath = '/BookStore/v1/Book'
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

# ==============================================================
# 4. Insert Book
# ==============================================================
  * def headers = { Authorization: '#("Bearer " + token)', 'Content-Type': 'application/json' }

  * def requestBody =
  """
  {
    "userId": "#(userId)",
    "collectionOfIsbns": [
      { "isbn": "#(randomIsbn)" }
    ]
  }
  """

  Given path bookPath
  And headers headers
  And request requestBody
  When method POST
  Then status 201
  * print userId

# ==============================================================
# 5. Delete Specific Book based on ISBN
# ==============================================================
Scenario Outline: Delete specific book own by user with <scenario>
  * def usedUserId = userIdParam ? userIdParam : userId
  * def addedIsbn = randomIsbn
  * def usedIsbn = isbnParam ? isbnParam : addedIsbn
  * def headers = { Authorization: '#("Bearer " + token)', 'Content-Type': 'application/json' }
  * def deleteBody =
  """
  {
    "userId": "#(usedUserId)",
    "isbn": "#(usedIsbn)"
  }
  """

  Given path singleBookPath
  And headers headers
  And request deleteBody  
  When method DELETE
  Then status <expectedStatus>

  * print 'Request:', requestBody
  * print 'Response:', response

Examples:
| scenario            | userIdParam | isbnParam     | expectedStatus |
| valid data         |             |               | 204            |
| invalid user id    | ID123123    |               | 401            |
| empty user id      |             |               | 204            |
| null user id       | null        |               | 401            |
| invalid isbn       |             | 1234567890123 | 400            |
| empty isbn         |             |               | 204            |
| null isbn          |             | null          | 400            |
