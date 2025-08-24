//
//  ContentView.swift
//  TickBar
//
//  Created by Jatin Batra on 19/08/25.
//

import SwiftUI


struct ContentView: View {
    @State private var projects: [Project] = [
        Project(name: "Karan"),
        Project(name: "Naman"),
        Project(name: "Jatin"),
    ]
    @State private var showingAddProject = false
    @State private var newProjectName = ""

    var body: some View {
        ProjectListView()
    }
}


#Preview {
    ContentView()
}
