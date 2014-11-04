# solr-migrate

Apache Solr migration scripts for stopwords and synonyms

## migratestopwords

Migrates stopwords.txt file. Takes the core configuration folder as starting point and finds all the stopwords.txt files in its subfolders. Then reads the stop word files and transforms them into the JSON format Solr uses in 4.8. The new JSON files are placed into the conf folder rather than the folder where the stopwords.txt file was found, since that's where Solr looks for them now.

Usage:
`$  migratestopwords.rb path/to/solr/core/conf/folder`

## migratesynonyms

... watch this place
