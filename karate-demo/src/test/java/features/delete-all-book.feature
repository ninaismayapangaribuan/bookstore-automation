Feature: Delete All Books in a User 

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
# 5. Delete All Book in a User
# ==============================================================
Scenario: Delete all books in a specific Used ID
  * def headers = { Authorization: '#("Bearer " + token)', 'Content-Type': 'application/json' }

  Given path bookPath
  And param UserId = userId
  And headers headers
  When method DELETE
  Then status 204

  * print 'Response:', response

Scenario: Delete books in a invalid Used ID
  * def headers = { Authorization: '#("Bearer " + token)', 'Content-Type': 'application/json' }

  Given path bookPath
  And param UserId = 'ID123123'
  And headers headers
  When method DELETE
  Then status 401
  And match response == { code: '1207', message: 'User Id not correct!' }

  * print 'Response:', response
