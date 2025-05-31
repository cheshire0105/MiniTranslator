//
//  MiniTranslatorApp.swift
//  MiniTranslator
//
//  Created by cheshire on 1/29/25.
//

import SwiftUI

@main
struct MiniTranslatorApp: App {
    var body: some Scene {
        // MenuBarExtra를 사용하여 메뉴바 앱 구현
        MenuBarExtra("Mini Translator", systemImage: "globe") {
            TranslatorContentView()
        }
        .menuBarExtraStyle(.window)
        
        // 설정 메뉴에 PreferencesView 표시
        Settings {
            PreferencesView()
        }
    }
}
