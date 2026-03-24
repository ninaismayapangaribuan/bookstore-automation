# 🧪 Karate API Automation - Bookstore

This project contains API automation tests for the Bookstore application using the Karate framework.

## 📌 Prerequisites

Make sure you have the following installed:
- Java (JDK 11 or higher)
- Maven

---

## 🚀 How to Run Tests

### 1. Clone Repository

```bash
git clone <https://github.com/ninaismayapangaribuan/bookstore-automation>
cd bookstore-automation
```
### 2. Run All test
cd karate-demo
mvn test
or 
Run Specific test File (get-single-book.feature)
mvn -f karate-demo/pom.xml test -Dkarate.options="classpath:features/get-single-book.feature"

### 3. Project Structure
karate-demo/
├── src/test/java/features/
│   ├── get-book.feature
│   ├── get-single-book.feature
│   ├── post-book.feature
│   ├── delete-specific-book.feature
│   ├── delete-all-book.feature
│   └── create-user.feature
├── runners/
│   └── TestRunner.java
├── karate-config.js
└── pom.xml
