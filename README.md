# Validator

This application is a suite of HTTP unit tests to validate the structure and behaviour of the Vapor Notes API.

It was created as part of the Vapor workshop in [Swift Alps 2017](https://theswiftalps.com/).

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

## Documentation

To generate the documentation of this project, you need the following things:

- [jq](https://stedolan.github.io/jq/): `brew install jq`
- [Sourcekitten](https://github.com/jpsim/SourceKitten): `brew install sourcekitten`
- [Jazzy](https://github.com/realm/jazzy): `gem install jazzy`

