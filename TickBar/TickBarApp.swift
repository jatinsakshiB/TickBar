//
//  TickBarApp.swift
//  TickBar
//
//  Created by Jatin Batra on 19/08/25.
//

import SwiftUI
import SwiftData
import ServiceManagement

@main
struct TickBarApp: App {
   
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    init() {
        enableLaunchAtLogin()
    }
    
    var body: some Scene {
        Settings{
            EmptyView()
        }
    }
}


class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var popover: NSPopover!

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create status bar item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem?.button {
            if let image = NSImage(named: "MenuBarIc") {
                image.size = NSSize(width: 24, height: 16) // adjust size here
                button.image = image
            }
            button.action = #selector(togglePopover(_:))
        }

        // Create popover content
        popover = NSPopover()
        popover.contentSize = NSSize(width: 300, height: 350)
        popover.behavior = .transient
        let contentView = ContentView()
            .modelContainer(for: [Project.self, Task.self])
        popover.contentViewController = NSHostingController(rootView: contentView)
    }

    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = statusItem?.button {
            if popover.isShown {
                popover.performClose(sender)
            } else {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
                popover.contentViewController?.view.window?.makeKey()
            }
        }
    }
}


func enableLaunchAtLogin() {
    if SMAppService.mainApp.status != .enabled {
        do {
            try SMAppService.mainApp.register()
            print("✅ App set to launch at login")
        } catch {
            print("❌ Failed to set launch at login: \(error)")
        }
    }
}
