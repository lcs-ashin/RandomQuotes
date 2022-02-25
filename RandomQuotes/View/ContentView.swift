//
//  ContentView.swift
//  RandomQuotes
//
//  Created by Eunbi Shin on 2022-02-22.
//

import SwiftUI

struct ContentView: View {
    // MARK: Stored Properties
    @State var currentQuote: RandomQuote = RandomQuote(quoteText: "",
                                                       quoteAuthor: "",
                                                       senderName: "",
                                                       senderLink: "",
                                                       quoteLink: "")
    // List of favourites
    @State var favourites: [RandomQuote] = []
    
    // Is the quote already on the list?
    @State var currentQuoteAddedToFavourites: Bool = false
    
    // MARK: Computed Properties
    var body: some View {
        VStack {
            Text(currentQuote.quoteText)
                .multilineTextAlignment(.leading)
                .padding(30)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.primary, lineWidth: 4)
                )
                .padding(10)
            
            Image(systemName: "heart.circle")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(currentQuoteAddedToFavourites == true ? .red : .secondary)
                .onTapGesture {
                    if currentQuoteAddedToFavourites == false {
                        favourites.append(currentQuote)
                        currentQuoteAddedToFavourites = true
                    }
                }

            Button(action: {
                print("Button was pressed")
                
                Task {
                    await loadNewQuote()
                }
                
            }, label: {
                Text("Another one!")
            })
                .buttonStyle(.bordered)

            HStack {
                Text("Favourites")
                .font(.title3)
                .bold()
                .padding()

                Spacer()
            }
            
            List(favourites, id: \.self) { currentQuote in
                Text(currentQuote.quoteText)
            }
        }
        // Shows different quote when the app is opened
        .task {
            
            await loadNewQuote()
            
            print("Have just attepted to load a new joke.")
            
        }
        .navigationTitle("Random Quotes")
        .padding()
    }
    
    // MARK: Functions
    func loadNewQuote() async {
        
        let url = URL(string: "https://api.forismatic.com/api/1.0/?method=getQuote&key=457653&format=json&lang=en")!
        
        var request = URLRequest(url: url)
        request.setValue("application/json",
                         forHTTPHeaderField: "Accept")
        
        let urlSession = URLSession.shared
        
        // Do-catch block
        do {
            
            let (data, _) = try await urlSession.data(for: request)
            currentQuote = try JSONDecoder().decode(RandomQuote.self, from: data)
            
            currentQuoteAddedToFavourites = false
            
        } catch {
            print("Could not retrieve or decode the JSON from endpoint.")
            print(error)
        }

        
    }
    
    // Saves (persists) the data to local storage on the device
    func persistFavourites() {
        
        // Get a URL that points to the saved JSON data containing our list of tasks
        let filename = getDocumentsDirectory().appendingPathComponent(savedFavouritesLabel)
        
        // Try to encode the data in our people array to JSON
        do {
            // Create an encoder
            let encoder = JSONEncoder()
            
            // Ensure the JSON written to the file is human-readable
            encoder.outputFormatting = .prettyPrinted
            
            // Encode the list of favourites we've collected
            let data = try encoder.encode(favourites)
            
            // Actually write the JSON file to the documents directory
            try data.write(to: filename, options: [.atomicWrite, .completeFileProtection])
            
            // See the data that was written
            print("Saved data to documents directory successfully.")
            print("===")
            print(String(data: data, encoding: .utf8)!)
            
        } catch {
            
            print(error.localizedDescription)
            print("Unable to write list of favourites to documents directory in app bundle on device.")
            
        }

    }

    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView()
        }
    }
}
