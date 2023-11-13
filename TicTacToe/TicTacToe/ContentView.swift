//
//  ContentView.swift
//  TicTacToe
//
//  Created by Andres Vidal on 6/11/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
      GeometryReader { proxy in
        Grid {
            GridRow {
              Rectangle()
                .fill(Color.green)
                .frame(width: proxy.size.width/3, height: proxy.size.width/3)


            }
            GridRow {
                Image(systemName: "hand.wave")
                Text("World")
            }
        }
      }
    }
}
#Preview {
  ContentView()
    .modelContainer(for: Item.self, inMemory: true)
}
