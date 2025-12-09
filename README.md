# Self-Healing Automation Framework with Local LLM

This project demonstrates a proof-of-concept test automation framework that uses a local Large Language Model (LLM) to perform self-healing of broken element locators at runtime.

**Tech Stack:**
- **Java 11**
- **Selenium 4**
- **TestNG**
- **Maven** for dependency management
- **Docker** and **Ollama** to run the local LLM
- **Code Llama 13B Instruct** as the healing model

---

## How It Works

1.  A test attempts to find an element using `SafeActions.findElementAndHeal()`.
2.  If the locator fails with a `NoSuchElementException`, the framework catches the error.
3.  It captures the page's current DOM and sends it, along with the broken locator and its intent, to a local LLM running via Ollama.
4.  The LLM analyzes the information and generates a suggested new XPath locator.
5.  The framework retries finding the element with the new locator.
6.  If successful, the test continues with the healed element. If not, the test fails.

---

## Setup and Execution Instructions

### Prerequisites

1.  **Java Development Kit (JDK) 11 or higher:** Make sure `JAVA_HOME` is set and `java` is on your PATH.
2.  **Apache Maven:** Make sure `mvn` is on your PATH.
3.  **Docker Desktop:** Install Docker for your operating system. It is required to run the local LLM.

### Step 1: Start the Local LLM Server

This framework uses Docker and Ollama to serve the `codellama:13b-instruct` model. The initial setup will download the model, which is several gigabytes, so it may take some time.

Open a terminal in the project root directory (`C:\frameworkAlpha`) and run the following command:

```bash
docker-compose up -d
```

- `-d` runs the container in detached mode (in the background).
- The first time you run this, it will:
    1.  Pull the `ollama/ollama` image.
    2.  Start the Ollama server.
    3.  Run a setup service that pulls the `codellama:13b-instruct` model into a shared volume. This can take 10-20 minutes depending on your internet connection.

To check if the server is ready, you can view the logs:

```bash
docker-compose logs -f ollama
```

Once the model is downloaded and the server is listening, you can proceed.

### Step 2: Run the Test

Open a new terminal in the project root directory (`C:\frameworkAlpha`).

Run the test using Maven:

```bash
mvn clean test
```

Maven will download all the project dependencies, compile the code, and execute the test defined in `testng.xml`.

### Step 3: Observe the Output

You will see the TestNG output in your terminal. Pay close attention to the logs, where you will see:

1.  The initial `NoSuchElementException` being caught.
2.  The framework printing `--- ELEMENT NOT FOUND, INITIATING SELF-HEALING ---`.
3.  The `LLMHealer` logging the prompt sent to the model.
4.  The LLM's suggested new locator being printed.
5.  The framework printing `--- SELF-HEALING SUCCESSFUL! ---`.
6.  The test continuing and passing using the new, healed locator.

---

## Project Structure

- `pom.xml`: Defines all project dependencies (Selenium, TestNG, etc.).
- `docker-compose.yml`: Configures the Ollama server and model download.
- `testng.xml`: Defines the test suite to be executed.
- `src/main/java/com/frameworkalpha/core/`:
    - `BaseTest.java`: Base class for tests, handles WebDriver setup/teardown.
    - `LLMHealer.java`: The core class that constructs prompts and calls the LLM API.
    - `SafeActions.java`: Wraps Selenium actions with the try/catch healing logic.
    - `HealedElement.java`: A simple data class for healing results.
- `src/test/java/com/frameworkalpha/tests/`:
    - `SampleTest.java`: Example test that uses a broken locator to demonstrate the healing process.
