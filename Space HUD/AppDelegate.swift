//
//  AppDelegate.swift
//  Space HUD
//
//  Created by Pavel Makhov on 2022-11-18.
//

import Cocoa
import SwiftUI

@main
class AppDelegate: NSObject, NSApplicationDelegate {
   
    var popover: NSPopover!
    var statusBarItem: NSStatusItem!
    @ObservedObject var model = Model()
    let client = SpaceClient()
    var contentView: ContentView?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {

        contentView = ContentView(model: self.model)

        let popover = NSPopover()
        popover.contentSize = NSSize(width: 600, height: 400)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: contentView)
        self.popover = popover
        
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))
        
        if let button = self.statusBarItem.button {
            let logo = NSImage(named: "space-logo")
            logo?.size = NSSize(width: 18, height: 18)
            button.image = NSImage(named: "space-logo")
            button.action = #selector(togglePopover(_:))
        }
            
        client.getIssueStatuses{ resp in
            Constants.issueStatuses = resp
        }
        
        
        NSApp.setActivationPolicy(.accessory)
    }
    
    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = self.statusBarItem.button {
            if self.popover.isShown {
                self.popover.performClose(sender)
            } else {
                self.model.refresh();
                self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            }
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    @objc
     func quit() {
         NSLog("User click Quit")
         NSApplication.shared.terminate(self)
     }

}

