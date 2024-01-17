# Flutter Front End

## Table of Contents

1. [Introduction](#introduction)
2. [Requirements](#requirements)
3. [Installation](#installation)
4. [Getting Started](#getting-started)
5. [Set Up](#set-up)
6. [Usage](#usage)

## Introduction

The Flutter Front End is a new front end made with Flutter, which sets out to create an intuitive mobile ui to both create new flights and view previous ones. It communicates with the RestApi backend to obtain all the needed information from the database.

## Requirements

Before starting with the installation, make sure you have the following software installed on your system:

- Flutter
- VsCode (or any preferred IDE)
- Android Studio (for the mobile emulator)


The following modules are required for full functionality, or at least having connection to them:

- Air RestApi [![RestApi Badge](https://img.shields.io/badge/DEE-RestApi-brightgreen.svg)](https://github.com/JordiLlaveria/GroundAPIRESTDEE)
- Ground RestApi [![RestApi Badge](https://img.shields.io/badge/DEE-RestApi-brightgreen.svg)](https://github.com/JordiLlaveria/AirAPIRESTDEE)
- AutopilotService [![DroneEngineeringEcosystem Badge](https://img.shields.io/badge/DEE-AutopilotService-brightgreen.svg)](https://github.com/JordiLlaveria/OnBoardServicesDEE)

## Installation

For all the installation you can watch the first 20 minutes of this video [Flutter Tutorial For Beginners](https://www.youtube.com/watch?v=CD1Y2DmL5JM) if you're completely new to Flutter I recommend you watch it all and try to follow along.

## Getting Started

These are some useful resources for flutter development:
- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Set Up

You will first need to make sure you got all the dependencies by running
```
flutter pub get
```
Then you will need to make sure you have the emulator opened and running (in this case were using vscode)

<img src="https://github.com/Frixon21/FlutterFrontEndDEE/assets/72676967/3a9a3860-7c4f-4197-aa70-740f5c9af5d0" width="300" height="600">

Finally, you can run the following command to build the project
```
flutter run
```

## Usage 

When the project is running you should be met with the main map. in this window, you can click on the map to add waypoints and then click again around the initial waypoint to close the loop (it might take a few tries).

<img src="https://github.com/Frixon21/FlutterFrontEndDEE/assets/72676967/390950c4-98d0-4f92-9f0a-d5dce27a64ba" width="200" height="400">

When the loop is closed you can click on a waypoint to edit it

<img src="https://github.com/Frixon21/FlutterFrontEndDEE/assets/72676967/9fc447cd-dec1-4d15-97cd-4098b8cac675" width="200" height="400">

The current functionality of this standalone is quite limited and has a lot of room for improvement.

__For the other functionalities you will need to have the required modules, both APIREST modules and onboard services, running.__

The select flight screen allows you to select flights plans from the database and run them as long as you're connected

<img src="https://github.com/JordiLlaveria/FlutterDEE/blob/manager/assets/Flight%20plans.PNG" width="200" height="400">

When a flight plan is selected, it is shown inside the map, allowing to see the points were images, dinamic videos or static ones iwll be taken

<img src="https://github.com/JordiLlaveria/FlutterDEE/blob/manager/assets/Execute%20Flight%20Plan.PNG" width="200" height="400">

The past flights screen allows you to select past flights and see the path as well as a video and image gallery 

<img src="https://github.com/JordiLlaveria/FlutterDEE/blob/manager/assets/Past%20flight.PNG" width="200" height="400">

For example, in the following picture two images can be seen, as it was expected to take one on waypoint number 1, and another in number 5

<img src="https://github.com/JordiLlaveria/FlutterDEE/blob/manager/assets/See%20images.PNG" width="200" height="400">




