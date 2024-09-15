# Penn Dining – iOS Challenge for Penn Labs

## Overview
This project is a SwiftUI-based application modeling every dining venues and their corresponding hours. Interaction within the app include viewing a list of dining halls and retail dining locations, check if a venue is open, and navigate to a separate view containing more in-depth information for each venue.

## Requirements 
* Developed using Xcode 5.1
* Coded in Swift 15.4
* Running on iOS 17.5

## Project Structure
```bash
Application/
│
├── Views/
│   ├──ContentView.swift     # Main view listing all dining venues
│   ├──ItemView.swift        # View component for individual venue cells
│   ├──WebView.swift         # Simple WebView component to display venue menus
├── Models/
│   ├──FetchData.swift       # Handles API fetching and JSON decoding
│      ├── ResponseItem      # Model for the response and venue data
│      ├── Day               # Model representing each day's date and hours
│      └── Daypart           # Model representing time slots in a day
└── ApplicationApp.swift     # Designates app and executes it on run 
└── Assets.xcassets/         # Contains app images and icons
```

## ContentView

The ContentView is the main entry point of the app. It displays a categorized list of dining halls and retail dining locations by creating a ```FetchData()``` object from the FetchData.swift file, containing the information from the API. Using a ```NavigationView``` and a ```List``` within the view, the user can then select on any capsule using a ```NavigationLink``` to navigate to a ```WebView``` via a hardcoded URL for further details.

## ItemView

The ItemView is another view within the app. It is displayed within the ContentView in a ```List``` in the form of a capsule. The view itself is solely focused on one item, or restaurant, within the ```FetchData()``` structure hierarchy. Bound within an ```HStack```, it displays an asychronous of the restaurant by accessing the ```image``` property within the ```ResponseItem```. It also displays the name, whether it is open, and the hours using a ```VStack```. The ItemView acts as a label within a ```NavigationLink``` such that it may be clicked on to load the destination, the in-depth WebView.

## WebView

The WebView is another view that is the destination of the ```NavigationLink``` within the ContentView class. It simply loads a webpage given a URL, which is hard-coded into each restaurant's ```ResponseItem``` property.

## FetchData

The FetchData is the backend of the app. It calls the [API](https://choosealicense.com/licenses/mit/](https://pennmobile.org/api/dining/venues/?format=json)) in an attempt to decode the JSON file into its various properties. If this API is down, it then attempts to decode the backup [API](https://choosealicense.com/licenses/mit/](https://pennmobile.org/api/dining/venues/?format=json)](https://pennlabs.github.io/backup-data/venues.json)). The data of the JSON file is broken into its various components:

* Response, which is a list of ResponseItems
* ResponseItems, which synonymous the dining venue itself.
  - name property as a String
  - address property as a String
  - day property as a list of Days (for the week)
  - image property as a String (URL)
  - id property as an int
* Day, which is describes the hours of the restaurant for a given day within a week
  - date property as a String
  - status property as a String
  - dayparts property as a list of Dayparts (sections within the day)
* Dayparts, which describes a given opening range within a day
  - starttime property as a String
  - endtime property as a String
  - message as a String
  - label as a String

## License

[MIT](https://choosealicense.com/licenses/mit/)
