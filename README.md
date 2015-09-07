Search test app
======================================

## Installation

This is a brief tutorial about how to get running this application in few steps.

We will go through these steps:
* Checkout the code or unzip it
* Install the dependencies
* Start the Solr service
* Run migrations and seeds
* Run the tests (optional)
* Start the web server
* Access the application
* Re-index the database (optional)
* Shutdown the Solr service (optional)

### Checkout the code or unzip it

Installing from Github:

```
git clone git@github.com:lepek/serch.git
```

If you are installing from a tar.gz file:

```
tar -zxvf [filename].tar.gz
```

### Install the dependencies

```
bundle install
```

### Start the Solr service

This should be done before running the migrations so the Solr server can index automatically the data.
Make sure you have a Java Runtime Environment installed and the system PATH variable setup, and then
start the service like this:

```
bundle exec rake sunspot:solr:start
```

### Run migrations and seeds

```
bundle exec rake db:migrate db:seed
```

### Run the tests (optional)

```
bundle exec rspec spec/
```

### Start the web server

```
bundle exec rails s
```

### Access the application

The application can be reached in the default Rails development URL:

```
http://localhost:3000
```

### Re-index the database (optional)

If for some reason the database was not indexed, because for example, the seed file was load before starting the Solr service,
there isn't any problem, just be sure the Solr service is running and re-index the database like this:

```
bundle exec rake sunspot:reindex
```

### Shutdown the Solr service (optional)

When you don't need to run this app anymore, it's a good idea to shutdown the Solr service

```
bundle exec rake sunspot:solr:stop
```

## Description

Two approaches are introduced by this app:
* Full-text search using Apache Solr
* Built from scratch search

In a real application, probably the first approach would be the best, for a number of reasons:
performance, scalability, robustness, etc. Since the default implementation is very easy, it is included here.
The Solr service used to run this search is intended to be used only by development environments.
Information about how Apache Solr works and the default parser that is implemented in this app
can be found here: https://cwiki.apache.org/confluence/display/solr/The+Standard+Query+Parser

The most interesting search for this exercise probably is the second approach. The relevant classes are documented in-line
and the most important method is unit tested. Decisions were taken following the app description,
personal criteria, but, more important, trying to show as many options and solutions or implementations as possible.
Also, the time constraint is not minor, so for example, only the main search method was unit tested, and only unit testing was done.

It's also important to say that both searches doesn't work exactly in the same way, and that is on purpose because the intention
was not to replicate one in the other. Although both searches will return the same relevant results, there are differences.

## Author

[Martin Bianculli](mailto:mbianculli@gmail.com)
