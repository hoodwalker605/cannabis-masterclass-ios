import SwiftUI

struct WizardView: View {
    @EnvironmentObject var state: AppState
    @State private var currentStep: Int = 0
    @State private var answers: [String: Any] = [:]
    @State private var selectedGoal: GrowGoal = .C
    @State private var selectedGrowType: GrowType = .photoperiod
    @State private var selectedExperience: ExperienceLevel = .intermediate
    @State private var selectedGenetics: GeneticsType = .hybrid
    @State private var selectedPropagation: PropagationType = .seed
    @State private var selectedLight: LightType = .led
    @State private var selectedSubstrate: SubstrateType = .soil
    @State private var selectedEnvironment: EnvironmentType = .indoor
    @State private var strainName: String = ""
    @State private var growerName: String = ""
    @State private var potSize: Double = 11
    @State private var co2Enabled: Bool = false
    @State private var selectedPriorities: [GrowPriority] = []

    let totalSteps = 14

    var body: some View {
        ZStack {
            Color.nuiBg.ignoresSafeArea()

            VStack(spacing: 0) {
                wizardHeader
                progressBar
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)

                ScrollView {
                    VStack(spacing: 20) {
                        stepContent
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 32)
                }

                wizardNavigation
            }
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - Header

    private var wizardHeader: some View {
        VStack(spacing: 8) {
            HStack {
                if currentStep > 0 {
                    Button(action: { withAnimation { currentStep -= 1 } }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                    }
                }
                Spacer()
                Text("Schritt \(currentStep + 1) von \(totalSteps)")
                    .font(.system(size: DesignSystem.textSm))
                    .foregroundColor(.nuiSecondaryText)
                Spacer()
                Button(action: { skipWizard() }) {
                    Text("Überspringen")
                        .font(.system(size: DesignSystem.textSm))
                        .foregroundColor(.nuiSecondaryText)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)

            Text(stepTitle)
                .font(.system(size: DesignSystem.text2xl, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 8)
        }
        .background(Color.nuiBg)
    }

    private var progressBar: some View {
        NuiProgress(progress: Double(currentStep + 1) / Double(totalSteps), color: Color.brandGreen)
    }

    // MARK: - Step Content

    @ViewBuilder
    private var stepContent: some View {
        switch currentStep {
        case 0: goalSelection
        case 1: growTypeSelection
        case 2: experienceSelection
        case 3: geneticsSelection
        case 4: strainInput
        case 5: propagationSelection
        case 6: lightSelection
        case 7: substrateSelection
        case 8: potSizeSlider
        case 9: environmentSelection
        case 10: co2Toggle
        case 11: prioritySelection
        case 12: nameInput
        case 13: confirmView
        default: EmptyView()
        }
    }

    // MARK: - Steps

    private var goalSelection: some View {
        VStack(spacing: 12) {
            Text("Was ist dein Hauptziel?")
                .font(.system(size: DesignSystem.textMd))
                .foregroundColor(.nuiSecondaryText)
                .frame(maxWidth: .infinity, alignment: .leading)

            ForEach(GrowGoal.allCases, id: \.self) { goal in
                Button(action: {
                    Haptics.selection()
                    selectedGoal = goal
                }) {
                    HStack(spacing: 12) {
                        Text(goalIcon(goal))
                            .font(.title2)
                        VStack(alignment: .leading, spacing: 4) {
                            Text(goal.name)
                                .font(.system(size: DesignSystem.textLg, weight: .semibold))
                                .foregroundColor(.white)
                            Text(goal.description)
                                .font(.system(size: DesignSystem.textSm))
                                .foregroundColor(.nuiSecondaryText)
                        }
                        Spacer()
                        if selectedGoal == goal {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Color.brandGreen)
                        }
                    }
                    .padding(16)
                    .background(selectedGoal == goal ? Color.brandGreen.opacity(0.15) : Color.nuiCard)
                    .cornerRadius(DesignSystem.radiusMd)
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignSystem.radiusMd)
                            .stroke(selectedGoal == goal ? Color.brandGreen : Color.nuiBorder, lineWidth: 1.5)
                    )
                }
            }
        }
    }

    private var growTypeSelection: some View {
        VStack(spacing: 12) {
            Text("Welche Art von Cannabis?")
                .font(.system(size: DesignSystem.textMd))
                .foregroundColor(.nuiSecondaryText)
                .frame(maxWidth: .infinity, alignment: .leading)

            ForEach(GrowType.allCases, id: \.self) { type in
                Button(action: {
                    Haptics.selection()
                    selectedGrowType = type
                }) {
                    HStack(spacing: 12) {
                        Text(type == .photoperiod ? "☀️" : "⏱️")
                            .font(.title2)
                        Text(type.name)
                            .font(.system(size: DesignSystem.textLg, weight: .semibold))
                            .foregroundColor(.white)
                        Spacer()
                        if selectedGrowType == type {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Color.brandGreen)
                        }
                    }
                    .padding(16)
                    .background(selectedGrowType == type ? Color.brandGreen.opacity(0.15) : Color.nuiCard)
                    .cornerRadius(DesignSystem.radiusMd)
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignSystem.radiusMd)
                            .stroke(selectedGrowType == type ? Color.brandGreen : Color.nuiBorder, lineWidth: 1.5)
                    )
                }
            }
        }
    }

    private var experienceSelection: some View {
        VStack(spacing: 12) {
            Text("Dein Erfahrungslevel?")
                .font(.system(size: DesignSystem.textMd))
                .foregroundColor(.nuiSecondaryText)
                .frame(maxWidth: .infinity, alignment: .leading)

            ForEach(ExperienceLevel.allCases, id: \.self) { level in
                Button(action: {
                    Haptics.selection()
                    selectedExperience = level
                }) {
                    HStack(spacing: 12) {
                        Text(level == .beginner ? "🌱" : level == .intermediate ? "🌿" : "🌳")
                            .font(.title2)
                        Text(level.name)
                            .font(.system(size: DesignSystem.textLg, weight: .semibold))
                            .foregroundColor(.white)
                        Spacer()
                        if selectedExperience == level {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Color.brandGreen)
                        }
                    }
                    .padding(16)
                    .background(selectedExperience == level ? Color.brandGreen.opacity(0.15) : Color.nuiCard)
                    .cornerRadius(DesignSystem.radiusMd)
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignSystem.radiusMd)
                            .stroke(selectedExperience == level ? Color.brandGreen : Color.nuiBorder, lineWidth: 1.5)
                    )
                }
            }
        }
    }

    private var geneticsSelection: some View {
        VStack(spacing: 12) {
            Text("Genetik?")
                .font(.system(size: DesignSystem.textMd))
                .foregroundColor(.nuiSecondaryText)
                .frame(maxWidth: .infinity, alignment: .leading)

            ForEach(GeneticsType.allCases, id: \.self) { genetics in
                Button(action: {
                    Haptics.selection()
                    selectedGenetics = genetics
                }) {
                    HStack(spacing: 12) {
                        Text(genetics == .indica ? "🌙" : genetics == .sativa ? "☀️" : genetics == .hybrid ? "🔀" : "🌾")
                            .font(.title2)
                        Text(genetics.name)
                            .font(.system(size: DesignSystem.textLg, weight: .semibold))
                            .foregroundColor(.white)
                        Spacer()
                        if selectedGenetics == genetics {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Color.brandGreen)
                        }
                    }
                    .padding(16)
                    .background(selectedGenetics == genetics ? Color.brandGreen.opacity(0.15) : Color.nuiCard)
                    .cornerRadius(DesignSystem.radiusMd)
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignSystem.radiusMd)
                            .stroke(selectedGenetics == genetics ? Color.brandGreen : Color.nuiBorder, lineWidth: 1.5)
                    )
                }
            }
        }
    }

    private var strainInput: some View {
        VStack(spacing: 12) {
            Text("Welche Sorte (optional)?")
                .font(.system(size: DesignSystem.textMd))
                .foregroundColor(.nuiSecondaryText)
                .frame(maxWidth: .infinity, alignment: .leading)

            TextField("z.B. Northern Lights, Gelato...", text: $strainName)
                .textFieldStyle(.plain)
                .padding(16)
                .background(Color.nuiCard)
                .cornerRadius(DesignSystem.radiusMd)
                .overlay(
                    RoundedRectangle(cornerRadius: DesignSystem.radiusMd)
                        .stroke(Color.nuiBorder, lineWidth: 1)
                )
                .foregroundColor(.white)
        }
    }

    private var propagationSelection: some View {
        VStack(spacing: 12) {
            Text("Vermehrung?")
                .font(.system(size: DesignSystem.textMd))
                .foregroundColor(.nuiSecondaryText)
                .frame(maxWidth: .infinity, alignment: .leading)

            ForEach(PropagationType.allCases, id: \.self) { type in
                Button(action: {
                    Haptics.selection()
                    selectedPropagation = type
                }) {
                    HStack(spacing: 12) {
                        Text(type == .seed ? "🌰" : type == .clone ? "🌱" : "🧪")
                            .font(.title2)
                        Text(type.name)
                            .font(.system(size: DesignSystem.textLg, weight: .semibold))
                            .foregroundColor(.white)
                        Spacer()
                        if selectedPropagation == type {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Color.brandGreen)
                        }
                    }
                    .padding(16)
                    .background(selectedPropagation == type ? Color.brandGreen.opacity(0.15) : Color.nuiCard)
                    .cornerRadius(DesignSystem.radiusMd)
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignSystem.radiusMd)
                            .stroke(selectedPropagation == type ? Color.brandGreen : Color.nuiBorder, lineWidth: 1.5)
                    )
                }
            }
        }
    }

    private var lightSelection: some View {
        VStack(spacing: 12) {
            Text("Beleuchtung?")
                .font(.system(size: DesignSystem.textMd))
                .foregroundColor(.nuiSecondaryText)
                .frame(maxWidth: .infinity, alignment: .leading)

            ForEach(LightType.allCases, id: \.self) { type in
                Button(action: {
                    Haptics.selection()
                    selectedLight = type
                }) {
                    HStack(spacing: 12) {
                        Text(type == .led ? "💡" : type == .led_plus ? "💡✨" : type == .hps ? "🔶" : type == .cmh ? "🟡" : "☀️")
                            .font(.title2)
                        Text(type.name)
                            .font(.system(size: DesignSystem.textLg, weight: .semibold))
                            .foregroundColor(.white)
                        Spacer()
                        if selectedLight == type {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Color.brandGreen)
                        }
                    }
                    .padding(16)
                    .background(selectedLight == type ? Color.brandGreen.opacity(0.15) : Color.nuiCard)
                    .cornerRadius(DesignSystem.radiusMd)
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignSystem.radiusMd)
                            .stroke(selectedLight == type ? Color.brandGreen : Color.nuiBorder, lineWidth: 1.5)
                    )
                }
            }
        }
    }

    private var substrateSelection: some View {
        VStack(spacing: 12) {
            Text("Substrat?")
                .font(.system(size: DesignSystem.textMd))
                .foregroundColor(.nuiSecondaryText)
                .frame(maxWidth: .infinity, alignment: .leading)

            ForEach(SubstrateType.allCases, id: \.self) { type in
                Button(action: {
                    Haptics.selection()
                    selectedSubstrate = type
                }) {
                    HStack(spacing: 12) {
                        Text(type == .soil ? "🪴" : type == .coco ? "🥥" : type == .hydro ? "💧" : "🟤")
                            .font(.title2)
                        Text(type.name)
                            .font(.system(size: DesignSystem.textLg, weight: .semibold))
                            .foregroundColor(.white)
                        Spacer()
                        if selectedSubstrate == type {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Color.brandGreen)
                        }
                    }
                    .padding(16)
                    .background(selectedSubstrate == type ? Color.brandGreen.opacity(0.15) : Color.nuiCard)
                    .cornerRadius(DesignSystem.radiusMd)
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignSystem.radiusMd)
                            .stroke(selectedSubstrate == type ? Color.brandGreen : Color.nuiBorder, lineWidth: 1.5)
                    )
                }
            }
        }
    }

    private var potSizeSlider: some View {
        VStack(spacing: 12) {
            Text("Topfgröße?")
                .font(.system(size: DesignSystem.textMd))
                .foregroundColor(.nuiSecondaryText)
                .frame(maxWidth: .infinity, alignment: .leading)

            NuiCard {
                VStack(spacing: 12) {
                    Text("\(Int(potSize)) Liter")
                        .font(.system(size: DesignSystem.text2xl, weight: .bold))
                        .foregroundColor(.white)

                    Slider(value: $potSize, in: 1...50, step: 1)
                        .accentColor(Color.brandGreen)

                    HStack {
                        Text("1L")
                            .font(.system(size: DesignSystem.textSm))
                            .foregroundColor(.nuiSecondaryText)
                        Spacer()
                        Text("50L")
                            .font(.system(size: DesignSystem.textSm))
                            .foregroundColor(.nuiSecondaryText)
                    }
                }
                .padding(16)
            }
        }
    }

    private var environmentSelection: some View {
        VStack(spacing: 12) {
            Text("Umgebung?")
                .font(.system(size: DesignSystem.textMd))
                .foregroundColor(.nuiSecondaryText)
                .frame(maxWidth: .infinity, alignment: .leading)

            ForEach(EnvironmentType.allCases, id: \.self) { env in
                Button(action: {
                    Haptics.selection()
                    selectedEnvironment = env
                }) {
                    HStack(spacing: 12) {
                        Text(env == .indoor ? "🏠" : env == .greenhouse ? "🏡" : "🌳")
                            .font(.title2)
                        Text(env.name)
                            .font(.system(size: DesignSystem.textLg, weight: .semibold))
                            .foregroundColor(.white)
                        Spacer()
                        if selectedEnvironment == env {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Color.brandGreen)
                        }
                    }
                    .padding(16)
                    .background(selectedEnvironment == env ? Color.brandGreen.opacity(0.15) : Color.nuiCard)
                    .cornerRadius(DesignSystem.radiusMd)
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignSystem.radiusMd)
                            .stroke(selectedEnvironment == env ? Color.brandGreen : Color.nuiBorder, lineWidth: 1.5)
                    )
                }
            }
        }
    }

    private var co2Toggle: some View {
        VStack(spacing: 12) {
            Text("CO₂-Anreicherung?")
                .font(.system(size: DesignSystem.textMd))
                .foregroundColor(.nuiSecondaryText)
                .frame(maxWidth: .infinity, alignment: .leading)

            NuiCard {
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("CO₂-Zugabe")
                            .font(.system(size: DesignSystem.textLg, weight: .semibold))
                            .foregroundColor(.white)
                        Text("Erhöht Ertrag um bis zu 30%")
                            .font(.system(size: DesignSystem.textSm))
                            .foregroundColor(.nuiSecondaryText)
                    }
                    Spacer()
                    Toggle("", isOn: $co2Enabled)
                        .tint(Color.brandGreen)
                }
                .padding(16)
            }
        }
    }

    private var prioritySelection: some View {
        VStack(spacing: 12) {
            Text("Was ist dir wichtig? (Mehrfachauswahl)")
                .font(.system(size: DesignSystem.textMd))
                .foregroundColor(.nuiSecondaryText)
                .frame(maxWidth: .infinity, alignment: .leading)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(GrowPriority.allCases, id: \.self) { priority in
                    Button(action: {
                        Haptics.selection()
                        if selectedPriorities.contains(priority) {
                            selectedPriorities.removeAll { $0 == priority }
                        } else {
                            selectedPriorities.append(priority)
                        }
                    }) {
                        Text(priority.name)
                            .font(.system(size: DesignSystem.textSm, weight: .medium))
                            .foregroundColor(selectedPriorities.contains(priority) ? .white : .nuiSecondaryText)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 12)
                            .frame(maxWidth: .infinity)
                            .background(selectedPriorities.contains(priority) ? Color.brandGreen.opacity(0.2) : Color.nuiCard)
                            .cornerRadius(DesignSystem.radiusSm)
                            .overlay(
                                RoundedRectangle(cornerRadius: DesignSystem.radiusSm)
                                    .stroke(selectedPriorities.contains(priority) ? Color.brandGreen : Color.nuiBorder, lineWidth: 1)
                            )
                    }
                }
            }
        }
    }

    private var nameInput: some View {
        VStack(spacing: 12) {
            Text("Wie heißt du? (Optional)")
                .font(.system(size: DesignSystem.textMd))
                .foregroundColor(.nuiSecondaryText)
                .frame(maxWidth: .infinity, alignment: .leading)

            TextField("Dein Name...", text: $growerName)
                .textFieldStyle(.plain)
                .padding(16)
                .background(Color.nuiCard)
                .cornerRadius(DesignSystem.radiusMd)
                .overlay(
                    RoundedRectangle(cornerRadius: DesignSystem.radiusMd)
                        .stroke(Color.nuiBorder, lineWidth: 1)
                )
                .foregroundColor(.white)
        }
    }

    private var confirmView: some View {
        VStack(spacing: 16) {
            NuiSectionHeader("Dein Setup", icon: "📋")

            NuiCard {
                VStack(alignment: .leading, spacing: 12) {
                    confirmRow("Ziel", selectedGoal.name)
                    confirmRow("Art", selectedGrowType.name)
                    confirmRow("Erfahrung", selectedExperience.name)
                    confirmRow("Genetik", selectedGenetics.name)
                    if !strainName.isEmpty { confirmRow("Sorte", strainName) }
                    confirmRow("Vermehrung", selectedPropagation.name)
                    confirmRow("Licht", selectedLight.name)
                    confirmRow("Substrat", selectedSubstrate.name)
                    confirmRow("Topf", "\(Int(potSize))L")
                    confirmRow("Umgebung", selectedEnvironment.name)
                    confirmRow("CO₂", co2Enabled ? "Ja" : "Nein")
                    if !selectedPriorities.isEmpty {
                        confirmRow("Prioritäten", selectedPriorities.map(\.name).joined(separator: ", "))
                    }
                    if !growerName.isEmpty { confirmRow("Name", growerName) }
                }
                .padding(16)
            }
        }
    }

    // MARK: - Navigation

    private var wizardNavigation: some View {
        HStack(spacing: 12) {
            if currentStep > 0 {
                NuiButton(title: "Zurück", style: .secondary) {
                    withAnimation { currentStep -= 1 }
                }
            }

            NuiButton(title: currentStep == totalSteps - 1 ? "Los geht's!" : "Weiter") {
                if currentStep == totalSteps - 1 {
                    finishWizard()
                } else {
                    withAnimation { currentStep += 1 }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
        .background(Color.nuiBg)
    }

    // MARK: - Helpers

    private var stepTitle: String {
        switch currentStep {
        case 0: return "Willkommen!"
        case 1: return "Anbau-Art"
        case 2: return "Erfahrung"
        case 3: return "Genetik-Typ"
        case 4: return "Sorte"
        case 5: return "Vermehrung"
        case 6: return "Beleuchtung"
        case 7: return "Substrat"
        case 8: return "Topfgröße"
        case 9: return "Umgebung"
        case 10: return "CO₂"
        case 11: return "Prioritäten"
        case 12: return "Dein Name"
        case 13: return "Zusammenfassung"
        default: return ""
        }
    }

    private func goalIcon(_ goal: GrowGoal) -> String {
        switch goal {
        case .A: return "📈"
        case .B: return "💎"
        case .C: return "⚖️"
        }
    }

    private func confirmRow(_ label: String, _ value: String) -> some View {
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

    private func finishWizard() {
        state.profile.goal = selectedGoal
        state.profile.growType = selectedGrowType
        state.profile.experience = selectedExperience
        state.profile.geneticsType = selectedGenetics
        state.profile.strainName = strainName
        state.profile.propagation = selectedPropagation
        state.profile.lightType = selectedLight
        state.profile.substrate = selectedSubstrate
        state.profile.potSize = potSize
        state.profile.indoor = selectedEnvironment
        state.profile.co2 = co2Enabled
        state.profile.priorities = selectedPriorities

        if !growerName.isEmpty {
            state.profile.location = growerName
        }

        Haptics.success()
        state.completeWizard()
    }

    private func skipWizard() {
        Haptics.light()
        state.completeWizard()
    }
}
