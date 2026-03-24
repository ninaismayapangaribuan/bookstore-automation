Feature: Get All the Book in the Database

Background:
  * url baseUrl
  * def bookPath = '/BookStore/v1/Books'

Scenario: Get All the Book in the Database

  Given path bookPath
  When method GET
  Then status 200

  * print 'Response:', response

  And match response ==
  """
  {
    books: '#[]'
  }
  """

  * assert response.books.length > 0

  And match each response.books ==
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