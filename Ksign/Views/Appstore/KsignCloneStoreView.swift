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
            KsignCloneAppItem(name: "PUBG MOBILE", category: "Action", iconColor: .orange, iconSymbol: "scope", rating: 4.3, reviews: "2.8M", size: "3.8 GB", age: "12+", screenshots: [.orange, .black, .gray], description: "Survive and compete in battle royale matches.")
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
            .fill(fallbackColor.gradient)
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
            
            Spacer()
            
            KsignCloneGetButton()
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

// MARK: - 3. App Detail View (Product Page)

struct KsignCloneAppDetailView: View {
    let app: KsignCloneAppItem
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                HStack(spacing: 16) {
                    KsignCloneAppIcon(name: app.name, fallbackColor: app.iconColor, fallbackSymbol: app.iconSymbol, size: 110, cornerRadius: 22)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text(app.name)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text(app.category)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                        
                        HStack {
                            if app.name.localizedCaseInsensitiveContains("PUBG MOBILE") {
                                Button("OPEN") { KsignCloneLaunchApp.openPUBG() }
                                    .font(.system(size: 14, weight: .bold))
                                    .padding(.horizontal, 18)
                                    .padding(.vertical, 7)
                                    .background(Color.blue.opacity(0.12), in: Capsule())
                            } else {
                                KsignCloneGetButton(width: 75)
                            }
                            Spacer()
                            Image(systemName: "square.and.arrow.up")
                                .foregroundStyle(.blue)
                        }
                    }
                    .frame(height: 110)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                Divider().padding(.horizontal, 20)
                
                // Stats Row
                HStack(alignment: .top) {
                    KsignCloneStatItem(top: "\(app.rating)", bottom: "★★★★★", caption: "\(app.reviews) Ratings")
                    Divider().frame(height: 30)
                    KsignCloneStatItem(top: "#1", bottom: "Chart", caption: app.category)
                    Divider().frame(height: 30)
                    KsignCloneStatItem(top: app.age, bottom: "Years", caption: "Age")
                }
                .padding(.horizontal, 20)
                
                // What's New
                VStack(alignment: .leading, spacing: 10) {
                    Text("What's New")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    HStack {
                        Text("Version 4.2.1")
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text("2d ago")
                            .foregroundStyle(.secondary)
                    }
                    .font(.subheadline)
                    
                    Text("Bug fixes and performance improvements. Enjoy the latest update!")
                        .font(.body)
                        .lineLimit(3)
                }
                .padding(.horizontal, 20)
                
                // Screenshots
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(app.screenshots, id: \.self) { color in
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .fill(color.opacity(0.3))
                                .frame(width: 240, height: 440)
                                .overlay(
                                    VStack {
                                        Spacer()
                                        Image(systemName: app.iconSymbol)
                                            .font(.largeTitle)
                                            .foregroundStyle(color)
                                        Spacer()
                                    }
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                )
                        }
                    }
                    .padding(.horizontal, 20)
                }
                
                // Description
                VStack(alignment: .leading, spacing: 10) {
                    Text(app.description)
                    Text("Size: \(app.size)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.top, 10)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
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
                        HStack(spacing: 10) {
                            NavigationLink(destination: KsignCloneAppDetailView(app: app)) {
                                KsignCloneSmallAppRow(app: app)
                            }
                            .buttonStyle(.plain)
                            if app.name.localizedCaseInsensitiveContains("PUBG MOBILE") {
                                Button("OPEN") { KsignCloneLaunchApp.openPUBG() }
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundStyle(.blue)
                                    .padding(.horizontal, 15)
                                    .padding(.vertical, 7)
                                    .background(Color.blue.opacity(0.12), in: Capsule())
                            }
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
