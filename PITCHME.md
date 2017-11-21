# Vapor Workshop

## The Swift Alps 2017 – Crans Montana – Switzerland

---

## Objective

- Creation of a Notes API using Vapor 2.0
- Specifications through an ad-hoc "Validator" project
- Vapor ready to use in a Docker image
- Team with highest number of green tests wins!

---

## Docker

- Ready-to-use Docker image contains Swift Vapor, tmux, zsh…
- User `developer`, password `developer`
- Can be used interactively
- Exposes port 8080 (Vapor) to port 80 in local machine
- Local Desktop becomes image desktop
- Dockerfiles available for reference

---

## Specs 1/3

- The API receive a "ping"
- Anyone can create a new user in the system
- Logged-in users can create notes
- Notes are identified using UUIDs

---

## Specs 2/3

- Notes contain [Markdown](https://daringfireball.net/projects/markdown/) text
- Users can get all of their notes
- …get one single note
- …edit a single note
- …delete a single note
- …delete all notes at once

---

## Specs 3/3

- …publish a note in HTML
- …unpublish notes
- …request a backup of their notes in ZIP format
- …search their notes for the occurrence of a string

---

## Validator Project

- Swift package
- macOS & Linux
- Makefile for common tasks
- Dockerfiles available in `docker` project for reference

---?code=Sources/Infrastructure/BaseScenario.swift&title=Assertions&lang=swift
@[188-192](Asserting for "Content-Type" headers)
@[201-205](Asserting for response status codes)
@[228-230](Asserting for particular headers)

---?code=Sources/Scenarios/PingScenario.swift&title=Ping Scenario&lang=swift
@[18-29](Example scenario)

---

## Demo

[![asciicast](https://asciinema.org/a/LcGU1ps5JnzEYFXfSZC2YQSJQ.png)](https://asciinema.org/a/LcGU1ps5JnzEYFXfSZC2YQSJQ)

---

## Working Tips

- Study `Validator/Sources/Scenarios` carefully
- Start with the easiest possible endpoint: "ping"
- Routes must match the specification exactly
- Use an in-memory SQLite database for storage
- Vapor provides almost everything off-the box
    - ZIP archive is the most difficult part
- I am here to help!

---

## Vapor Cheatsheet

- `vapor new Notes --template=api`
- `vapor build`
- `vapor run serve`

---

## ngrok Cheatsheet

- `ngrok http 80` (or 8080)
- Web interface: <http://127.0.0.1:4040/>
- Forwarding: <http://xxxxxxxx.eu.ngrok.io/>

---

## Docker Cheatsheet

- `sudo docker run --interactive --tty --privileged --publish 80:8080 --user=developer --volume ~/Desktop:/home/developer/Desktop akosma/vapor zsh`
- `docker container list`
- `docker images`

---

## Links

- Validator: <https://bitbucket.org/akosma/validator>
- Vapor documentation: <https://docs.vapor.codes/2.0/>
- ZIP Foundation: <https://github.com/weichsel/ZIPFoundation>

---

## Good luck!

