//
//  ContentView.swift
//  MyPhotos-docs
//
//  Created by Josblais on 2026-02-27.
//

import SwiftUI

// MARK: - Documentation Sections
enum DocSection: String, CaseIterable, Identifiable {
    case overview = "Vue d'ensemble"
    case features = "Fonctionnalites"
    case architecture = "Architecture"
    case components = "Composants"
    case installation = "Installation"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .overview: return "doc.text"
        case .features: return "star.fill"
        case .architecture: return "building.columns"
        case .components: return "square.stack.3d.up"
        case .installation: return "arrow.down.circle"
        }
    }
}

// MARK: - Feature Documentation
enum FeatureDoc: String, CaseIterable, Identifiable {
    case copySharedAlbums = "Copier les albums partages"
    case findDuplicates = "Rechercher les doublons"
    case deleteDuplicates = "Eliminer les doublons"
    case syncListener = "Synchronisation automatique"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .copySharedAlbums: return "square.and.arrow.down.on.square"
        case .findDuplicates: return "doc.on.doc"
        case .deleteDuplicates: return "trash.slash"
        case .syncListener: return "arrow.triangle.2.circlepath"
        }
    }
    
    var color: Color {
        switch self {
        case .copySharedAlbums: return .blue
        case .findDuplicates: return .orange
        case .deleteDuplicates: return .red
        case .syncListener: return .green
        }
    }
}

// MARK: - Component Documentation
enum ComponentDoc: String, CaseIterable, Identifiable {
    case photosManager = "PhotosManager"
    case sharedAlbum = "SharedAlbum"
    case homeView = "HomeView"
    case progressView = "ProgressView"
    
    var id: String { rawValue }
}

// MARK: - Main Content View
struct ContentView: View {
    @State private var selectedSection: DocSection? = .overview
    @State private var selectedFeature: FeatureDoc?
    @State private var selectedComponent: ComponentDoc?
    
    var body: some View {
        NavigationSplitView {
            sidebar
        } detail: {
            detailView
        }
        .frame(minWidth: 900, minHeight: 600)
    }
    
    // MARK: - Sidebar
    @ViewBuilder
    private var sidebar: some View {
        List(selection: $selectedSection) {
            Section("Documentation") {
                ForEach(DocSection.allCases) { section in
                    Label(section.rawValue, systemImage: section.icon)
                        .tag(section)
                }
            }
            
            Section("Fonctionnalites") {
                ForEach(FeatureDoc.allCases) { feature in
                    Button {
                        selectedSection = .features
                        selectedFeature = feature
                    } label: {
                        Label(feature.rawValue, systemImage: feature.icon)
                            .foregroundColor(feature.color)
                    }
                    .buttonStyle(.plain)
                }
            }
            
            Section("Composants") {
                ForEach(ComponentDoc.allCases) { component in
                    Button {
                        selectedSection = .components
                        selectedComponent = component
                    } label: {
                        Label(component.rawValue, systemImage: "cube")
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .listStyle(.sidebar)
        .navigationTitle("MyPhotos")
    }
    
    // MARK: - Detail View
    @ViewBuilder
    private var detailView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                switch selectedSection {
                case .overview:
                    OverviewDocView()
                case .features:
                    if let feature = selectedFeature {
                        FeatureDetailView(feature: feature)
                    } else {
                        FeaturesOverviewView()
                    }
                case .architecture:
                    ArchitectureDocView()
                case .components:
                    if let component = selectedComponent {
                        ComponentDetailView(component: component)
                    } else {
                        ComponentsOverviewView()
                    }
                case .installation:
                    InstallationDocView()
                case .none:
                    OverviewDocView()
                }
            }
            .padding(32)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color(nsColor: .textBackgroundColor))
    }
}

// MARK: - Overview Documentation View
struct OverviewDocView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Header
            HStack(spacing: 16) {
                Image(systemName: "photo.stack.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("MyPhotos")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Application de gestion d'albums photos iCloud")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
            }
            
            Divider()
            
            // Description
            DocSectionView(title: "Description", icon: "info.circle") {
                Text("""
                    MyPhotos est une application macOS qui permet de gerer vos albums photos partages iCloud. \
                    Elle offre des fonctionnalites avancees pour copier, synchroniser et gerer les doublons \
                    dans votre bibliotheque Photos.
                    """)
                    .font(.body)
            }
            
            // Key Features
            DocSectionView(title: "Fonctionnalites principales", icon: "star.fill") {
                VStack(alignment: .leading, spacing: 12) {
                    FeatureRow(
                        icon: "square.and.arrow.down.on.square",
                        title: "Copie d'albums partages",
                        description: "Copiez les photos et videos des albums partages iCloud vers votre bibliotheque locale",
                        color: .blue
                    )
                    
                    FeatureRow(
                        icon: "doc.on.doc",
                        title: "Detection de doublons",
                        description: "Analysez votre bibliotheque pour trouver les photos en double avec un algorithme de hash perceptuel",
                        color: .orange
                    )
                    
                    FeatureRow(
                        icon: "trash.slash",
                        title: "Suppression intelligente",
                        description: "Fusionnez les doublons en gardant une seule copie dans tous les albums concernes",
                        color: .red
                    )
                    
                    FeatureRow(
                        icon: "arrow.triangle.2.circlepath",
                        title: "Synchronisation automatique",
                        description: "Surveillez les albums partages et copiez automatiquement les nouvelles photos",
                        color: .green
                    )
                }
            }
            
            // Technologies
            DocSectionView(title: "Technologies utilisees", icon: "cpu") {
                HStack(spacing: 16) {
                    TechBadge(name: "SwiftUI", color: .blue)
                    TechBadge(name: "PhotoKit", color: .purple)
                    TechBadge(name: "Swift Concurrency", color: .orange)
                    TechBadge(name: "macOS 13+", color: .green)
                }
            }
        }
    }
}

// MARK: - Features Overview View
struct FeaturesOverviewView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Fonctionnalites")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("MyPhotos propose quatre fonctionnalites principales pour gerer votre bibliotheque Photos.")
                .font(.body)
                .foregroundColor(.secondary)
            
            Divider()
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                ForEach(FeatureDoc.allCases) { feature in
                    FeatureCard(feature: feature)
                }
            }
        }
    }
}

// MARK: - Feature Detail View
struct FeatureDetailView: View {
    let feature: FeatureDoc
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Header
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(feature.color.opacity(0.15))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: feature.icon)
                        .font(.title)
                        .foregroundColor(feature.color)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(feature.rawValue)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text(featureSubtitle)
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
            }
            
            Divider()
            
            // Content based on feature
            featureContent
        }
    }
    
    private var featureSubtitle: String {
        switch feature {
        case .copySharedAlbums:
            return "Copiez vos albums partages iCloud"
        case .findDuplicates:
            return "Detectez les photos en double"
        case .deleteDuplicates:
            return "Supprimez les doublons intelligemment"
        case .syncListener:
            return "Synchronisation en temps reel"
        }
    }
    
    @ViewBuilder
    private var featureContent: some View {
        switch feature {
        case .copySharedAlbums:
            copySharedAlbumsContent
        case .findDuplicates:
            findDuplicatesContent
        case .deleteDuplicates:
            deleteDuplicatesContent
        case .syncListener:
            syncListenerContent
        }
    }
    
    @ViewBuilder
    private var copySharedAlbumsContent: some View {
        VStack(alignment: .leading, spacing: 20) {
            DocSectionView(title: "Description", icon: "info.circle") {
                Text("""
                    Cette fonctionnalite permet de copier les photos et videos des albums partages iCloud \
                    vers votre bibliotheque Photos locale. Les albums partages sont des albums que vous \
                    partagez avec d'autres utilisateurs iCloud ou qui ont ete partages avec vous.
                    """)
            }
            
            DocSectionView(title: "Modes de copie", icon: "slider.horizontal.3") {
                VStack(alignment: .leading, spacing: 12) {
                    ModeRow(
                        title: "Sans interruption",
                        description: "Copie tous les albums selectionnes sans pause",
                        icon: "bolt.fill"
                    )
                    
                    ModeRow(
                        title: "Avec confirmation",
                        description: "Demande confirmation avant chaque album",
                        icon: "hand.raised.fill"
                    )
                }
            }
            
            DocSectionView(title: "Detection des doublons", icon: "doc.on.doc") {
                Text("""
                    Lors de la copie, l'application detecte automatiquement les doublons en utilisant:
                    - La date de creation et les dimensions de l'image
                    - Un algorithme de hash perceptuel (16x16 = 256 bits)
                    - Une tolerance de 5% sur la distance de Hamming
                    """)
            }
            
            CodeBlockView(title: "Extrait de code - Detection de doublons", code: """
                private func isDuplicate(asset: PHAsset) async -> Bool {
                    guard let sourceHash = await calculatePerceptualHash(for: asset) else {
                        return false
                    }
                    
                    // Chercher par cle exacte (date + dimensions)
                    let sourceKey = assetQuickKey(for: asset)
                    if let existingAssets = existingAssetsCache[sourceKey] {
                        for existingAsset in existingAssets {
                            if await compareHashes(sourceHash: sourceHash, 
                                                   existingAsset: existingAsset) {
                                return true
                            }
                        }
                    }
                    return false
                }
                """)
        }
    }
    
    @ViewBuilder
    private var findDuplicatesContent: some View {
        VStack(alignment: .leading, spacing: 20) {
            DocSectionView(title: "Description", icon: "info.circle") {
                Text("""
                    Cette fonctionnalite analyse votre bibliotheque Photos locale pour identifier \
                    les photos en double. Elle utilise un algorithme de hash perceptuel qui peut \
                    detecter les photos similaires meme si elles ont ete compressees ou redimensionnees.
                    """)
            }
            
            DocSectionView(title: "Algorithme de hash perceptuel", icon: "cpu") {
                Text("""
                    Le hash perceptuel fonctionne ainsi:
                    1. Redimensionne l'image en 256x256 pixels
                    2. Echantillonne 16x16 = 256 points
                    3. Convertit en niveaux de gris
                    4. Compare chaque pixel a la moyenne
                    5. Genere un hash binaire de 256 bits
                    
                    Deux images sont considerees identiques si leur distance de Hamming est <= 5%.
                    """)
            }
        }
    }
    
    @ViewBuilder
    private var deleteDuplicatesContent: some View {
        VStack(alignment: .leading, spacing: 20) {
            DocSectionView(title: "Description", icon: "info.circle") {
                Text("""
                    Cette fonctionnalite permet de fusionner les groupes de doublons detectes. \
                    Elle garde une seule copie de chaque photo et l'ajoute a tous les albums \
                    ou se trouvaient les doublons, puis supprime les copies en trop.
                    """)
            }
            
            DocSectionView(title: "Processus de fusion", icon: "arrow.triangle.merge") {
                VStack(alignment: .leading, spacing: 8) {
                    StepRow(number: 1, text: "Selection de la meilleure copie (avec localisation GPS ou la plus ancienne)")
                    StepRow(number: 2, text: "Identification de tous les albums contenant les doublons")
                    StepRow(number: 3, text: "Ajout de la copie conservee dans tous les albums")
                    StepRow(number: 4, text: "Suppression des doublons")
                }
            }
        }
    }
    
    @ViewBuilder
    private var syncListenerContent: some View {
        VStack(alignment: .leading, spacing: 20) {
            DocSectionView(title: "Description", icon: "info.circle") {
                Text("""
                    Cette fonctionnalite surveille en permanence les albums partages selectionnes \
                    et copie automatiquement les nouvelles photos vers votre bibliotheque locale. \
                    Elle utilise un timer qui verifie les changements toutes les 30 secondes.
                    """)
            }
            
            DocSectionView(title: "Fonctionnement", icon: "gearshape") {
                VStack(alignment: .leading, spacing: 8) {
                    StepRow(number: 1, text: "Selection des albums a surveiller")
                    StepRow(number: 2, text: "Enregistrement du nombre d'elements actuels")
                    StepRow(number: 3, text: "Verification periodique (toutes les 30s)")
                    StepRow(number: 4, text: "Detection et copie automatique des nouveaux elements")
                }
            }
            
            DocSectionView(title: "Journalisation", icon: "doc.text") {
                Text("""
                    Toutes les operations de synchronisation sont journalisees avec horodatage. \
                    Les logs sont visibles dans l'interface et limites aux 100 derniers evenements.
                    """)
            }
        }
    }
}

// MARK: - Architecture Documentation View
struct ArchitectureDocView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Architecture")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Structure et organisation du code de MyPhotos")
                .font(.body)
                .foregroundColor(.secondary)
            
            Divider()
            
            DocSectionView(title: "Pattern MVVM", icon: "square.stack.3d.up") {
                Text("""
                    L'application utilise le pattern MVVM (Model-View-ViewModel) avec:
                    - **Models**: SharedAlbum, AlbumCopyProgress, SyncEventData
                    - **Views**: ContentView, HomeView, CopyProgressView
                    - **ViewModel**: PhotosManager (classe @Observable)
                    """)
            }
            
            DocSectionView(title: "Structure des fichiers", icon: "folder") {
                VStack(alignment: .leading, spacing: 8) {
                    FileRow(name: "MyPhotosApp.swift", description: "Point d'entree de l'application")
                    FileRow(name: "ContentView.swift", description: "Vue principale avec navigation")
                    FileRow(name: "HomeView.swift", description: "Ecran d'accueil avec les fonctionnalites")
                    FileRow(name: "PhotosManager.swift", description: "Logique metier et acces PhotoKit")
                    FileRow(name: "SharedAlbum.swift", description: "Modele pour les albums partages")
                    FileRow(name: "ProgressView.swift", description: "Vue de progression des copies")
                }
            }
            
            DocSectionView(title: "Flux de donnees", icon: "arrow.right.arrow.left") {
                Text("""
                    L'application utilise Swift Concurrency (async/await) pour les operations asynchrones:
                    - Acces a la bibliotheque Photos via PhotoKit
                    - Telechargement des images/videos depuis iCloud
                    - Operations de copie et suppression
                    
                    Le PhotosManager est marque @MainActor pour garantir les mises a jour UI sur le thread principal.
                    """)
            }
            
            CodeBlockView(title: "Exemple - Declaration du PhotosManager", code: """
                @MainActor
                @Observable
                class PhotosManager {
                    var authorizationStatus: PHAuthorizationStatus = .notDetermined
                    var sharedAlbums: [SharedAlbum] = []
                    var isLoading = false
                    var isCopying = false
                    // ...
                }
                """)
        }
    }
}

// MARK: - Components Overview View
struct ComponentsOverviewView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Composants")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Les principaux composants de l'application MyPhotos")
                .font(.body)
                .foregroundColor(.secondary)
            
            Divider()
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                ForEach(ComponentDoc.allCases) { component in
                    ComponentCard(component: component)
                }
            }
        }
    }
}

// MARK: - Component Detail View
struct ComponentDetailView: View {
    let component: ComponentDoc
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text(component.rawValue)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Divider()
            
            componentContent
        }
    }
    
    @ViewBuilder
    private var componentContent: some View {
        switch component {
        case .photosManager:
            photosManagerContent
        case .sharedAlbum:
            sharedAlbumContent
        case .homeView:
            homeViewContent
        case .progressView:
            progressViewContent
        }
    }
    
    @ViewBuilder
    private var photosManagerContent: some View {
        VStack(alignment: .leading, spacing: 20) {
            DocSectionView(title: "Description", icon: "info.circle") {
                Text("""
                    PhotosManager est la classe centrale qui gere toutes les interactions avec \
                    la bibliotheque Photos. Elle est responsable de l'autorisation, du chargement \
                    des albums, de la copie et de la detection des doublons.
                    """)
            }
            
            DocSectionView(title: "Proprietes principales", icon: "list.bullet") {
                VStack(alignment: .leading, spacing: 8) {
                    PropertyRow(name: "authorizationStatus", type: "PHAuthorizationStatus", description: "Statut d'autorisation Photos")
                    PropertyRow(name: "sharedAlbums", type: "[SharedAlbum]", description: "Liste des albums partages")
                    PropertyRow(name: "isCopying", type: "Bool", description: "Indique si une copie est en cours")
                    PropertyRow(name: "copyProgress", type: "Double", description: "Progression globale (0-1)")
                    PropertyRow(name: "isSyncListenerActive", type: "Bool", description: "Statut du listener de sync")
                }
            }
            
            DocSectionView(title: "Methodes principales", icon: "function") {
                VStack(alignment: .leading, spacing: 8) {
                    MethodRow(name: "requestAuthorization()", description: "Demande l'acces a Photos")
                    MethodRow(name: "fetchSharedAlbums()", description: "Charge la liste des albums partages")
                    MethodRow(name: "copyAlbumsToLocal(albums:mode:)", description: "Copie les albums selectionnes")
                    MethodRow(name: "startSyncListener(for:)", description: "Demarre la surveillance automatique")
                    MethodRow(name: "isDuplicate(asset:)", description: "Verifie si un asset est un doublon")
                }
            }
        }
    }
    
    @ViewBuilder
    private var sharedAlbumContent: some View {
        VStack(alignment: .leading, spacing: 20) {
            DocSectionView(title: "Description", icon: "info.circle") {
                Text("""
                    SharedAlbum est une structure qui represente un album partage iCloud. \
                    Elle encapsule un PHAssetCollection et fournit des proprietes pratiques \
                    comme le titre et le nombre d'elements.
                    """)
            }
            
            CodeBlockView(title: "Definition", code: """
                struct SharedAlbum: Identifiable, Hashable {
                    let id: String
                    let title: String
                    let assetCount: Int
                    let collection: PHAssetCollection
                    
                    init(collection: PHAssetCollection) {
                        self.id = collection.localIdentifier
                        self.title = collection.localizedTitle ?? "Sans titre"
                        self.collection = collection
                        
                        let assets = PHAsset.fetchAssets(in: collection, options: nil)
                        self.assetCount = assets.count
                    }
                }
                """)
        }
    }
    
    @ViewBuilder
    private var homeViewContent: some View {
        VStack(alignment: .leading, spacing: 20) {
            DocSectionView(title: "Description", icon: "info.circle") {
                Text("""
                    HomeView est l'ecran d'accueil de l'application. Il affiche les quatre \
                    fonctionnalites principales sous forme de cartes interactives avec \
                    des effets de survol.
                    """)
            }
            
            DocSectionView(title: "Composants", icon: "square.stack.3d.up") {
                VStack(alignment: .leading, spacing: 8) {
                    FileRow(name: "headerSection", description: "En-tete avec logo et titre")
                    FileRow(name: "LazyVGrid", description: "Grille 2 colonnes de cartes")
                    FileRow(name: "FeatureCard", description: "Carte cliquable pour chaque fonctionnalite")
                }
            }
            
            DocSectionView(title: "Enum AppFeature", icon: "list.bullet") {
                Text("""
                    L'enum AppFeature definit les quatre fonctionnalites avec leurs proprietes:
                    - rawValue: Titre affiche
                    - icon: Nom de l'icone SF Symbols
                    - description: Description courte
                    - color: Couleur associee
                    """)
            }
        }
    }
    
    @ViewBuilder
    private var progressViewContent: some View {
        VStack(alignment: .leading, spacing: 20) {
            DocSectionView(title: "Description", icon: "info.circle") {
                Text("""
                    CopyProgressView affiche la progression detaillee lors de la copie d'albums. \
                    Elle montre les statistiques globales, la progression par album et le temps \
                    restant estime.
                    """)
            }
            
            DocSectionView(title: "Sections", icon: "rectangle.split.3x1") {
                VStack(alignment: .leading, spacing: 8) {
                    FileRow(name: "headerSection", description: "Titre, barre de progression globale")
                    FileRow(name: "globalStatsSection", description: "Albums, copies, doublons, echecs, temps")
                    FileRow(name: "confirmationPanel", description: "Panneau de confirmation entre albums")
                    FileRow(name: "albumsProgressList", description: "Liste detaillee par album")
                    FileRow(name: "footerSection", description: "Temps restant estime")
                }
            }
        }
    }
}

// MARK: - Installation Documentation View
struct InstallationDocView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Installation")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Guide d'installation et de configuration de MyPhotos")
                .font(.body)
                .foregroundColor(.secondary)
            
            Divider()
            
            DocSectionView(title: "Prerequis", icon: "checkmark.circle") {
                VStack(alignment: .leading, spacing: 8) {
                    BulletPoint(text: "macOS 13.0 (Ventura) ou superieur")
                    BulletPoint(text: "Xcode 15.0 ou superieur")
                    BulletPoint(text: "Compte iCloud avec Photos active")
                    BulletPoint(text: "Albums partages dans Photos")
                }
            }
            
            DocSectionView(title: "Installation", icon: "arrow.down.circle") {
                VStack(alignment: .leading, spacing: 8) {
                    StepRow(number: 1, text: "Clonez le depot GitHub: git clone https://github.com/[user]/MyPhotos.git")
                    StepRow(number: 2, text: "Ouvrez MyPhotos.xcodeproj dans Xcode")
                    StepRow(number: 3, text: "Selectionnez votre equipe de developpement dans Signing & Capabilities")
                    StepRow(number: 4, text: "Compilez et executez l'application (Cmd + R)")
                }
            }
            
            DocSectionView(title: "Permissions", icon: "lock.shield") {
                Text("""
                    L'application necessite l'acces a votre bibliotheque Photos. \
                    Au premier lancement, une boite de dialogue vous demandera d'autoriser l'acces.
                    
                    Si vous refusez, vous pouvez modifier les permissions dans:
                    Preferences Systeme > Confidentialite et securite > Photos
                    """)
            }
            
            DocSectionView(title: "Configuration Info.plist", icon: "doc.text") {
                CodeBlockView(title: "Cles requises", code: """
                    <key>NSPhotoLibraryUsageDescription</key>
                    <string>MyPhotos a besoin d'acceder a votre bibliotheque 
                    Photos pour copier les albums partages.</string>
                    
                    <key>NSPhotoLibraryAddUsageDescription</key>
                    <string>MyPhotos a besoin d'ajouter des photos a votre 
                    bibliotheque locale.</string>
                    """)
            }
        }
    }
}

// MARK: - Helper Views

struct DocSectionView<Content: View>: View {
    let title: String
    let icon: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.accentColor)
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            
            content
                .padding(.leading, 4)
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .fontWeight(.medium)
                Text(description)
                    .font(.callout)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct FeatureCard: View {
    let feature: FeatureDoc
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                ZStack {
                    Circle()
                        .fill(feature.color.opacity(0.15))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: feature.icon)
                        .foregroundColor(feature.color)
                }
                
                Spacer()
            }
            
            Text(feature.rawValue)
                .font(.headline)
            
            Text(featureDescription)
                .font(.callout)
                .foregroundColor(.secondary)
                .lineLimit(3)
        }
        .padding()
        .background(Color(nsColor: .controlBackgroundColor))
        .cornerRadius(12)
    }
    
    private var featureDescription: String {
        switch feature {
        case .copySharedAlbums:
            return "Copiez les photos et videos des albums partages iCloud vers votre bibliotheque locale"
        case .findDuplicates:
            return "Analysez votre bibliotheque pour trouver les photos en double"
        case .deleteDuplicates:
            return "Fusionnez les doublons en gardant une seule copie"
        case .syncListener:
            return "Surveillez et synchronisez automatiquement les nouveaux elements"
        }
    }
}

struct ComponentCard: View {
    let component: ComponentDoc
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "cube")
                    .foregroundColor(.purple)
                Spacer()
            }
            
            Text(component.rawValue)
                .font(.headline)
            
            Text(componentDescription)
                .font(.callout)
                .foregroundColor(.secondary)
                .lineLimit(3)
        }
        .padding()
        .background(Color(nsColor: .controlBackgroundColor))
        .cornerRadius(12)
    }
    
    private var componentDescription: String {
        switch component {
        case .photosManager:
            return "Classe principale gerant l'acces a Photos et la logique metier"
        case .sharedAlbum:
            return "Modele representant un album partage iCloud"
        case .homeView:
            return "Ecran d'accueil avec les cartes de fonctionnalites"
        case .progressView:
            return "Vue affichant la progression des operations"
        }
    }
}

struct TechBadge: View {
    let name: String
    let color: Color
    
    var body: some View {
        Text(name)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(color.opacity(0.15))
            .foregroundColor(color)
            .cornerRadius(8)
    }
}

struct ModeRow: View {
    let title: String
    let description: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .fontWeight(.medium)
                Text(description)
                    .font(.callout)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct StepRow: View {
    let number: Int
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(number)")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 20, height: 20)
                .background(Color.accentColor)
                .clipShape(Circle())
            
            Text(text)
                .font(.callout)
        }
    }
}

struct FileRow: View {
    let name: String
    let description: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "doc.text")
                .foregroundColor(.secondary)
                .frame(width: 20)
            
            Text(name)
                .fontWeight(.medium)
                .font(.system(.callout, design: .monospaced))
            
            Text("-")
                .foregroundColor(.secondary)
            
            Text(description)
                .font(.callout)
                .foregroundColor(.secondary)
        }
    }
}

struct PropertyRow: View {
    let name: String
    let type: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                Text(name)
                    .font(.system(.callout, design: .monospaced))
                    .fontWeight(.medium)
                Text(":")
                    .foregroundColor(.secondary)
                Text(type)
                    .font(.system(.callout, design: .monospaced))
                    .foregroundColor(.purple)
            }
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct MethodRow: View {
    let name: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(name)
                .font(.system(.callout, design: .monospaced))
                .fontWeight(.medium)
                .foregroundColor(.blue)
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct BulletPoint: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text("•")
                .foregroundColor(.accentColor)
            Text(text)
                .font(.callout)
        }
    }
}

struct CodeBlockView: View {
    let title: String
    let code: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                Text(code)
                    .font(.system(.callout, design: .monospaced))
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .background(Color(nsColor: .textBackgroundColor).opacity(0.5))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
            )
        }
    }
}

// MARK: - Preview
#Preview {
    ContentView()
        .frame(width: 1000, height: 700)
}
