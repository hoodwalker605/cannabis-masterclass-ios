import Foundation
import Combine

// MARK: - Grow Goal

enum GrowGoal: String, Codable, CaseIterable {
    case A = "A"
    case B = "B"
    case C = "C"

    var name: String {
        switch self {
        case .A: return "Maximum Ertrag"
        case .B: return "Maximum Harz/Qualität"
        case .C: return "Balance"
        }
    }

    var color: String {
        switch self {
        case .A: return "#3D6B4F"
        case .B: return "#7F77DD"
        case .C: return "#C8831A"
        }
    }

    var description: String {
        switch self {
        case .A: return "Maximaler Trockenertrag in Gramm"
        case .B: return "Maximale THC- und Terpenkonzentration"
        case .C: return "Optimale Verbindung aus Menge und Qualität"
        }
    }
}

// MARK: - Grow Type

enum GrowType: String, Codable, CaseIterable {
    case photoperiod
    case autoflower

    var name: String {
        switch self {
        case .photoperiod: return "Photoperiode"
        case .autoflower: return "Autoflower"
        }
    }
}

// MARK: - Experience Level

enum ExperienceLevel: String, Codable, CaseIterable {
    case beginner
    case intermediate
    case advanced

    var name: String {
        switch self {
        case .beginner: return "Anfänger"
        case .intermediate: return "Fortgeschritten"
        case .advanced: return "Experte"
        }
    }
}

// MARK: - Genetics Type

enum GeneticsType: String, Codable, CaseIterable {
    case indica
    case sativa
    case hybrid
    case ruderalis

    var name: String {
        switch self {
        case .indica: return "Indica-dominant"
        case .sativa: return "Sativa-dominant"
        case .hybrid: return "Hybrid (50/50)"
        case .ruderalis: return "Ruderalis / Auto"
        }
    }
}

// MARK: - Propagation Type

enum PropagationType: String, Codable, CaseIterable {
    case seed
    case clone
    case seed_stable

    var name: String {
        switch self {
        case .seed: return "Samen"
        case .clone: return "Steckling"
        case .seed_stable: return "Stabilisierte F1-Samen"
        }
    }
}

// MARK: - Light Type

enum LightType: String, Codable, CaseIterable {
    case led
    case led_plus
    case hps
    case cmh
    case sun

    var name: String {
        switch self {
        case .led: return "LED Vollspektrum"
        case .led_plus: return "LED + UV/IR"
        case .hps: return "HPS"
        case .cmh: return "CMH / Keramik"
        case .sun: return "Sonnenlicht / GH"
        }
    }
}

// MARK: - Substrate Type

enum SubstrateType: String, Codable, CaseIterable {
    case soil
    case coco
    case hydro
    case peat

    var name: String {
        switch self {
        case .soil: return "Erde / Living Soil"
        case .coco: return "Coco Coir"
        case .hydro: return "Hydro / DWC"
        case .peat: return "Torf-Mix"
        }
    }
}

// MARK: - Environment Type

enum EnvironmentType: String, Codable, CaseIterable {
    case indoor
    case greenhouse
    case outdoor

    var name: String {
        switch self {
        case .indoor: return "Indoor"
        case .greenhouse: return "Greenhouse"
        case .outdoor: return "Outdoor"
        }
    }
}

// MARK: - Priority

enum GrowPriority: String, Codable, CaseIterable {
    case ertrag
    case potenz
    case terpene
    case geschmack
    case wirkung
    case farbe
    case resistenz
    case einfachheit

    var name: String {
        switch self {
        case .ertrag: return "Maximaler Ertrag"
        case .potenz: return "Maximale Potenz"
        case .terpene: return "Terpen-Profil"
        case .geschmack: return "Geschmack"
        case .wirkung: return "Spezifische Wirkung"
        case .farbe: return "Blüten-Farbe"
        case .resistenz: return "Resistenz"
        case .einfachheit: return "Einfache Handhabung"
        }
    }
}

// MARK: - Grow Profile

struct GrowProfile: Codable {
    var goal: GrowGoal = .C
    var growType: GrowType = .photoperiod
    var experience: ExperienceLevel = .intermediate
    var strainName: String = ""
    var breeder: String = ""
    var geneticsType: GeneticsType = .hybrid
    var thcPercent: Double = 20
    var propagation: PropagationType = .seed
    var lightType: LightType = .led
    var ppfd: Double = 600
    var substrate: SubstrateType = .soil
    var potSize: Double = 11
    var co2: Bool = false
    var indoor: EnvironmentType = .indoor
    var priorities: [GrowPriority] = []
    var location: String = ""
}

// MARK: - Phase Key

enum PhaseKey: String, Codable, CaseIterable {
    case germination
    case seedling
    case veg
    case early_bloom
    case late_bloom
    case harvest
    case cure

    var name: String {
        switch self {
        case .germination: return "Keimung"
        case .seedling: return "Sämling"
        case .veg: return "Vegetation"
        case .early_bloom: return "Frühe Blüte"
        case .late_bloom: return "Späte Blüte"
        case .harvest: return "Ernte"
        case .cure: return "Curing"
        }
    }

    var icon: String {
        switch self {
        case .germination: return "🥚"
        case .seedling: return "🌱"
        case .veg: return "☘️"
        case .early_bloom: return "🌸"
        case .late_bloom: return "🌻"
        case .harvest: return "✂️"
        case .cure: return "🫙"
        }
    }
}

// MARK: - Grow State

struct GrowState: Codable {
    var active: Bool = false
    var currentPhase: PhaseKey = .germination
    var phaseStarted: Date? = nil
    var totalWeeks: Int = 0
    var log: [LogEntry] = []
    var phaseNotes: [PhaseKey: String] = [:]
    var completedPhases: [CompletedPhase] = []
    var phaseTasks: [PhaseKey: [Int: Bool]] = [:]
    var phaseAnswers: [PhaseKey: [String: String]] = [:]
}

struct LogEntry: Codable, Identifiable {
    let id: UUID
    var text: String
    var timestamp: Date

    init(text: String) {
        self.id = UUID()
        self.text = text
        self.timestamp = Date()
    }
}

struct CompletedPhase: Codable {
    var phase: PhaseKey
    var endedAt: Date
    var notes: String
}

// MARK: - App Stats

struct AppStats: Codable {
    var totalGrows: Int = 0
    var completedGrows: Int = 0
}
