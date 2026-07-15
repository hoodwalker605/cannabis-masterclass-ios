import Foundation

// MARK: - Community Profile

struct CommunityProfile: Codable, Identifiable {
    let id: String
    var strain: String
    var breeder: String
    var goal: String
    var growType: String
    var substrate: String
    var lightType: String
    var environment: String
    var dryWeight: Int?
    var thc: Double?
    var cbd: Double?
    var growDuration: String?
    var notes: String
    var author: String
    var timestamp: Date
    var likes: Int
    var tags: [String]

    init(strain: String, breeder: String, goal: String, growType: String, substrate: String, lightType: String, environment: String, dryWeight: Int? = nil, thc: Double? = nil, cbd: Double? = nil, growDuration: String? = nil, notes: String, author: String, tags: [String] = []) {
        self.id = UUID().uuidString
        self.strain = strain
        self.breeder = breeder
        self.goal = goal
        self.growType = growType
        self.substrate = substrate
        self.lightType = lightType
        self.environment = environment
        self.dryWeight = dryWeight
        self.thc = thc
        self.cbd = cbd
        self.growDuration = growDuration
        self.notes = notes
        self.author = author
        self.timestamp = Date()
        self.likes = 0
        self.tags = tags
    }
}

// MARK: - Community Filter

struct CommunityFilter {
    var sortBy: SortOption = .newest
    var filterGoal: String? = nil
    var filterSubstrate: String? = nil
    var searchQuery: String = ""

    enum SortOption: String, CaseIterable {
        case newest = "Neueste"
        case likes = "Beliebteste"
        case yield = "Höchster Ertrag"
    }
}

// MARK: - Community Data

enum CommunityData {
    static let sampleProfiles: [CommunityProfile] = [
        CommunityProfile(
            strain: "Northern Lights", breeder: "Royal Queen Seeds", goal: "A: Ertrag",
            growType: "Photoperiode", substrate: "Coco", lightType: "LED",
            environment: "Indoor", dryWeight: 180, thc: 21, cbd: 0.5,
            growDuration: "14 Wochen Veg + 9 Wochen Bloom",
            notes: "Sehr ergiebige Sorte, wenig Issues. Coco mit Biobizz. Top Ertrag!",
            author: "GrowerMax", tags: ["Indoor", "Coco", "LED", "Ertrag"]
        ),
        CommunityProfile(
            strain: "Gelato", breeder: "Barney's Farm", goal: "B: Harz",
            growType: "Photoperiode", substrate: "Living Soil", lightType: "LED",
            environment: "Indoor", dryWeight: 90, thc: 26, cbd: 0.3,
            growDuration: "8 Wochen Veg + 10 Wochen Bloom",
            notes: "Krasse Terpene, fast wie Dessert. Living Soil bringt Geschmack!",
            author: "TerpHunter", tags: ["Indoor", "Living Soil", "Harz", "Terpene"]
        ),
        CommunityProfile(
            strain: "Blue Dream", breeder: "Humboldt Seeds", goal: "C: Balance",
            growType: "Photoperiode", substrate: "Erde", lightType: "LED",
            environment: "Greenhouse", dryWeight: 200, thc: 22, cbd: 1.2,
            growDuration: "6 Wochen Veg + 9 Wochen Bloom",
            notes: "Perfekter Balance-Grow im GH. Guter Ertrag + tolles Terpenprofil.",
            author: "GreenThumb", tags: ["Greenhouse", "Erde", "Balance", "CBD"]
        ),
        CommunityProfile(
            strain: "Amnesia Haze", breeder: "FastBuds", goal: "A: Ertrag",
            growType: "Autoflower", substrate: "Coco", lightType: "LED",
            environment: "Indoor", dryWeight: 120, thc: 24, cbd: 0.1,
            growDuration: "12 Wochen gesamt",
            notes: "Starke Auto, lange Blüte aber lohnt sich. Coco + Blumat自动浇水.",
            author: "AutoKing", tags: ["Autoflower", "Coco", "Ertrag"]
        ),
        CommunityProfile(
            strain: "Critical Mass", breeder: "Sweet Seeds", goal: "A: Ertrag",
            growType: "Photoperiode", substrate: "Erde", lightType: "HPS",
            environment: "Indoor", dryWeight: 250, thc: 19, cbd: 0.8,
            growDuration: "6 Wochen Veg + 8 Wochen Bloom",
            notes: "Riesige Buds, Vorsicht vor Schimmel! HPS + Scrog bringt Masse.",
            author: "MassGrower", tags: ["Indoor", "Erde", "HPS", "Ertrag"]
        )
    ]
}
