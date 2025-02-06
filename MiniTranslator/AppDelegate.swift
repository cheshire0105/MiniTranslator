//
//  AppDelegate.swift
//  MiniTranslator
//
//  Created by cheshire on 1/29/25.
//

import Cocoa
import SwiftUI
import Translation // WWDC24 번역 API

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var popover: NSPopover!

    func applicationDidFinishLaunching(_ notification: Notification) {
        // 1) 메뉴바 아이템 생성
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "globe", accessibilityDescription: nil)
            button.action = #selector(togglePopover(_:))
        }

        // 2) 팝오버 생성 및 SwiftUI 뷰 연결
        popover = NSPopover()
        popover.contentSize = NSSize(width: 300, height: 150)
        popover.behavior = .transient

        let contentView = TranslatorContentView()
        popover.contentViewController = NSViewController()
        popover.contentViewController?.view = NSHostingView(rootView: contentView)
    }

    @objc func togglePopover(_ sender: Any?) {
        guard let button = statusItem.button else { return }
        if popover.isShown {
            popover.performClose(sender)
        } else {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        }
    }
}
