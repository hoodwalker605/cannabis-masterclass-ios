import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var state: AppState
    @State private var showResetAlert = false
    @State private var showWizardAgain = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.nuiBg.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {
                        profileHeader
                        setupSummary
                        statsSection
                        settingsSection
                        aboutSection
                    }
                    .padding(16)
                }
            }
            .navigationTitle("Profil")
            .navigationBarTitleDisplayMode(.large)
            .alert("Alle Daten löschen?", isPresented: $showResetAlert) {
                Button("Abbrechen", role: .cancel) {}
                Button("Löschen", role: .destructive) {
                    state.resetAll()
                    state.showWizard = true
                }
            } message: {
                Text("Dies löscht alle Profile, Grow-Daten und Fortschritte.")
            }
            .sheet(isPresented: $showWizardAgain) {
                WizardView()
            }
            .preferredColorScheme(.dark)
        }
    }

    // MARK: - Profile Header

    private var profileHeader: some View {
        NuiCard {
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(NuiGradients.goalGradient(state.profile.goal))
                        .frame(width: 80, height: 80)
                    Text(state.profile.goal.name.prefix(1).uppercased())
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                }

                VStack(spacing: 4) {
                    Text(state.profile.location.isEmpty ? "Cannabis Masterclass" : state.profile.location)
                        .font(.system(size: DesignSystem.textXl, weight: .bold))
                        .foregroundColor(.white)
                    Text(state.profile.goal.name)
                        .font(.system(size: DesignSystem.textMd))
                        .foregroundColor(.nuiSecondaryText)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
        }
    }

    // MARK: - Setup Summary

    private var setupSummary: some View {
        VStack(alignment: .leading, spacing: 10) {
            NuiSectionHeader("Dein Setup", icon: "⚙️")

            NuiCard {
                VStack(spacing: 10) {
                    profileRow("Ziel", state.profile.goal.name)
                    profileRow("Art", state.profile.growType.name)
                    profileRow("Erfahrung", state.profile.experience.name)
                    profileRow("Genetik", state.profile.geneticsType.name)
                    if !state.profile.strainName.isEmpty {
                        profileRow("Sorte", state.profile.strainName)
                    }
                    profileRow("Vermehrung", state.profile.propagation.name)
                    profileRow("Licht", state.profile.lightType.name)
                    profileRow("Substrat", state.profile.substrate.name)
                    profileRow("Topf", "\(Int(state.profile.potSize))L")
                    profileRow("Umgebung", state.profile.indoor.name)
                    profileRow("CO₂", state.profile.co2 ? "Ja" : "Nein")
                    if !state.profile.priorities.isEmpty {
                        profileRow("Prioritäten", state.profile.priorities.map(\.name).joined(separator: ", "))
                    }
                }
                .padding(14)
            }
        }
    }

    private func profileRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label)
                .font(.system(size: DesignSystem.textSm))
                .foregroundColor(.nuiSecondaryText)
            Spacer()
            Text(value)
                .font(.system(size: DesignSystem.textSm, weight: .medium))
                .foregroundColor(.white)
        }
    }

    // MARK: - Stats

    private var statsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            NuiSectionHeader("Statistiken", icon: "📊")

            HStack(spacing: 10) {
                statCard("Grows", value: "\(state.stats.totalGrows)", icon: "🌱")
                statCard("Fertig", value: "\(state.stats.completedGrows)", icon: "✅")
                statCard("Module", value: "\(state.moduleProgress.count)", icon: "📚")
            }
        }
    }

    private func statCard(_ label: String, value: String, icon: String) -> some View {
        NuiCard {
            VStack(spacing: 8) {
                Text(icon)
                    .font(.title2)
                Text(value)
                    .font(.system(size: DesignSystem.textXl, weight: .bold))
                    .foregroundColor(.white)
                Text(label)
                    .font(.system(size: DesignSystem.textXs))
                    .foregroundColor(.nuiSecondaryText)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
        }
    }

    // MARK: - Settings

    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            NuiSectionHeader("Einstellungen", icon: "🔧")

            VStack(spacing: 2) {
                settingsButton("Wizard neu starten", icon: "arrow.counterclockwise") {
                    showWizardAgain = true
                }
                Divider().background(Color.nuiBorder).padding(.leading, 44)
                settingsButton("Grow beenden", icon: "stop.fill") {
                    if state.grow.active {
                        state.grow.active = false
                        state.endGrow()
                    }
                }
                Divider().background(Color.nuiBorder).padding(.leading, 44)
                settingsButton("App zurücksetzen", icon: "trash.fill", color: Color.brandRed) {
                    showResetAlert = true
                }
            }
            .background(Color.nuiCard)
            .cornerRadius(DesignSystem.radiusLg)
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.radiusLg)
                    .stroke(Color.nuiBorder, lineWidth: 1)
            )
        }
    }

    private func settingsButton(_ title: String, icon: String, color: Color = .white, action: @escaping () -> Void) -> some View {
        Button(action: {
            Haptics.light()
            action()
        }) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(color)
                    .frame(width: 24)
                Text(title)
                    .font(.system(size: DesignSystem.textMd))
                    .foregroundColor(color)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(.nuiSecondaryText)
            }
            .padding(14)
        }
    }

    // MARK: - About

    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            NuiSectionHeader("Über", icon: "ℹ️")

            NuiCard {
                VStack(spacing: 12) {
                    Text("🌿")
                        .font(.system(size: 36))
                    Text("Cannabis Masterclass")
                        .font(.system(size: DesignSystem.textLg, weight: .bold))
                        .foregroundColor(.white)
                    Text("Version 3.0.0 — iOS Native")
                        .font(.system(size: DesignSystem.textSm))
                        .foregroundColor(.nuiSecondaryText)
                    Text("Dein vollständiger Leitfaden für Cannabis-Anbau. Von der Keimung bis zum Curing.")
                        .font(.system(size: DesignSystem.textSm))
                        .foregroundColor(.nuiSecondaryText)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(16)
            }
        }
    }
}
