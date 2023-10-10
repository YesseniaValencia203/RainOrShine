//
//  RainOrShineApp.swift
//  RainOrShine
//
//  Created by Consultant on 10/10/23.
//

import SwiftUI

@main
struct RainOrShineApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
