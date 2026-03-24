Feature: Get Single the Book from the Database

Background:
  * url baseUrl
  * def singleBookPath = '/BookStore/v1/Book'

Scenario: Get specific Book with valid ISBN

  Given path singleBookPath
  And param ISBN = '9781449365035'
  When method GET
  Then status 200

  * print 'Response:', response

  And match response contains
  """
  {
    isbn: '9781449365035'
  }
  """

  And match response ==
  """
  {
    isbn: '#string',
    title: '#string',
    subTitle: '#string',
    author: '#string',
    publish_date: '#string',
    publisher: '#string',
    pages: '#number',
    description: '#string',
    website: '#string'
  }
  """