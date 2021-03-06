# Validator

This application is a suite of HTTP unit tests to validate the structure and behaviour of the Vapor Notes API.

It was created as part of the Vapor workshop in [Swift Alps 2017](https://theswiftalps.com/).

A possible implementation of the API is available in the [VaporNotes](https://github.com/TheSwiftAlps/VaporNotes) project.

## Structure

This project is a [standard Swift 4 package](https://swift.org/package-manager/). It has a `Makefile` to simplify some tasks:

- `make` will build the application and the documentation.
- `make build` will build the application, downloading the dependencies if required.
- `make doc` will create the documentation using Jazzy.
- `make xcode` will create an Xcode project.
- `make run` will run the debug version of the application against `http://localhost`

You can run the project against any other URL: `.build/debug/Validator http://server.somewhere.com`

## Specification

The Vapor Notes API has the following characteristics:

- The API receive a "ping" to verify that the network connection is working.
- Anyone can create a new user in the system.
- Logged-in users can create notes.
- Notes are identified using UUIDs, like `C26A187A-64C7-41A6-A367-ADCC1F5A6F19`; this would allow offline systems such as disconnected mobile applications or other devices to create notes independently of the server.
- Notes contain [Markdown](https://daringfireball.net/projects/markdown/) text.
- Users can get all of their notes.
- Users can get one single note.
- Users can edit a single note.
- Users can delete a single note.
- Users can delete all notes at once.
- Users can publish a note; this gives the note a small random "slug" of text, similar to `xyz123` and this slug can be used to access the note publicly, as HTML text converted from the Markdown source.
- Users can unpublish one of their notes at any time.
- Users can request a backup of their notes in ZIP format. The ZIP file contains a file per note, whose filename is the UUID of the note with the `.txt` extension. Each file contains the Markdown source of the note.
- Users can search their notes for the occurrence of a string.

## Dependencies

This script depends on the following libraries:

- [Commander](https://github.com/kylef/Commander)
- [LoremSwiftum](https://github.com/iamjono/LoremSwiftum)
- [Rainbow](https://github.com/onevcat/Rainbow)
- [ZIP Foundation](https://github.com/weichsel/ZIPFoundation)

## Slides

The slides of the presentation of the project are in [Gitpitch](https://gitpitch.com/TheSwiftAlps/Validator).

## Documentation

To generate the documentation of this project, you need the following things:

- [jq](https://stedolan.github.io/jq/): `brew install jq`
- [Sourcekitten](https://github.com/jpsim/SourceKitten): `brew install sourcekitten`
- [Jazzy](https://github.com/realm/jazzy): `gem install jazzy`

## Sample `curl` Requests

Some sample `curl` requests to interact with the API, using `jq` to format the output nicely:

Ping:

`curl http://localhost/ping --request GET`

Login and save authorization token in pasteboard, for future requests:

`curl http://localhost/api/v1/login --silent --user "vapor@theswiftalps.com:swiftalps" --request POST | jq -r .token | pbcopy`

Create note:

`curl http://localhost/api/v1/notes --silent --request POST --header "Authorization: Bearer SNjmXWikniZZLaed8jDG5A==" --header "Content-Type:
 application/json" --data @Fixtures/request_create_note.json | jq`

List of notes:

`curl http://localhost/api/v1/notes --silent --request GET --header "Authorization: Bearer SNjmXWikniZZLaed8jDG5A==" | jq`

Search for notes:

`curl http://localhost/api/v1/notes/search  --silent --request POST --header "Authorization: Bearer FPG1Llqfl5Ju200ZDPb/ig==" --data @Fixtures/request_search.json --header "Content-Type: application/json" | jq`

## Demo

Click on the link below to see a sample run of the validator on a working copy of the API:

[![asciicast](https://asciinema.org/a/escJ0ywke0Ms1nCL2VGMIaekl.png)](https://asciinema.org/a/escJ0ywke0Ms1nCL2VGMIaekl)

