//
//  FetchData.swift
//  Acquiring information from API and parsing
//  Penn Dining
//

import Foundation

class FetchData: ObservableObject {
    
    // stores values unwrapped from JSON file into response variable
    @Published var response: [ResponseItem] = []
    
    // attempts to decode either JSON file via link and parsing them into data structures below
    func getData() async {
        let primaryURLString = "https://pennmobile.org/api/dining/venues/?format=json"
        let backupURLString = "https://pennlabs.github.io/backup-data/venues.json"
        
        // primary URL unwrapping
        if let primaryURL = URL(string: primaryURLString) {
            do {
                let (data, _) = try await URLSession.shared.data(from: primaryURL)
                let decodedResponse = try JSONDecoder().decode([ResponseItem].self, from: data)
                DispatchQueue.main.async {
                    self.response = decodedResponse
                }
                return
            } catch {
                // backup URL unwrapping
                if let backupURL = URL(string: backupURLString) {
                    do {
                        let (data, _) = try await URLSession.shared.data(from: backupURL)
                        let decodedResponse = try JSONDecoder().decode([ResponseItem].self, from: data)
                        DispatchQueue.main.async {
                            self.response = decodedResponse
                        }
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
        }
    }
}

// takes the name, address, days, image, id, and url from the JSON and parses them into a structure
struct ResponseItem: Codable, Identifiable {
    let name: String
    let address: String
    let days: [Day]
    let image: String
    let id: Int
    
    // distributes proper URL for WebView
    var url: String {
        switch name {
        case "1920 Commons":
            return "https://university-of-pennsylvania.cafebonappetit.com/cafe/1920-commons/"
        case "Hill House":
            return "https://university-of-pennsylvania.cafebonappetit.com/cafe/hill-house/"
        case "English House":
            return "https://university-of-pennsylvania.cafebonappetit.com/cafe/kings-court-english-house/"
        case "Falk Kosher Dining":
            return "https://university-of-pennsylvania.cafebonappetit.com/cafe/falk-dining-commons/"
        case "McClelland Express":
            return "https://university-of-pennsylvania.cafebonappetit.com/cafe/mcclelland/"
        case "Lauder College House":
            return "https://university-of-pennsylvania.cafebonappetit.com/cafe/lauder-college-house/"
        case "Houston Market":
            return "https://university-of-pennsylvania.cafebonappetit.com/cafe/houston-market/"
        case "Accenture Café":
            return "https://university-of-pennsylvania.cafebonappetit.com/cafe/accenture-cafe/"
        case "Joe’s Café":
            return "https://university-of-pennsylvania.cafebonappetit.com/cafe/joes-cafe/"
        case "1920 Gourmet Grocer":
            return "https://university-of-pennsylvania.cafebonappetit.com/cafe/1920-gourmet-grocer/"
        case "1920 Starbucks":
            return "https://university-of-pennsylvania.cafebonappetit.com/cafe/1920-starbucks/"
        case "Pret a Manger MBA":
            return "https://university-of-pennsylvania.cafebonappetit.com/cafe/pret-a-manger-upper/"
        case "Pret a Manger Locust Walk":
            return "https://university-of-pennsylvania.cafebonappetit.com/cafe/pret-a-manger-lower/"
        case "Quaker Kitchen":
            return "https://university-of-pennsylvania.cafebonappetit.com/cafe/quaker-kitchen/"
        case "Cafe West":
            return "https://university-of-pennsylvania.cafebonappetit.com/cafe/cafe-west/"
        default:
            return "https://example.com"
        }
    }
    
    // formats the hours in a day from the dayparts function such that it displays the different cases, in the proper time, removing the ':' at the start of an hour, into a single list using '|' as a separator
    func formatHours(day: Day) -> String {
        
        // if its not open today, return "CLOSED TODAY"
        guard day.status == "open", !day.dayparts.isEmpty else {
            return "CLOSED TODAY"
        }
        
        // sorts dayparts dates into ascending order
        let sortedDayparts = day.dayparts.sorted { (dp1, dp2) -> Bool in
            guard let date1 = DateFormatter().date(from: dp1.starttime),
                  let date2 = DateFormatter().date(from: dp2.starttime) else { return false }
            return date1 < date2
        }
        
        // combines the ascended dayparts into a single string using '|' as the separator
        let timeRanges = sortedDayparts.map { $0.time() }
        let combinedTimes = timeRanges.joined(separator: " | ")
        
        // if there is at least two openings that day, revemo the 'a' and 'p' in the times
        if combinedTimes.contains("|") {
            return combinedTimes.replacingOccurrences(of: "a", with: "").replacingOccurrences(of: "p", with: "")
        }
        
        return combinedTimes
    }
    
    // checks to see if a restaurant is a cafe using hard coding
    var isCafe: Bool {
        return name == "Houstong Market" || name == "Accenture Café" || name == "Joe's Café" || name == "1920 Gourmet Grocer" || name == "1920 Starbucks" || name == "Pret a Manger MBA" || name == "Pret a Manger Locust Walk" || name == "Quaker Kitchen" || name == "Cafe West"
    }
}

// day structure within Response
struct Day: Codable {
    let date: String
    let status: String
    let dayparts: [Daypart]
}

// daypart structure
struct Daypart: Codable {
    let starttime: String
    let endtime: String
    let message: String
    let label: String
    
    // converts the time of a single daypart opening into to a string '#:##a/p - #:##a/p' format
    func time() -> String {
        
        // makes formatter that matches the JSON pattern for start and end times
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        // makes formatter in the pattern of '#:##a/p - #:##a/p'
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mma"
        
        // checks if the start and end times can be converted from the JSON format
        guard let startDate = dateFormatter.date(from: starttime),
              let endDate = dateFormatter.date(from: endtime) else {
            return ""
        }
        
        // removes the ':00' at the start of an hour
        var startTime = timeFormatter.string(from: startDate).replacingOccurrences(of: ":00", with: "")
        var endTime = timeFormatter.string(from: endDate).replacingOccurrences(of: ":00", with: "")
        
        // replace the 'AM' with 'a' and 'PM' with 'p'
        startTime = startTime.replacingOccurrences(of: "AM", with: "a")
        startTime = startTime.replacingOccurrences(of: "PM", with: "p")
        endTime = endTime.replacingOccurrences(of: "AM", with: "a")
        endTime = endTime.replacingOccurrences(of: "PM", with: "p")
        
        // returns the formatted time range "#:##a/p - #:##a/p"
        return "\(startTime) - \(endTime)"
    }
}
