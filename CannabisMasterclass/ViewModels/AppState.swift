import Foundation
import SwiftUI
import Combine

// MARK: - App State

class AppState: ObservableObject {
    // Wizard
    @Published var wizardComplete: Bool = false
    @Published var wizardAnswers: [String: Any] = [:]

    // Profile
    @Published var profile: GrowProfile = GrowProfile()

    // Grow
    @Published var grow: GrowState = GrowState()

    // Stats
    @Published var stats: AppStats = AppStats()

    // Module progress
    @Published var moduleProgress: [String: [Int: Bool]] = [:]
    @Published var moduleQuizScores: [String: Int] = [:]

    // Widget values (calculator presets)
    @Published var widgetValues: [String: [String: Double]] = [:]

    // Community
    @Published var communityProfiles: [CommunityProfile] = []

    // UI State
    @Published var selectedTab: Int = 0
    @Published var showWizard: Bool = false

    init() {
        loadState()
        if communityProfiles.isEmpty {
            communityProfiles = CommunityData.sampleProfiles
        }
    }

    // MARK: - Wizard

    func completeWizard() {
        wizardComplete = true
        showWizard = false
        saveState()
    }

    func resetWizard() {
        wizardComplete = false
        wizardAnswers = [:]
        profile = GrowProfile()
        showWizard = true
        saveState()
    }

    // MARK: - Grow

    func startGrow() {
        grow.active = true
        grow.currentPhase = .germination
        grow.phaseStarted = Date()
        grow.totalWeeks = 0
        saveState()
    }

    func endGrow() {
        stats.completedGrows += 1
        saveState()
    }

    func advancePhase() {
        let allPhases = PhaseKey.allCases
        guard let currentIndex = allPhases.firstIndex(of: grow.currentPhase),
              currentIndex + 1 < allPhases.count else {
            grow.active = false
            stats.completedGrows += 1
            saveState()
            return
        }

        let completedPhase = CompletedPhase(
            phase: grow.currentPhase,
            endedAt: Date(),
            notes: grow.phaseNotes[grow.currentPhase] ?? ""
        )
        grow.completedPhases.append(completedPhase)

        grow.currentPhase = allPhases[currentIndex + 1]
        grow.phaseStarted = Date()
        saveState()
    }

    func addLogEntry(_ text: String) {
        let entry = LogEntry(text: text)
        grow.log.append(entry)
        saveState()
    }

    func setPhaseNote(_ note: String, for phase: PhaseKey) {
        grow.phaseNotes[phase] = note
        saveState()
    }

    func toggleTask(_ taskIndex: Int, for phase: PhaseKey) {
        var tasks = grow.phaseTasks[phase] ?? [:]
        tasks[taskIndex] = !(tasks[taskIndex] ?? false)
        grow.phaseTasks[phase] = tasks
        saveState()
    }

    func saveAnswer(_ answer: String, questionId: String, phase: PhaseKey) {
        var answers = grow.phaseAnswers[phase] ?? [:]
        answers[questionId] = answer
        grow.phaseAnswers[phase] = answers
        saveState()
    }

    // MARK: - Modules

    func toggleModuleProgress(moduleId: String, sectionIndex: Int) {
        var progress = moduleProgress[moduleId] ?? [:]
        progress[sectionIndex] = !(progress[sectionIndex] ?? false)
        moduleProgress[moduleId] = progress
        saveState()
    }

    func moduleProgressPercent(moduleId: String) -> Double {
        guard let module = ModuleData.getModule(id: moduleId) else { return 0 }
        let progress = moduleProgress[moduleId] ?? [:]
        let completed = progress.values.filter { $0 }.count
        return Double(completed) / Double(module.sections.count)
    }

    func saveQuizScore(moduleId: String, score: Int) {
        moduleQuizScores[moduleId] = score
        saveState()
    }

    // MARK: - Widgets

    func saveWidgetValue(widgetId: String, key: String, value: Double) {
        var values = widgetValues[widgetId] ?? [:]
        values[key] = value
        widgetValues[widgetId] = values
        saveState()
    }

    func getWidgetValue(widgetId: String, key: String) -> Double? {
        widgetValues[widgetId]?[key]
    }

    // MARK: - Community

    func addCommunityProfile(_ profile: CommunityProfile) {
        communityProfiles.insert(profile, at: 0)
        saveState()
    }

    func likeCommunityProfile(id: String) {
        if let index = communityProfiles.firstIndex(where: { $0.id == id }) {
            communityProfiles[index].likes += 1
            saveState()
        }
    }

    func filteredCommunityProfiles(filter: CommunityFilter) -> [CommunityProfile] {
        var profiles = communityProfiles

        if let goalFilter = filter.filterGoal {
            profiles = profiles.filter { $0.goal == goalFilter }
        }
        if let substrateFilter = filter.filterSubstrate {
            profiles = profiles.filter { $0.substrate == substrateFilter }
        }
        if !filter.searchQuery.isEmpty {
            let query = filter.searchQuery.lowercased()
            profiles = profiles.filter {
                $0.strain.lowercased().contains(query) ||
                $0.breeder.lowercased().contains(query) ||
                $0.notes.lowercased().contains(query)
            }
        }

        switch filter.sortBy {
        case .newest:
            profiles.sort { $0.timestamp > $1.timestamp }
        case .likes:
            profiles.sort { $0.likes > $1.likes }
        case .yield:
            profiles.sort { ($0.dryWeight ?? 0) > ($1.dryWeight ?? 0) }
        }

        return profiles
    }

    // MARK: - Persistence

    func saveState() {
        Persistence.save(wizardComplete, forKey: Persistence.stateKey + "_wizard")
        Persistence.save(profile, forKey: Persistence.stateKey + "_profile")
        Persistence.save(grow, forKey: Persistence.stateKey + "_grow")
        Persistence.save(stats, forKey: Persistence.stateKey + "_stats")
        Persistence.save(moduleProgress, forKey: Persistence.moduleProgressKey)
        Persistence.save(moduleQuizScores, forKey: Persistence.moduleProgressKey + "_quiz")
        Persistence.save(widgetValues, forKey: Persistence.widgetValuesKey)
        Persistence.save(communityProfiles, forKey: Persistence.communityKey)
    }

    func loadState() {
        if let w = Persistence.load(forKey: Persistence.stateKey + "_wizard", as: Bool.self) {
            wizardComplete = w
        }
        if let p = Persistence.load(forKey: Persistence.stateKey + "_profile", as: GrowProfile.self) {
            profile = p
        }
        if let g = Persistence.load(forKey: Persistence.stateKey + "_grow", as: GrowState.self) {
            grow = g
        }
        if let s = Persistence.load(forKey: Persistence.stateKey + "_stats", as: AppStats.self) {
            stats = s
        }
        if let m = Persistence.load(forKey: Persistence.moduleProgressKey, as: [String: [Int: Bool]].self) {
            moduleProgress = m
        }
        if let q = Persistence.load(forKey: Persistence.moduleProgressKey + "_quiz", as: [String: Int].self) {
            moduleQuizScores = q
        }
        if let w = Persistence.load(forKey: Persistence.widgetValuesKey, as: [String: [String: Double]].self) {
            widgetValues = w
        }
        if let c = Persistence.load(forKey: Persistence.communityKey, as: [CommunityProfile].self) {
            communityProfiles = c
        }
    }

    func resetAll() {
        Persistence.remove(forKey: Persistence.stateKey + "_wizard")
        Persistence.remove(forKey: Persistence.stateKey + "_profile")
        Persistence.remove(forKey: Persistence.stateKey + "_grow")
        Persistence.remove(forKey: Persistence.stateKey + "_stats")
        Persistence.remove(forKey: Persistence.moduleProgressKey)
        Persistence.remove(forKey: Persistence.moduleProgressKey + "_quiz")
        Persistence.remove(forKey: Persistence.widgetValuesKey)
        Persistence.remove(forKey: Persistence.communityKey)

        wizardComplete = false
        wizardAnswers = [:]
        profile = GrowProfile()
        grow = GrowState()
        stats = AppStats()
        moduleProgress = [:]
        moduleQuizScores = [:]
        widgetValues = [:]
        communityProfiles = CommunityData.sampleProfiles
    }
}
