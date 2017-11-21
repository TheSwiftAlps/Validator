# Vapor Notes API

---

# Objective

- Creation of a Notes API using Vapor
- Specifications through an ad-hoc "Validator" project
- Vapor ready to use in a Docker image

---

# Docker

`sudo docker run --interactive --tty --privileged --publish 80:8080 --user=developer --volume ~/Desktop:/home/developer/Desktop akosma/vapor zsh`

- Ready-to-use Docker image contains Swift Vapor, tmux, zsh…
- User `developer`, password `developer`
- Can be used interactively
- Exposes port 8080 (Vapor) to port 80 in local machine
- Local Desktop becomes image desktop

---

# Specifications 1/3

- The API receive a "ping"
- Anyone can create a new user in the system
- Logged-in users can create notes
- Notes are identified using UUIDs

---

# Specifications 2/3

- Notes contain [Markdown](https://daringfireball.net/projects/markdown/) text
- Users can get all of their notes
- …get one single note
- …edit a single note
- …delete a single note
- …delete all notes at once

---

# Specifications 3/3

- …publish a note in HTML
- …unpublish notes
- …request a backup of their notes in ZIP format
- …search their notes for the occurrence of a string

---

# Validator Project

- Specs: [Validator](https://bitbucket.org/akosma/validator) (Swift package)
- Download: <https://bitbucket.org/akosma/validator>

---?code=Sources/Infrastructure/BaseScenario.swift&title=Assertions&lang=swift
@[188-192](Asserting for "Content-Type" headers)
@[201-205](Asserting for response status codes)
@[228-230](Asserting for particular headers)

---?code=Sources/Scenarios/PingScenario.swift&title=Ping Scenario&lang=swift
@[18-29](Example scenario)

---

# Demo

[![asciicast](https://asciinema.org/a/LcGU1ps5JnzEYFXfSZC2YQSJQ.png)](https://asciinema.org/a/LcGU1ps5JnzEYFXfSZC2YQSJQ)

---

# Working Tips

- Routes must match the specification exactly
- Start with the easiest possible endpoint: "ping"
- Use an in-memory SQLite database for storage
- Vapor provides almost everything off-the box
    - ZIP integration is the most difficult part of the exercise
- Here to help!

---

# Good luck!

