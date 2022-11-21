# Space HUD

A MacOS menubar application to quicly access code reviews, issues and todos from [Jetbrains Space](https://www.jetbrains.com/space/)

<p align="center">
  <img width="672" alt="Screenshot 2022-11-18 at 9 25 02 PM" src="https://user-images.githubusercontent.com/9363150/202829994-baa757e2-8cef-411f-8624-852d18fa884c.png">
</p>

>In video gaming, the HUD (heads-up display) or status bar is the method by which information is visually relayed to the player as part of a game's user interface. It takes its name from the head-up displays used in modern aircraft.

 -- [Wikipedia](https://en.wikipedia.org/wiki/HUD_(video_gaming))

# Features

 - shows created and/or review requested code requests;
 - shows created and/or assigned issues;
 - change status of an issue;
 - shows todo items
 - create new, mark done or delete a todo item.

# Installation

Download the [latest release](https://github.com/menubar-apps/Space-HUD/releases) and install it.

In the Settings view add your org name and then generate a personal token with following permissions for projects:
 - Read Git repositories,
 - Update issues,
 - View code reviews,
 - View issues,
 - View project details

and with following permissions for Global Context:

 - Update to-dos,
 - View organization details,
 - View to-do

and paste in the token field. Then select a project from the dropdown menu in the sidebar.
