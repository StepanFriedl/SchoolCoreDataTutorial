//
//  SchoolCoreDataTutorialApp.swift
//  SchoolCoreDataTutorial
//
//  Created by Štěpán Friedl on 29.05.2023.
//

import SwiftUI

@main
struct SchoolCoreDataTutorialApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
