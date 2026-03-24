Feature: Delete specific User ID 

Background:
  * url baseUrl
  * def userPath = '/Account/v1/User'
  * def generateTokenPath = '/Account/v1/GenerateToken'

# ==============================================================
# 1. register new User
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
# 5. Delete Specific User
# ==============================================================
Scenario: Delete specific User ID
  * def headers = { Authorization: '#("Bearer " + token)', 'Content-Type': 'application/json' }

  Given path userPath, userId
  And headers headers
  When method DELETE
  * print 'Response:', response
  * print 'userId:', userId
  * print 'URL:', baseUrl + userPath + '/' + userId
  Then status 204

Scenario: Delete books in a invalid User ID
  * def invalidUserId = 'ID123123'
  * def headers = { Authorization: '#("Bearer " + token)', 'Content-Type': 'application/json' }

  Given path userPath + '/' + invalidUserId
  And headers headers
  When method DELETE
  Then status 200
  And match response == { code: '1207', message: 'User Id not correct!' }

  * print 'Response:', response