# Vapor Notes API

---

# Objective

- Creation of a Notes API using Vapor.
- Specifications through an ad-hoc "Validator" project.

---

# Specifications 1/3

- The API receive a "ping" to verify that the network connection is working.
- Anyone can create a new user in the system.
- Logged-in users can create notes.
- Notes are identified using UUIDs, like `C26A187A-64C7-41A6-A367-ADCC1F5A6F19`; this would allow offline systems such as disconnected mobile applications or other devices to create notes independently of the server.

---

# Specifications 2/3

- Notes contain [Markdown](https://daringfireball.net/projects/markdown/) text.
- Users can get all of their notes.
- Users can get one single note.
- Users can edit a single note.
- Users can delete a single note.
- Users can delete all notes at once.

---

# Specifications 3/3

- Users can publish a note; this gives the note a small random "slug" of text, similar to `xyz123` and this slug can be used to access the note publicly, as HTML text converted from the Markdown source.
- Users can unpublish one of their notes at any time.
- Users can request a backup of their notes in ZIP format. The ZIP file contains a file per note, whose filename is the UUID of the note with the `.txt` extension. Each file contains the Markdown source of the note.
- Users can search their notes for the occurrence of a string.

---

# Validator Project

- The specs are enforced through the [Validator](https://bitbucket.org/akosma/validator) Swift Package project.
- Download and explore: <https://bitbucket.org/akosma/validator>

---?code=Sources/Infrastructure/BaseScenario.swift&title=Assertions&lang=swift
@[188-192](Asserting for "Content-Type" headers)
@[201-205](Asserting for response status codes)
@[228-230](Asserting for particular headers)

---

# Demo

[![asciicast](https://asciinema.org/a/LcGU1ps5JnzEYFXfSZC2YQSJQ.png)](https://asciinema.org/a/LcGU1ps5JnzEYFXfSZC2YQSJQ)

---

# Tips

- Start with the easiest possible endpoint: "ping".
- Use an in-memory SQLite database for storage.

