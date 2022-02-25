//
//  ContentView.swift
//  RandomQuotes
//
//  Created by Eunbi Shin on 2022-02-22.
//

import SwiftUI

struct ContentView: View {
    // MARK: Stored Properties
    // Detect when app moves between background, foreground, and inactive states
    @Environment(\.scenePhase) var scenePhase
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
        // React to changes of state for the app (foreground, background, and inactive)
        .onChange(of: scenePhase) { newPhase in
            
            if newPhase == .inactive {
                
                print("Inactive")
                
            } else if newPhase == .active {
                
                print("Active")
                
            } else if newPhase == .background {
                
                print("Background")
                
                // Permanently save the list of tasks
                persistFavourites()
                
            }

        }

        // Shows different quote when the app is opened
        .task {
            
            await loadNewQuote()
            
            print("Have just attepted to load a new joke.")
            
            // Loading favourites from the local device storage
            loadFavourites()
            
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

    // Loads favourites from local storage on the device into the list of favourites
    func loadFavourites() {
        
        // Get a URL that points to the saved JSON data containing our list of favourites
        let filename = getDocumentsDirectory().appendingPathComponent(savedFavouritesLabel)
        print(filename)
                
        // Attempt to load from the JSON in the stored / persisted file
        do {
            
            // Load the raw data
            let data = try Data(contentsOf: filename)
            
            // What was loaded from the file?
            print("Got data from file, contents are:")
            print(String(data: data, encoding: .utf8)!)

            // Decode the data into Swift native data structures
            // Note that we use [DadJoke] since we are loading into a list (array)
            // of instances of the DadJoke structure
            favourites = try JSONDecoder().decode([RandomQuote].self, from: data)
            
        } catch {
            
            // What went wrong?
            print(error.localizedDescription)
            print("Could not load data from file, initializing with tasks provided to initializer.")

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
