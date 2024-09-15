//
//  ContentView.swift
//  Main View displaying list of restaurants
//  Penn Dining
//

import SwiftUI

struct ContentView: View {
    
    // acquires data from unwrapped JSON
    @ObservedObject var fetchData = FetchData()
    
    var body: some View {
        // navigation view such that we can scroll
        NavigationView {
            // list for each element
            List {
                // section contaiing date, dining, and each restaurant
                Section() {
                    // vstack for the date and type of dining such that they aren't separated within a list
                    VStack {
                        // calls getDate function and returns the date formatted
                        Text(getDate())
                            .font(.system(size: 12, weight: (.semibold)))
                            .foregroundColor(.gray)
                            .padding(.trailing, 30)
                        // displays Dining Halls
                        Text("Dining Halls")
                            .font(.system(size: 32, weight: .bold))
                    }
                    // iterates through every element of response in which it isn't a cafe, generating a navigation link to the WebView and displaying the ItemView as a capsule
                    ForEach(fetchData.response.filter { $0.isCafe != true}) { place in
                        NavigationLink(destination: WebView(url: URL(string: place.url)!)) {
                            ItemView(item: place)
                        }
                    }
                    // section contaiing retail dining and each retail store
                    Section() {
                        // displays "Retail Dining"
                        Text("Retail Dining")
                            .font(.system(size: 32, weight: .bold))
                            .padding(.top, 50)
                        // iterates through every element of response in which it is a cafe, generating a navigation link to the WebView and displaying the ItemView as a capsule
                        ForEach(fetchData.response.filter { $0.isCafe == true}) { place in
                            NavigationLink(destination: WebView(url: URL(string: place.url)!)) {
                                ItemView(item: place)
                            }
                        }
                    }
                }
            }
        }
        // wait for data to come in before generating
        .task {
            await fetchData.getData()
        }
    }
}

// simulation for me
#Preview {
    ContentView()
}

// gets the date on the iPhone and converts it to "Day of Week, Month Day" format
func getDate() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE, MMMM d"
    return dateFormatter.string(from: Date()).uppercased()
}
