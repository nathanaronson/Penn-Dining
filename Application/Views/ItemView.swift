//
//  ItemView.swift
//  Penn Dining
//  View/capsule that is displayed in the list within ContentView
//

import SwiftUI

struct ItemView: View {
    
    // accessing restaurant to be displayed, does not need @ declaration because it is simply being passed down and not observed
    var item: ResponseItem
    
    var body: some View {
        // massive HStack to conform to capsule dimensions
        HStack {
            // attempts to display image URL from JSON file, asynchronously
            AsyncImage(url: URL(string: item.image)) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
            .frame(width: 100, height: 60)
            .cornerRadius(8)
            
            // displays the information about the restaurant
            VStack(alignment: .leading) {
                HStack {
                    // whether its open
                    Text(item.days[0].status == "open" ? "OPEN" : "CLOSED")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(item.days[0].status == "open" ? .blue : .gray)
                }
                // its name
                Text(item.name)
                    .font(.system(size: 18, weight: .regular))
                // the formatted hours by calling the function declared in FetchData
                Text(item.formatHours(day: item.days[0]))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}
