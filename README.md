# Directory Analyzer

### MVP
This is an application to find and count all words within any .txt files within a specific directory.\
The total count of words, as well as the top ten used words will be stored for later viewing.\
I chose to use Elixir/Phoenix framework to build the application with PostgreSQL database with Docker/Docker-Compose.

### New technology:
Even though I have experience working with Elixir/Phoenix, I had not worked with its templating and markup.\
Along this same line, I have worked with Docker, but never have implemented the code to build a Docker image or provision multiple containers.\
I wanted to challenge myself to learn something new while building this application!!

### If I were building this application for production:
  - The code currently selects the top 10 to insert by word count and word descending. I would rather it order by count desc, word asc but wanted to make sure I had time to provide MVP before refactoring code.
    - The assessment stated: "storing the top 10 words." Most of my experience had been inserting all the words in a directory then retrieving only the top ten from the database. That would be less overhead ordering by count desc, word asc.
  - All words are considered when counting. I would like it to exclude the most used words ("a", "an", "the", etc)


## Install Dependencies:

### Docker:
This application uses Docker for local development.

Make sure you have Docker installed and running.
[Install Docker CE](https://docs.docker.com/install/)

If you are on a Mac, install
[Docker for Mac](https://www.docker.com/docker-mac).

### Docker Compose
Docker compose automates the provisioning of containers in the development
environment<br/>
[The `app` itself and `postgres`]

See the current
[installation](https://docs.docker.com/compose/install/#install-compose)
instructions for compose

### Clone repo
Clone the repo to your local machine:

```sh
$ git clone git@github.com:tymondragon/directory_word_processor.git
```

### Running in Development:
From the root of the repo run:

### Build the image
```sh
$ docker-compose build
```

### Run Table Migrations
```sh
$ docker-compose run app mix ecto.setup
```

### Start Container
```sh
$ docker-compose up
```

The app  will be running on
[localhost:4000](http://localhost:4000/).
