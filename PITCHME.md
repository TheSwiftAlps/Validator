# Vapor Workshop

## The Swift Alps

### Crans Montana – Switzerland

Thursday, November 23rd, 2017

---

## @fa[cloud] Vapor

- Creation of a Notes API using Vapor 2.0
- Specifications through an ad-hoc "Validator" project
- Vapor ready to use in a Docker image
- Team with highest number of green tests wins!

---

## @fa[picture-o] Docker

- Ready-to-use Docker image contains Swift 4, Vapor 2, SQLite, tmux, zsh…
    - Based on [Phusion Base Image](http://phusion.github.io/baseimage-docker/)
    - Dockerfiles available for reference
- User `developer`, password `developer`
    - Can be used interactively
    - Local Desktop becomes image desktop
- Maps port 8080 (Vapor) to port 80 in local machine

---

## @fa[arrows-alt] ngrok

- Simple reverse forwarding for your API
- Provide me with the temporary URL for your API at the end of the exercise

---

## @fa[file-text] API Specifications 1/3

- The API receive a "ping"
- Anyone can create a new user in the system
- Logged-in users can create notes
- Default user:
    - username "vapor@theswiftalps.com"
    - password "swiftalps"

---

## @fa[file-text] API Specifications 2/3

- Notes are identified using UUIDs
- Notes contain [Markdown](https://daringfireball.net/projects/markdown/) text
- Users can get all of their notes
- …get one single note
- …edit a single note
- …delete a single note

---

## @fa[file-text] API Specifications 3/3

- …delete all notes at once
- …publish a note in HTML
- …unpublish notes
- …request a backup of their notes in ZIP format
- …search their notes for the occurrence of a string

---

## @fa[check] Validator

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

## @fa[sort-numeric-desc] Points

- GET & DELETE requests: 3 points
- POST & PUT requests: 5 points
- ZIP Backup: 10 points

**Maximum Score: 152 Points**

---

## @fa[street-view] Demo

[![asciicast](https://asciinema.org/a/escJ0ywke0Ms1nCL2VGMIaekl.png)](https://asciinema.org/a/escJ0ywke0Ms1nCL2VGMIaekl)

---

## @fa[briefcase] Working Tips

- Study `Sources/Scenarios` & `Sources/Infrastructure/API.swift`
- Start with the easiest possible endpoint: `ping`
- Vapor provides a lot!
    - Use an in-memory SQLite database for storage
    - ZIP archive is the most difficult part
    - Middlewares!

---

## @fa[comments] Vapor Cheatsheet

- `vapor new Notes --template=api`
- `vapor build`
- `vapor run serve`
- `vapor xcode`
- `vapor clean`

---

## @fa[comments] ngrok Cheatsheet

- `ngrok http 80`
- Monitor interface: <http://127.0.0.1:4040/>
- Forwarding: <http://xxxxxxxx.eu.ngrok.io/>

---

## @fa[comments] Docker Cheatsheet

- `sudo docker run --interactive --tty --privileged --publish 80:8080 --user=developer --volume ~/Desktop:/home/developer/Desktop akosma/vapor zsh`
- `docker container list`
- `docker images`

---

## @fa[comments] Links

- Validator: <https://bitbucket.org/akosma/validator>
- Vapor docs: <https://docs.vapor.codes/2.0/>
- Docker docs: <https://docs.docker.com/>
- ngrok docs: <https://ngrok.com/docs>
- ZIP Foundation: <https://github.com/weichsel/ZIPFoundation>
- Docker base image: <http://phusion.github.io/baseimage-docker/>

---

## @fa[graduation-cap] Good luck!

