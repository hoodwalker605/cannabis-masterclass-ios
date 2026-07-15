import SwiftUI

struct GuideView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        NavigationView {
            ZStack {
                Color.nuiBg.ignoresSafeArea()

                if state.grow.active {
                    activeGrowView
                } else {
                    startGrowView
                }
            }
            .navigationTitle("Grow Guide")
            .navigationBarTitleDisplayMode(.large)
            .preferredColorScheme(.dark)
        }
    }

    // MARK: - Start View

    private var startGrowView: some View {
        VStack(spacing: 24) {
            Spacer()

            VStack(spacing: 16) {
                Text("🌱")
                    .font(.system(size: 64))

                Text("Neuen Grow starten")
                    .font(.system(size: DesignSystem.text2xl, weight: .bold))
                    .foregroundColor(.white)

                Text("Beginne mit dem Keimungsprozess und begleite deine Pflanze durch alle 7 Phasen.")
                    .font(.system(size: DesignSystem.textMd))
                    .foregroundColor(.nuiSecondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }

            Spacer()

            NuiButton(title: "Grow starten", icon: "🌱") {
                Haptics.success()
                state.startGrow()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
    }

    // MARK: - Active Grow

    private var activeGrowView: some View {
        ScrollView {
            VStack(spacing: 16) {
                phaseTimeline
                currentPhaseCard
                phaseTasksSection
                phaseNotesSection
                logSection
                phaseActions
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
        }
    }

    // MARK: - Phase Timeline

    private var phaseTimeline: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(PhaseKey.allCases, id: \.self) { phase in
                    phaseTimelineItem(phase)
                    if phase != PhaseKey.allCases.last {
                        Rectangle()
                            .fill(isCompleted(phase) ? Color.brandGreen : Color.nuiBorder)
                            .frame(width: 20, height: 3)
                    }
                }
            }
            .padding(.vertical, 12)
        }
    }

    private func phaseTimelineItem(_ phase: PhaseKey) -> some View {
        VStack(spacing: 4) {
            Text(phase.icon)
                .font(.system(size: 24))
                .opacity(isCurrentOrPast(phase) ? 1.0 : 0.3)
            Text(phase.name)
                .font(.system(size: 9, weight: .medium))
                .foregroundColor(isCurrentOrPast(phase) ? .white : .nuiSecondaryText)
                .lineLimit(1)
        }
        .frame(width: 50)
    }

    private func isCurrentOrPast(_ phase: PhaseKey) -> Bool {
        let allPhases = PhaseKey.allCases
        guard let currentIndex = allPhases.firstIndex(of: state.grow.currentPhase),
              let checkIndex = allPhases.firstIndex(of: phase) else { return false }
        return checkIndex <= currentIndex
    }

    private func isCompleted(_ phase: PhaseKey) -> Bool {
        state.grow.completedPhases.contains { $0.phase == phase }
    }

    // MARK: - Current Phase Card

    private var currentPhaseCard: some View {
        let phase = state.grow.currentPhase
        let definition = PhaseData.phases[phase]

        return NuiCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(phase.icon)
                        .font(.title)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(phase.name)
                            .font(.system(size: DesignSystem.textLg, weight: .bold))
                            .foregroundColor(.white)
                        Text(definition?.duration ?? "")
                            .font(.system(size: DesignSystem.textSm))
                            .foregroundColor(.nuiSecondaryText)
                    }
                    Spacer()
                    NuiBadge(state.profile.goal.name, color: Color.brandGreen)
                }

                Text(definition?.description ?? "")
                    .font(.system(size: DesignSystem.textMd))
                    .foregroundColor(.white)

                if let goalTip = definition?.goalTips[state.profile.goal] {
                    HStack(spacing: 8) {
                        Image(systemName: "lightbulb.fill")
                            .foregroundColor(Color.brandOrange)
                        Text(goalTip)
                            .font(.system(size: DesignSystem.textSm))
                            .foregroundColor(Color.brandOrange)
                    }
                    .padding(12)
                    .background(Color.brandOrange.opacity(0.1))
                    .cornerRadius(DesignSystem.radiusSm)
                }

                // Targets
                if let targets = definition?.targets {
                    Divider().background(Color.nuiBorder)
                    Text("Zielwerte")
                        .font(.system(size: DesignSystem.textSm, weight: .semibold))
                        .foregroundColor(.nuiSecondaryText)
                    targetGrid(targets)
                }
            }
            .padding(16)
        }
    }

    private func targetGrid(_ targets: PhaseTarget) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            if let ppfd = targets.lightPPFD {
                targetRow("PPFD", "\(Int(ppfd.lowerBound))–\(Int(ppfd.upperBound)) µmol/m²/s")
            }
            if let hours = targets.lightHours {
                targetRow("Licht", "\(Int(hours))h")
            }
            if let temp = targets.tempDay {
                targetRow("Temp Tag", "\(Int(temp.lowerBound))–\(Int(temp.upperBound))°C")
            }
            if let vpd = targets.vpd {
                targetRow("VPD", String(format: "%.1f–%.1f kPa", vpd.lowerBound, vpd.upperBound))
            }
            if let rh = targets.humidity {
                targetRow("LF", "\(Int(rh.lowerBound))–\(Int(rh.upperBound))%")
            }
            if let ec = targets.ec {
                targetRow("EC", String(format: "%.1f–%.1f mS/cm", ec.lowerBound, ec.upperBound))
            }
        }
    }

    private func targetRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label)
                .font(.system(size: DesignSystem.textSm))
                .foregroundColor(.nuiSecondaryText)
                .frame(width: 60, alignment: .leading)
            Text(value)
                .font(.system(size: DesignSystem.textSm, weight: .medium))
                .foregroundColor(.white)
        }
    }

    // MARK: - Tasks

    private var phaseTasksSection: some View {
        let phase = state.grow.currentPhase
        let definition = PhaseData.phases[phase]
        let tasks = definition?.tasks ?? []

        return VStack(alignment: .leading, spacing: 10) {
            NuiSectionHeader("Aufgaben", icon: "✅")

            ForEach(Array(tasks.enumerated()), id: \.offset) { index, task in
                Button(action: {
                    Haptics.light()
                    state.toggleTask(index, for: phase)
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: isTaskDone(index, phase: phase) ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(isTaskDone(index, phase: phase) ? Color.brandGreen : .nuiSecondaryText)
                            .font(.title3)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(task.text)
                                .font(.system(size: DesignSystem.textMd))
                                .foregroundColor(.white)
                                .strikethrough(isTaskDone(index, phase: phase))
                            if task.critical {
                                Text("Wichtig!")
                                    .font(.system(size: DesignSystem.textXs, weight: .bold))
                                    .foregroundColor(Color.brandRed)
                            }
                        }
                        Spacer()
                    }
                    .padding(12)
                    .background(Color.nuiCard)
                    .cornerRadius(DesignSystem.radiusMd)
                }
            }
        }
    }

    private func isTaskDone(_ index: Int, phase: PhaseKey) -> Bool {
        state.grow.phaseTasks[phase]?[index] ?? false
    }

    // MARK: - Notes

    private var phaseNotesSection: some View {
        let phase = state.grow.currentPhase

        return VStack(alignment: .leading, spacing: 10) {
            NuiSectionHeader("Notizen", icon: "📝")

            NuiCard {
                VStack(alignment: .leading, spacing: 8) {
                    TextEditor(text: Binding(
                        get: { state.grow.phaseNotes[phase] ?? "" },
                        set: { state.setPhaseNote($0, for: phase) }
                    ))
                    .scrollContentBackground(.hidden)
                    .font(.system(size: DesignSystem.textMd))
                    .foregroundColor(.white)
                    .frame(minHeight: 80)
                }
                .padding(12)
            }
        }
    }

    // MARK: - Log

    private var logSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            NuiSectionHeader("Logbuch", icon: "📒")

            ForEach(state.grow.log.suffix(5).reversed()) { entry in
                HStack(spacing: 8) {
                    Circle()
                        .fill(Color.brandGreen)
                        .frame(width: 6, height: 6)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(entry.text)
                            .font(.system(size: DesignSystem.textSm))
                            .foregroundColor(.white)
                        Text(entry.timestamp.formatted(.dateTime.hour().minute()))
                            .font(.system(size: DesignSystem.textXs))
                            .foregroundColor(.nuiSecondaryText)
                    }
                }
            }

            if state.grow.log.isEmpty {
                Text("Noch keine Einträge")
                    .font(.system(size: DesignSystem.textSm))
                    .foregroundColor(.nuiSecondaryText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
            }
        }
    }

    // MARK: - Phase Actions

    private var phaseActions: some View {
        VStack(spacing: 12) {
            NuiButton(title: "Nächste Phase", icon: "➡️") {
                Haptics.success()
                state.advancePhase()
            }

            if state.grow.active {
                NuiButton(title: "Grow beenden", style: .ghost) {
                    state.grow.active = false
                    state.endGrow()
                }
            }
        }
    }
}
