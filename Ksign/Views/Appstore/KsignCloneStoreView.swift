//
// Adapted from ios-26-clone by Amamamam9777-lang (see ThirdPartyLicenses/ios-26-clone-LICENSE).
// Demonstration-only App Store-style UI; buttons and catalogue use mock data.
// Integrated into Ksign as a visual demo. Not an Apple-provided component.
//

//
//  KsignCloneAppItem.swift
//  iOS
//
//  Created by Pallav Agarwal on 11/20/25.
//


import SwiftUI
import Combine
import UIKit

// Local history of apps whose installation was initiated through Ksign.
// This is not a system-wide inventory of every app installed on the device.
struct KsignInstalledApp: Codable, Identifiable, Equatable {
    var id: String { bundleID }
    let name: String
    let bundleID: String
}

final class KsignInstalledAppsStore: ObservableObject {
    static let shared = KsignInstalledAppsStore()
    @Published private(set) var apps: [KsignInstalledApp] = []
    private let key = "Ksign.installedAppsHistory.v1"

    private init() { load() }

    func record(name: String, bundleID: String) {
        guard !bundleID.isEmpty else { return }
        apps.removeAll { $0.bundleID == bundleID }
        apps.insert(KsignInstalledApp(name: name.isEmpty ? bundleID : name, bundleID: bundleID), at: 0)
        save()
    }

    func remove(bundleID: String) {
        apps.removeAll { $0.bundleID == bundleID }
        save()
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([KsignInstalledApp].self, from: data) else { return }
        apps = decoded
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(apps) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
}

// MARK: - Data Models

struct KsignCloneAppItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let category: String
    let iconColor: Color
    let iconSymbol: String
    let rating: Double
    let reviews: String
    let size: String
    let age: String
    let screenshots: [Color]
    let description: String
}

struct KsignCloneTodayCardItem: Identifiable {
    let id = UUID()
    let category: String
    let title: String
    let subtitle: String
    let imageColor: Color
    let overlayPosition: Alignment
}

class KsignCloneStoreData: ObservableObject {
    @Published var featuredApps: [KsignCloneAppItem] = []
    @Published var games: [KsignCloneAppItem] = []
    @Published var todayCards: [KsignCloneTodayCardItem] = []
    
    init() {
        generateMockData()
    }
    
    func generateMockData() {
        featuredApps = [
            KsignCloneAppItem(name: "Procreate", category: "Graphics & Design", iconColor: .purple, iconSymbol: "paintbrush.fill", rating: 4.8, reviews: "24K", size: "450 MB", age: "4+", screenshots: [.purple, .blue, .pink], description: "Sketch, paint, create."),
            KsignCloneAppItem(name: "Linear", category: "Productivity", iconColor: .black, iconSymbol: "checklist", rating: 4.9, reviews: "12K", size: "80 MB", age: "4+", screenshots: [.gray, .black, .white], description: "Issue tracking built for speed."),
            KsignCloneAppItem(name: "Duolingo", category: "Education", iconColor: .green, iconSymbol: "message.fill", rating: 4.7, reviews: "1.2M", size: "120 MB", age: "4+", screenshots: [.green, .orange, .yellow], description: "Learn languages for free."),
            KsignCloneAppItem(name: "Flighty", category: "Travel", iconColor: .orange, iconSymbol: "airplane", rating: 4.8, reviews: "8K", size: "95 MB", age: "4+", screenshots: [.orange, .blue, .black], description: "Live flight tracking."),
            KsignCloneAppItem(name: "Spotify", category: "Music", iconColor: .green, iconSymbol: "music.note", rating: 4.8, reviews: "20M", size: "150 MB", age: "12+", screenshots: [.black, .green, .gray], description: "Music for everyone.")
        ]
        
        games = [
            KsignCloneAppItem(name: "Clash Royale", category: "Strategy", iconColor: .blue, iconSymbol: "shield.fill", rating: 4.6, reviews: "3M", size: "200 MB", age: "9+", screenshots: [.blue, .red, .yellow], description: "Real-time multiplayer battles."),
            KsignCloneAppItem(name: "Genshin Impact", category: "RPG", iconColor: .cyan, iconSymbol: "star.fill", rating: 4.7, reviews: "500K", size: "3.5 GB", age: "12+", screenshots: [.cyan, .purple, .orange], description: "Step into Teyvat."),
            KsignCloneAppItem(name: "Subway Surfers", category: "Action", iconColor: .red, iconSymbol: "figure.run", rating: 4.5, reviews: "1.5M", size: "180 MB", age: "9+", screenshots: [.red, .yellow, .green], description: "Dash as fast as you can!"),
            KsignCloneAppItem(name: "Minecraft", category: "Simulation", iconColor: .green, iconSymbol: "cube.fill", rating: 4.9, reviews: "10M", size: "500 MB", age: "9+", screenshots: [.green, .brown, .blue], description: "Create, explore and survive."),
            KsignCloneAppItem(name: "PUBG MOBILE", category: "Top Battle Royale Mobile", iconColor: .orange, iconSymbol: "scope", rating: 4.3, reviews: "2.8M", size: "3.8 GB", age: "12+", screenshots: [.orange, .black, .gray], description: "Survive and compete in battle royale matches."),
            KsignCloneAppItem(name: "Call of Duty: Mobile", category: "Action", iconColor: .black, iconSymbol: "scope", rating: 4.7, reviews: "1.8M", size: "3.1 GB", age: "17+", screenshots: [.black, .gray, .red], description: "Multiplayer action and battle royale."),
            KsignCloneAppItem(name: "Brawl Stars", category: "Action", iconColor: .orange, iconSymbol: "star.fill", rating: 4.7, reviews: "2M", size: "1.2 GB", age: "9+", screenshots: [.orange, .yellow, .purple], description: "Fast-paced multiplayer battles."),
            KsignCloneAppItem(name: "Roblox", category: "Adventure", iconColor: .gray, iconSymbol: "cube.fill", rating: 4.5, reviews: "5M", size: "300 MB", age: "12+", screenshots: [.gray, .blue, .green], description: "Play, create, and explore experiences."),
            KsignCloneAppItem(name: "Free Fire", category: "Action", iconColor: .red, iconSymbol: "flame.fill", rating: 4.3, reviews: "1.5M", size: "1.1 GB", age: "17+", screenshots: [.red, .orange, .black], description: "Battle royale survival action."),
            KsignCloneAppItem(name: "Among Us!", category: "Party", iconColor: .red, iconSymbol: "person.fill", rating: 4.1, reviews: "900K", size: "700 MB", age: "9+", screenshots: [.red, .blue, .purple], description: "Find the impostor with your crew.")
        ]
        
        todayCards = [
            KsignCloneTodayCardItem(category: "WORLD PREMIERE", title: "The Future of\nMobile Gaming", subtitle: "Experience console quality.", imageColor: .indigo, overlayPosition: .bottomLeading),
            KsignCloneTodayCardItem(category: "APP OF THE DAY", title: "Focus & Flow", subtitle: "Get more done.", imageColor: .orange, overlayPosition: .bottomLeading),
            KsignCloneTodayCardItem(category: "THE BASICS", title: "Edit Photos\nLike a Pro", subtitle: "Top 5 apps for editing.", imageColor: .blue, overlayPosition: .topLeading)
        ]
    }
}

// MARK: - Main Tab View

struct KsignCloneStoreView: View {
    @StateObject private var data = KsignCloneStoreData()
    
    var body: some View {
        TabView {
            KsignCloneTodayView(data: data)
                .tabItem { Label("Today", systemImage: "doc.text.image") }
            
            KsignCloneAppsView(title: "Games", apps: data.games)
                .tabItem { Label("Games", systemImage: "gamecontroller.fill") }
            
            KsignCloneAppsView(title: "Apps", apps: data.featuredApps)
                .tabItem { Label("Apps", systemImage: "square.stack.3d.up.fill") }
            
            Text("Arcade")
                .tabItem { Label("Arcade", systemImage: "arcade.stick") }
            
            KsignCloneSearchView(data: data)
                .tabItem { Label("Search", systemImage: "magnifyingglass") }
        }
        // Hide Ksign's outer tab bar while this App Store-style screen is active.
        .toolbar(.hidden, for: .tabBar)
    }
}

struct KsignCloneInstalledAppsView: View {
    @StateObject private var store = KsignInstalledAppsStore.shared
    @State private var failedToOpenName: String?

    var body: some View {
        NavigationStack {
            Group {
                if store.apps.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "square.grid.2x2").font(.system(size: 42)).foregroundStyle(.secondary)
                        Text("No Installed Apps Yet").font(.title3.weight(.semibold))
                        Text("Apps installed through Ksign will appear here when installation completes.")
                            .font(.subheadline).foregroundStyle(.secondary).multilineTextAlignment(.center)
                    }
                    .padding(32)
                } else {
                    List {
                        ForEach(store.apps) { app in
                            HStack(spacing: 12) {
                                RoundedRectangle(cornerRadius: 13, style: .continuous)
                                    .fill(Color.blue)
                                    .frame(width: 54, height: 54)
                                    .overlay(Image(systemName: "app.fill").font(.title2).foregroundStyle(.white))
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(app.name).font(.headline).lineLimit(1)
                                    Text(app.bundleID).font(.caption).foregroundStyle(.secondary).lineLimit(1)
                                }
                                Spacer(minLength: 4)
                                Button("Open") { open(app) }
                                    .buttonStyle(.borderedProminent)
                                    .controlSize(.small)
                            }
                            .padding(.vertical, 4)
                            .swipeActions {
                                Button(role: .destructive) { store.remove(bundleID: app.bundleID) } label: {
                                    Label("Remove", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("My Apps")
            .alert("Can't Open App", isPresented: Binding(
                get: { failedToOpenName != nil },
                set: { if !$0 { failedToOpenName = nil } }
            )) {
                Button("OK", role: .cancel) { failedToOpenName = nil }
            } message: {
                Text("\(failedToOpenName ?? "This app") may not support a URL scheme that Ksign can use to launch it. Try opening it from the Home Screen.")
            }
        }
    }

    private func open(_ app: KsignInstalledApp) {
        // A bundle identifier is not automatically a URL scheme, so this is best-effort.
        guard let url = URL(string: "\(app.bundleID)://") else {
            failedToOpenName = app.name
            return
        }
        UIApplication.shared.open(url, options: [:]) { success in
            if !success { failedToOpenName = app.name }
        }
    }
}

// MARK: - 1. Today View

struct KsignCloneTodayView: View {
    @ObservedObject var data: KsignCloneStoreData
    @State private var showAccount = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 30) {
                    // Header
                    HStack(alignment: .bottom) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("THURSDAY, NOVEMBER 20")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(.secondary)
                            Text("Today")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        }
                        Spacer()
                        Button(action: { showAccount.toggle() }) {
                            KsignCloneAccountIcon()
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    // Cards
                    ForEach(data.todayCards) { card in
                        KsignCloneTodayCardView(card: card)
                    }
                }
                .padding(.bottom, 20)
            }
            .toolbar(.hidden)
            .sheet(isPresented: $showAccount) {
                KsignCloneAccountView()
            }
        }
    }
}

struct KsignCloneTodayCardView: View {
    let card: KsignCloneTodayCardItem
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: card.overlayPosition) {
                // Each Today card uses artwork from its own app/game listing.
                KsignCloneAppIcon(
                    name: card.category == "APP OF THE DAY" ? "Notion" : (card.category == "THE BASICS" ? "Adobe Lightroom Photo Editor" : "Genshin Impact"),
                    fallbackColor: card.imageColor,
                    fallbackSymbol: "sparkles",
                    size: UIScreen.main.bounds.width - 40,
                    cornerRadius: 16
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
                LinearGradient(colors: [.black.opacity(0.08), .black.opacity(0.78)], startPoint: .top, endPoint: .bottom)

                // Text Content
                VStack(alignment: .leading, spacing: 6) {
                    Text(card.category)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(.white.opacity(0.8))
                    Text(card.title)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.white)
                    Text(card.subtitle)
                        .font(.system(size: 15))
                        .foregroundStyle(.white.opacity(0.9))
                }
                .padding(20)
            }
        }
        .frame(height: 420)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: .black.opacity(0.15), radius: 15, x: 0, y: 10)
        .padding(.horizontal, 20)
    }
}

// MARK: - 2. Apps / Games View (Shared Layout)

struct KsignCloneAppsView: View {
    let title: String
    let apps: [KsignCloneAppItem]
    @State private var showAccount = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Divider()
                    
                    // Horizontal Carousel (Featured)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            KsignCloneFeaturedAppCard(
                                appName: "Clash of Clans",
                                category: "NEW UPDATE",
                                headline: "Clash of Clans",
                                subtitle: "Major Town Hall update.",
                                tagline: "Build your village. Lead your clan."
                            )
                            KsignCloneFeaturedAppCard(
                                appName: "Genshin Impact",
                                category: "EXPLORE NOW",
                                headline: "Genshin Impact",
                                subtitle: "A vast world awaits.",
                                tagline: "Step into the world of Teyvat."
                            )
                            KsignCloneFeaturedAppCard(
                                appName: "Minecraft",
                                category: "PLAYER FAVORITE",
                                headline: "Minecraft",
                                subtitle: "Create your own adventure.",
                                tagline: "Build. Explore. Survive."
                            )
                            KsignCloneFeaturedAppCard(
                                appName: "PUBG MOBILE",
                                category: "BATTLE ROYALE",
                                headline: "PUBG MOBILE",
                                subtitle: "Drop in. Gear up. Survive.",
                                tagline: "Be the last one standing."
                            )
                            KsignCloneFeaturedAppCard(
                                appName: "Call of Duty: Mobile",
                                category: "ACTION SPOTLIGHT",
                                headline: "Call of Duty: Mobile",
                                subtitle: "Jump into multiplayer action.",
                                tagline: "Your next match starts here."
                            )
                            KsignCloneFeaturedAppCard(
                                appName: "Brawl Stars",
                                category: "QUICK MATCHES",
                                headline: "Brawl Stars",
                                subtitle: "Fast matches with friends.",
                                tagline: "Team up and battle."
                            )
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    Divider()
                        .padding(.horizontal, 20)
                    
                    // Sections
                    KsignCloneAppSectionView(title: "Must-Have Apps", apps: apps)
                    KsignCloneAppSectionView(title: "Now Trending", apps: apps.reversed())
                    KsignCloneAppSectionView(title: "Top Paid", apps: apps.shuffled())
                }
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showAccount.toggle() }) {
                        KsignCloneAccountIcon()
                    }
                }
            }
            .sheet(isPresented: $showAccount) {
                KsignCloneAccountView()
            }
        }
    }
}

struct KsignCloneAppSectionView: View {
    let title: String
    let apps: [KsignCloneAppItem]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                Button("See All") {}
                    .font(.body)
                    .foregroundStyle(.blue)
            }
            .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    // Create grid-like columns of 3 items per slide
                    let chunks = apps.ksignCloneChunked(into: 3)
                    ForEach(0..<chunks.count, id: \.self) { index in
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(chunks[index]) { app in
                                NavigationLink(destination: KsignCloneAppDetailView(app: app)) {
                                    KsignCloneSmallAppRow(app: app)
                                }
                                .buttonStyle(.plain)
                                
                                if app.id != chunks[index].last?.id {
                                    Divider().padding(.leading, 70)
                                }
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width - 40)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

// Downloads artwork once, then stores both the resolved artwork URL and image bytes
// in the app's persistent Caches directory so later launches can show it offline.
struct KsignCloneAppIcon: View {
    let name: String
    let fallbackColor: Color
    let fallbackSymbol: String
    let size: CGFloat
    let cornerRadius: CGFloat

    @State private var artwork: UIImage?
    @State private var isLoading = false

    private struct SearchResponse: Decodable {
        let results: [AppResult]
    }

    private struct AppResult: Decodable {
        let trackName: String?
        let artworkUrl512: URL?
        let artworkUrl100: URL?
    }

    var body: some View {
        Group {
            if let artwork {
                Image(uiImage: artwork)
                    .resizable()
                    .scaledToFill()
            } else {
                fallbackIcon
                    .overlay {
                        if isLoading { ProgressView().tint(.white) }
                    }
            }
        }
        .frame(width: size, height: size)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .task(id: name) { await loadArtwork() }
    }

    private var fallbackIcon: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(fallbackColor)
            .overlay(Image(systemName: fallbackSymbol).font(.system(size: size * 0.42)).foregroundStyle(.white))
    }

    private var cacheDirectory: URL {
        let base = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let directory = base.appendingPathComponent("KsignAppStoreArtwork", isDirectory: true)
        try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        return directory
    }

    private var cacheKey: String {
        // Stable, filename-safe key for each app name.
        name.lowercased().unicodeScalars.map { String($0.value, radix: 16) }.joined(separator: "-")
    }

    private var imageFile: URL { cacheDirectory.appendingPathComponent(cacheKey + ".img") }
    private var artworkURLKey: String { "KsignAppStoreArtworkURL_" + cacheKey }

    @MainActor
    private func loadArtwork() async {
        // Fast path: display bytes already saved on this device; no network needed.
        if let data = try? Data(contentsOf: imageFile), let image = UIImage(data: data) {
            artwork = image
            return
        }
        isLoading = true
        defer { isLoading = false }

        do {
            var resolvedURL = UserDefaults.standard.string(forKey: artworkURLKey).flatMap(URL.init(string:))
            if resolvedURL == nil {
                var components = URLComponents(string: "https://itunes.apple.com/search")
                components?.queryItems = [
                    URLQueryItem(name: "term", value: name),
                    URLQueryItem(name: "entity", value: "software"),
                    URLQueryItem(name: "limit", value: "5"),
                    URLQueryItem(name: "country", value: "us")
                ]
                guard let searchURL = components?.url else { return }
                var request = URLRequest(url: searchURL)
                request.cachePolicy = .returnCacheDataElseLoad
                let (data, _) = try await URLSession.shared.data(for: request)
                let response = try JSONDecoder().decode(SearchResponse.self, from: data)
                let exactMatch = response.results.first {
                    $0.trackName?.localizedCaseInsensitiveCompare(name) == .orderedSame
                }
                resolvedURL = exactMatch?.artworkUrl512 ?? exactMatch?.artworkUrl100
                    ?? response.results.first?.artworkUrl512 ?? response.results.first?.artworkUrl100
                if let resolvedURL {
                    UserDefaults.standard.set(resolvedURL.absoluteString, forKey: artworkURLKey)
                }
            }

            guard let resolvedURL else { return }
            var imageRequest = URLRequest(url: resolvedURL)
            imageRequest.cachePolicy = .returnCacheDataElseLoad
            let (imageData, _) = try await URLSession.shared.data(for: imageRequest)
            guard let downloadedImage = UIImage(data: imageData) else { return }
            // Persist image data so it remains available after relaunch and offline.
            try? imageData.write(to: imageFile, options: .atomic)
            artwork = downloadedImage
        } catch {
            // Keep the fallback icon; a later launch can retry if no image was cached.
        }
    }
}

struct KsignCloneSmallAppRow: View {
    let app: KsignCloneAppItem
    
    var body: some View {
        HStack(spacing: 12) {
            KsignCloneAppIcon(name: app.name, fallbackColor: app.iconColor, fallbackSymbol: app.iconSymbol, size: 60, cornerRadius: 12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(app.name)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(.primary)
                Text(app.category)
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
            }
            
            Spacer(minLength: 4)

            if !app.name.localizedCaseInsensitiveContains("PUBG MOBILE") {
                KsignCloneGetButton()
            }
        }
        .padding(.vertical, 8)
    }
}

struct KsignCloneFeaturedAppCard: View {
    let appName: String
    let category: String
    let headline: String
    let subtitle: String
    let tagline: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(category)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.blue)

            Text(headline)
                .font(.title2)
                .fontWeight(.medium)

            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            ZStack(alignment: .bottomLeading) {
                KsignCloneAppIcon(
                    name: appName,
                    fallbackColor: .teal,
                    fallbackSymbol: "gamecontroller.fill",
                    size: UIScreen.main.bounds.width - 40,
                    cornerRadius: 12
                )
                .frame(width: UIScreen.main.bounds.width - 40, height: 220)
                .clipped()
                LinearGradient(colors: [.clear, .black.opacity(0.78)], startPoint: .center, endPoint: .bottom)
                VStack(alignment: .leading, spacing: 4) {
                    Text(appName.uppercased()).font(.caption.weight(.bold))
                    Text(tagline).font(.headline)
                }
                .foregroundStyle(.white)
                .padding(16)
            }
            .frame(width: UIScreen.main.bounds.width - 40, height: 220)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    }
}

// Loads a real App Store screenshot for the hero banner and persists it on-device.
// Uses the app icon only as a fallback if screenshots are unavailable.
struct KsignCloneAppBanner: View {
    let name: String
    let fallbackColor: Color
    let fallbackSymbol: String
    let width: CGFloat
    let height: CGFloat
    @State private var image: UIImage?

    private struct SearchResponse: Decodable { let results: [AppResult] }
    private struct AppResult: Decodable {
        let trackName: String?
        let screenshotUrls: [URL]?
        let ipadScreenshotUrls: [URL]?
    }

    private var cacheDirectory: URL {
        let base = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let dir = base.appendingPathComponent("KsignAppStoreArtwork", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir
    }
    private var cacheKey: String { "banner-v2-" + name.lowercased().unicodeScalars.map { String($0.value, radix: 16) }.joined(separator: "-") }

    // Bundled PUBG MOBILE yellow promotional banner supplied for this build.
    // Kept in the Swift source so no Xcode asset-catalog/project-file edits are required.
    private static let pubgBannerBase64 = [
        "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"
    ].joined()
    private var cacheFile: URL { cacheDirectory.appendingPathComponent(cacheKey + ".img") }

    var body: some View {
        Group {
            if let image {
                Image(uiImage: image).resizable().scaledToFill()
            } else {
                ZStack {
                    Rectangle().fill(fallbackColor)
                    Image(systemName: fallbackSymbol).font(.system(size: 64)).foregroundStyle(.white.opacity(0.85))
                }
            }
        }
        .frame(width: width, height: height)
        .clipped()
        .task(id: name) { await loadBanner() }
    }

    @MainActor private func loadBanner() async {
        // For PUBG MOBILE, always prefer the supplied yellow promo image over any
        // App Store event screenshot. Save it in the app cache for subsequent visits.
        if name.localizedCaseInsensitiveContains("PUBG MOBILE"),
           let bannerData = Data(base64Encoded: Self.pubgBannerBase64),
           let bundledBanner = UIImage(data: bannerData) {
            if !FileManager.default.fileExists(atPath: cacheFile.path) {
                try? bannerData.write(to: cacheFile, options: .atomic)
            }
            image = bundledBanner
            return
        }
        if let data = try? Data(contentsOf: cacheFile), let cached = UIImage(data: data) {
            image = cached
            return
        }
        do {
            var parts = URLComponents(string: "https://itunes.apple.com/search")
            parts?.queryItems = [URLQueryItem(name: "term", value: name), URLQueryItem(name: "entity", value: "software"), URLQueryItem(name: "limit", value: "8"), URLQueryItem(name: "country", value: "us")]
            guard let url = parts?.url else { return }
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(SearchResponse.self, from: data)
            let result = response.results.first { $0.trackName?.localizedCaseInsensitiveCompare(name) == .orderedSame } ?? response.results.first
            // Prefer iPad screenshots where available; otherwise use the app's first App Store screenshot.
            guard let screenshot = result?.ipadScreenshotUrls?.first ?? result?.screenshotUrls?.first else { return }
            let (imageData, _) = try await URLSession.shared.data(from: screenshot)
            guard let downloaded = UIImage(data: imageData) else { return }
            try? imageData.write(to: cacheFile, options: .atomic)
            image = downloaded
        } catch { /* Leave fallback visible; retry on a later visit. */ }
    }
}

// MARK: - 3. App Detail View (Product Page)

struct KsignCloneAppDetailView: View {
    let app: KsignCloneAppItem

    private var isPUBG: Bool { app.name.localizedCaseInsensitiveContains("PUBG MOBILE") }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Wide hero artwork, similar to the App Store product page.
                ZStack(alignment: .bottomLeading) {
                    KsignCloneAppBanner(name: app.name,
                                        fallbackColor: app.iconColor,
                                        fallbackSymbol: app.iconSymbol,
                                        width: UIScreen.main.bounds.width,
                                        height: 310)
                    LinearGradient(colors: [.clear, .black.opacity(0.18)], startPoint: .center, endPoint: .bottom)
                    if isPUBG {
                        Text("PUBG MOBILE")
                            .font(.system(size: 24, weight: .black, design: .rounded))
                            .foregroundStyle(.white)
                            .shadow(color: .black.opacity(0.7), radius: 5)
                            .padding(20)
                    }
                }
                .frame(height: 310)
                .clipped()

                HStack(spacing: 14) {
                    KsignCloneAppIcon(name: app.name, fallbackColor: app.iconColor,
                                      fallbackSymbol: app.iconSymbol, size: 96, cornerRadius: 21)
                    VStack(alignment: .leading, spacing: 5) {
                        Text(app.name).font(.system(size: 22, weight: .semibold)).lineLimit(2)
                        Text(isPUBG ? "Tencent Mobile International Limited" : app.category)
                            .font(.system(size: 14)).foregroundStyle(.secondary).lineLimit(2)
                        HStack {
                            if isPUBG {
                                KsignCloneOpenButton { KsignCloneLaunchApp.openPUBG() }
                            } else {
                                KsignCloneGetButton(width: 76)
                            }
                            Spacer()
                        }.padding(.top, 4)
                    }
                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 20).padding(.vertical, 18)

                Divider().padding(.horizontal, 20)

                HStack(spacing: 0) {
                    VStack(spacing: 5) {
                        Text(isPUBG ? "4.3" : String(app.rating)).font(.system(size: 23, weight: .bold)).foregroundStyle(.secondary)
                        Text("★★★★★").font(.system(size: 12)).foregroundStyle(.secondary)
                        Text(isPUBG ? "1.6M RATINGS" : "\(app.reviews) RATINGS").font(.system(size: 10, weight: .semibold)).foregroundStyle(.secondary).lineLimit(1)
                    }.frame(maxWidth: .infinity)
                    Divider().frame(height: 62)
                    VStack(spacing: 5) {
                        Text(isPUBG ? "13+" : app.age).font(.system(size: 23, weight: .bold)).foregroundStyle(.secondary)
                        Text("Years").font(.system(size: 12)).foregroundStyle(.secondary)
                        Text("AGE RATING").font(.system(size: 10, weight: .semibold)).foregroundStyle(.secondary)
                    }.frame(maxWidth: .infinity)
                    Divider().frame(height: 62)
                    VStack(spacing: 5) {
                        Text(isPUBG ? "#12" : "#1").font(.system(size: 23, weight: .bold)).foregroundStyle(.secondary)
                        Text(app.category).font(.system(size: 12)).foregroundStyle(.secondary).lineLimit(1)
                        Text("CHART").font(.system(size: 10, weight: .semibold)).foregroundStyle(.secondary)
                    }.frame(maxWidth: .infinity)
                }
                .padding(.vertical, 16).padding(.horizontal, 10)

                Divider().padding(.horizontal, 20)

                VStack(alignment: .leading, spacing: 10) {
                    Text("What's New").font(.title3.bold())
                    HStack { Text(isPUBG ? "Version 3.9.0" : "Version 4.2.1").foregroundStyle(.secondary); Spacer(); Text("Recently Updated").foregroundStyle(.secondary) }.font(.subheadline)
                    Text(isPUBG ? "New content, events and gameplay improvements. Update to experience the latest features." : "Bug fixes and performance improvements. Enjoy the latest update!")
                        .font(.body)
                }.padding(20)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Preview").font(.title3.bold()).padding(.horizontal, 20)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(Array(app.screenshots.enumerated()), id: \.offset) { index, _ in
                                ZStack(alignment: .bottomLeading) {
                                    KsignCloneAppBanner(name: app.name,
                                                        fallbackColor: app.iconColor,
                                                        fallbackSymbol: app.iconSymbol,
                                                        width: 220, height: 390)
                                    LinearGradient(colors: [.clear, .black.opacity(0.72)], startPoint: .center, endPoint: .bottom)
                                    Text(isPUBG ? ["BATTLE ROYALE", "TEAM UP", "SURVIVE"][index % 3] : app.name.uppercased())
                                        .font(.headline.bold())
                                        .foregroundStyle(.white)
                                        .padding(16)
                                }
                                .frame(width: 220, height: 390)
                                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                            }
                        }.padding(.horizontal, 20)
                    }
                }.padding(.top, 8)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Description").font(.title3.bold())
                    Text(app.description)
                    Text("Developer: \(isPUBG ? "Tencent Mobile International Limited" : app.category)").font(.subheadline).foregroundStyle(.secondary)
                    Text("Size: \(app.size)").font(.caption).foregroundStyle(.secondary).padding(.top, 4)
                }.padding(20).padding(.bottom, 35)
            }
        }
        .background(Color.black.ignoresSafeArea())
        .preferredColorScheme(.dark)
        // Keep the hero below the status bar and reserve space for the custom tab bar.
        .safeAreaInset(edge: .bottom, spacing: 0) { Color.clear.frame(height: 84) }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct KsignCloneStatItem: View {
    let top: String
    let bottom: String
    let caption: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(top)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundStyle(.gray)
            Text(bottom)
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(.gray)
            Text(caption)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - 4. Search View

struct KsignCloneSearchView: View {
    @ObservedObject var data: KsignCloneStoreData
    @State private var searchText = ""
    
    var filteredApps: [KsignCloneAppItem] {
        if searchText.isEmpty { return [] }
        return data.featuredApps.filter { $0.name.localizedCaseInsensitiveContains(searchText) } +
               data.games.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        NavigationStack {
            List {
                if searchText.isEmpty {
                    Section(header: Text("Discover")) {
                        ForEach(["RPG Games", "Video Editors", "Fitness", "Wallpaper"], id: \.self) { item in
                            Button(action: { searchText = item }) {
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                    Text(item)
                                }
                                .foregroundStyle(.blue)
                            }
                        }
                    }
                    
                    Section(header: Text("Suggested")) {
                        ForEach(data.games.prefix(2)) { app in
                            NavigationLink(destination: KsignCloneAppDetailView(app: app)) {
                                KsignCloneSmallAppRow(app: app)
                            }
                        }
                    }
                } else {
                    ForEach(filteredApps) { app in
                        if app.name.localizedCaseInsensitiveContains("PUBG MOBILE") {
                            // Keep navigation and launching as separate hit targets: tapping the icon/title
                            // opens the product page; only the blue OPEN button launches the installed game.
                            HStack(spacing: 12) {
                                NavigationLink(destination: KsignCloneAppDetailView(app: app)) {
                                    HStack(spacing: 12) {
                                        KsignCloneAppIcon(name: app.name, fallbackColor: app.iconColor, fallbackSymbol: app.iconSymbol, size: 60, cornerRadius: 12)
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(app.name)
                                                .font(.system(size: 16, weight: .medium))
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.8)
                                                .foregroundStyle(.primary)
                                            Text(app.category)
                                                .font(.system(size: 13))
                                                .lineLimit(1)
                                                .truncationMode(.tail)
                                                .foregroundStyle(.secondary)
                                            HStack(spacing: 4) {
                                                Text("★★★★☆")
                                                    .font(.system(size: 12, weight: .medium))
                                                    .foregroundStyle(.secondary)
                                                    .fixedSize(horizontal: true, vertical: false)
                                                Text("1.6M")
                                                    .font(.system(size: 12))
                                                    .foregroundStyle(.secondary)
                                                    .fixedSize(horizontal: true, vertical: false)
                                            }
                                        }
                                        .frame(minWidth: 150, maxWidth: .infinity, alignment: .leading)
                                        .layoutPriority(2)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .contentShape(Rectangle())
                                }
                                .buttonStyle(.plain)

                                Spacer(minLength: 4)
                                Button { KsignCloneLaunchApp.openPUBG() } label: {
                                    Text("Open")
                                        .font(.system(size: 17, weight: .semibold))
                                        .foregroundStyle(Color(red: 0.10, green: 0.58, blue: 1.0))
                                        .frame(width: 112, height: 48)
                                        .background(Color(red: 0.12, green: 0.12, blue: 0.13), in: Capsule())
                                }
                                .buttonStyle(.plain)
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 4)
                            if app.name.localizedCaseInsensitiveContains("PUBG MOBILE") {
                                HStack(spacing: 10) {
                                    Text("#12 in Action")
                                    Text("|").foregroundStyle(.tertiary)
                                    Text("Battle Royale")
                                    Text("Multiplayer")
                                }
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                                .minimumScaleFactor(0.75)
                                .padding(.top, 2)
                                .padding(.bottom, 8)
                            }
                        } else {
                            NavigationLink(destination: KsignCloneAppDetailView(app: app)) {
                                KsignCloneSmallAppRow(app: app)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Search")
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        }
    }
}

// Launch helper for the installed PUBG MOBILE app. The app must register this URL scheme.
enum KsignCloneLaunchApp {
    static func openPUBG() {
        guard let url = URL(string: "pubgm://") else { return }
        UIApplication.shared.open(url, options: [:])
    }
}

// MARK: - 5. Shared Components

struct KsignCloneOpenButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("OPEN")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(.white)
                .padding(.horizontal, 18)
                .frame(height: 30)
                .background(Color.blue, in: Capsule())
        }
        .buttonStyle(.plain)
        .fixedSize()
    }
}

struct KsignCloneGetButton: View {
    var width: CGFloat = 72
    @State private var state: DownloadState = .get
    
    enum DownloadState {
        case get, loading, open
    }
    
    var body: some View {
        Button(action: {
            if state == .get {
                withAnimation { state = .loading }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation { state = .open }
                }
            }
        }) {
            ZStack {
                Capsule()
                    .fill(state == .get ? Color(uiColor: .secondarySystemBackground) : (state == .open ? .blue : .clear))
                
                if state == .get {
                    Text("GET")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.blue)
                } else if state == .loading {
                    ProgressView()
                } else {
                    Text("OPEN")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(.white)
                }
            }
            .frame(width: width, height: 28)
        }
        .buttonStyle(.plain)
    }
}

struct KsignCloneAccountIcon: View {
    var body: some View {
        Circle()
            .fill(Color.blue.gradient)
            .frame(width: 32, height: 32)
            .overlay(Text("JA").font(.caption).fontWeight(.bold).foregroundStyle(.white))
    }
}

struct KsignCloneAccountView: View {
    @Environment(\.dismiss) var dismiss
    @State private var recommendationTapCount = 0
    @State private var showPersonalizedMenu = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(spacing: 12) {
                        Circle().fill(.blue).frame(width: 50, height: 50).overlay(Text("JA").foregroundStyle(.white))
                        VStack(alignment: .leading) {
                            Text("John Appleseed").font(.headline)
                            Text("john.appleseed@icloud.com").font(.caption).foregroundStyle(.secondary)
                        }
                    }
                }
                
                Section("Account") {
                    NavigationLink("Purchased") {}
                    NavigationLink {
                        KsignCloneInstalledAppsView()
                    } label: {
                        Label("My Apps", systemImage: "square.grid.2x2.fill")
                    }
                    NavigationLink("Subscriptions") {}
                    NavigationLink("Notifications") {}
                }

                Section {
                    Button {
                        recommendationTapCount += 1
                        if recommendationTapCount >= 3 {
                            showPersonalizedMenu.toggle()
                            recommendationTapCount = 0
                        }
                    } label: {
                        HStack {
                            Text("Personalized Recommendations")
                                .foregroundStyle(.primary)
                            Spacer()
                            if showPersonalizedMenu {
                                Image(systemName: "chevron.down").foregroundStyle(.secondary)
                            }
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    if showPersonalizedMenu {
                        NavigationLink { FilesView() } label: { Label("Files", systemImage: "folder.fill") }
                        NavigationLink { LibraryView() } label: { Label("Library", systemImage: "square.grid.2x2") }
                        NavigationLink { DownloaderView() } label: { Label("Downloads", systemImage: "square.and.arrow.down.fill") }
                        NavigationLink { SettingsView() } label: { Label("Settings", systemImage: "gearshape.2") }
                    }
                }

                Section {
                    Button("Sign Out") { dismiss() }.foregroundStyle(.blue)
                }
            }
            .navigationTitle("Account")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }.fontWeight(.bold)
                }
            }
        }
    }
}

// Helper to chunk arrays for the grid layout
extension Array {
    func ksignCloneChunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

#Preview {
    KsignCloneStoreView()
}
