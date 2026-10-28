//
//  VariedTabbarView.swift
//  Feather
//
//  Use the regular TabView on compact iPhone layouts so the App Store-style
//  screen can reliably hide the host tab bar. The store has its own floating bar.
//

import SwiftUI

struct VariedTabbarView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    var body: some View {
        if horizontalSizeClass == .compact {
            TabbarView()
        } else if #available(iOS 18, *) {
            ExtendedTabbarView()
        } else {
            TabbarView()
        }
    }
}
