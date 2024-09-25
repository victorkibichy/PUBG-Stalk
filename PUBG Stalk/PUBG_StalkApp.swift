//
//  PUBG_StalkApp.swift
//  PUBG Stalk
//
//  Created by  Bouncy Baby on 9/25/24.
//

import SwiftUI

@main
struct PUBG_StalkApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
