//
//  ContentView.swift
//  RandomQuotes
//
//  Created by Eunbi Shin on 2022-02-22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Hello, world!")
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
    
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
