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

            Button(action: {
                print("Button was pressed")
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
            
            List {
                Text("Success builds character. Failure reveals it.")
                Text("Nothing could be worse than the fear that one had given up too soon, and left one unexpended effort that might have saved the world.")
                Text("Nothing happens unless first we dream.")
            }
        }
        // Shows different quote when the app is opened
        .task {
            let url = URL(string: "http://forismatic.com/en/")!
            
            var request = URLRequest(url: url)
            request.setValue("application/json",
                             forHTTPHeaderField: "Accept")
            
            let urlSession = URLSession.shared
            
            // Do-catch block
            do {
                
                let (data, _) = try await urlSession.data(for: request)
                currentQuote = try JSONDecoder().decode(RandomQuote.self, from: data)
                
            } catch {
                print("Could not retrieve or decode the JSON from endpoint.")
                print(error)
            }
        }
        .navigationTitle("Make Your Day Better With Random Quotes")
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView()
        }
    }
}
