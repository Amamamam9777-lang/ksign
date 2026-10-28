//
//  VariedTabbarView.swift
//  Feather
//
//  Use the regular TabView on compact iPhone layouts. The App Store-style
//  screen reuses the host app's original tab bar instead of drawing a duplicate.
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
