//
//  MiniTranslatorApp.swift
//  MiniTranslator
//
//  Created by cheshire on 1/29/25.
//

import SwiftUI

@main
struct MiniTranslatorApp: App {
    // AppDelegate와 연결
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        // 설정 메뉴에 PreferencesView 표시 (메뉴바 앱에서는 Preferences 메뉴를 통해 열림)
        Settings {
            PreferencesView()
        }
    }
}
