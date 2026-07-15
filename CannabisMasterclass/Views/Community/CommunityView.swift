import SwiftUI

struct CommunityView: View {
    @EnvironmentObject var state: AppState
    @State private var filter = CommunityFilter()
    @State private var showSubmitSheet = false
    @State private var searchText: String = ""

    var body: some View {
        NavigationView {
            ZStack {
                Color.nuiBg.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {
                        filterSection
                        profileList
                    }
                    .padding(16)
                }

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: { showSubmitSheet = true }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 56))
                                .foregroundColor(Color.brandGreen)
                                .shadow(color: Color.brandGreen.opacity(0.4), radius: 8, x: 0, y: 4)
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationTitle("Community")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: "Sorte, Breeder, Notizen suchen...")
            .onChange(of: searchText) { newValue in
                filter.searchQuery = newValue
            }
            .sheet(isPresented: $showSubmitSheet) {
                SubmitProfileView(isPresented: $showSubmitSheet)
            }
            .preferredColorScheme(.dark)
        }
    }

    // MARK: - Filter

    private var filterSection: some View {
        VStack(spacing: 12) {
            // Sort picker
            HStack(spacing: 8) {
                Text("Sortieren:")
                    .font(.system(size: DesignSystem.textSm))
                    .foregroundColor(.nuiSecondaryText)
                ForEach(CommunityFilter.SortOption.allCases, id: \.self) { option in
                    Button(action: {
                        Haptics.selection()
                        filter.sortBy = option
                    }) {
                        Text(option.rawValue)
                            .font(.system(size: DesignSystem.textSm, weight: .medium))
                            .foregroundColor(filter.sortBy == option ? .white : .nuiSecondaryText)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(filter.sortBy == option ? Color.brandGreen : Color.nuiCard)
                            .cornerRadius(DesignSystem.radiusFull)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            // Filter pills
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    filterPill("Goal: Alle", isActive: filter.filterGoal == nil) {
                        filter.filterGoal = nil
                    }
                    ForEach(["A: Ertrag", "B: Harz", "C: Balance"], id: \.self) { goal in
                        filterPill(goal, isActive: filter.filterGoal == goal) {
                            filter.filterGoal = filter.filterGoal == goal ? nil : goal
                        }
                    }
                }
            }
        }
    }

    private func filterPill(_ text: String, isActive: Bool, action: @escaping () -> Void) -> some View {
        Button(action: {
            Haptics.selection()
            action()
        }) {
            Text(text)
                .font(.system(size: DesignSystem.textXs, weight: .medium))
                .foregroundColor(isActive ? .white : .nuiSecondaryText)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(isActive ? Color.brandPurple : Color.nuiCard)
                .cornerRadius(DesignSystem.radiusFull)
        }
    }

    // MARK: - Profile List

    private var profileList: some View {
        let profiles = state.filteredCommunityProfiles(filter: filter)

        return LazyVStack(spacing: 10) {
            if profiles.isEmpty {
                NuiEmptyState(icon: "👥", title: "Keine Einträge", message: "Sei der Erste, der sein Setup teilt!")
            }

            ForEach(profiles) { profile in
                profileCard(profile)
            }
        }
    }

    private func profileCard(_ profile: CommunityProfile) -> some View {
        NuiCard {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(profile.strain)
                            .font(.system(size: DesignSystem.textLg, weight: .bold))
                            .foregroundColor(.white)
                        Text(profile.breeder)
                            .font(.system(size: DesignSystem.textSm))
                            .foregroundColor(.nuiSecondaryText)
                    }
                    Spacer()
                    NuiBadge(profile.goal, color: Color.brandGreen)
                }

                HStack(spacing: 6) {
                    NuiBadge(profile.growType, color: Color.brandPurple)
                    NuiBadge(profile.substrate, color: Color.brandOrange)
                    NuiBadge(profile.lightType, color: Color.blue)
                }

                if let weight = profile.dryWeight {
                    HStack(spacing: 12) {
                        HStack(spacing: 4) {
                            Image(systemName: "scalemass")
                                .font(.system(size: 12))
                            Text("\(weight)g trocken")
                                .font(.system(size: DesignSystem.textSm, weight: .medium))
                        }
                        .foregroundColor(.white)

                        if let thc = profile.thc {
                            HStack(spacing: 4) {
                                Image(systemName: "percent")
                                    .font(.system(size: 12))
                                Text("\(thc, specifier: "%.1f")% THC")
                                    .font(.system(size: DesignSystem.textSm, weight: .medium))
                            }
                            .foregroundColor(.white)
                        }
                    }
                }

                if !profile.notes.isEmpty {
                    Text(profile.notes)
                        .font(.system(size: DesignSystem.textSm))
                        .foregroundColor(.nuiSecondaryText)
                        .lineLimit(3)
                }

                HStack {
                    Text("Von \(profile.author)")
                        .font(.system(size: DesignSystem.textXs))
                        .foregroundColor(.nuiSecondaryText)
                    Spacer()
                    Button(action: {
                        Haptics.light()
                        state.likeCommunityProfile(id: profile.id)
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 12))
                            Text("\(profile.likes)")
                                .font(.system(size: DesignSystem.textSm, weight: .medium))
                        }
                        .foregroundColor(Color.brandRed)
                    }
                }
            }
            .padding(14)
        }
    }
}

// MARK: - Submit Profile View

struct SubmitProfileView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var state: AppState
    @State private var strain = ""
    @State private var breeder = ""
    @State private var goal = "C: Balance"
    @State private var growType = "Photoperiode"
    @State private var substrate = "Erde"
    @State private var lightType = "LED"
    @State private var environment = "Indoor"
    @State private var dryWeight = ""
    @State private var thc = ""
    @State private var notes = ""
    @State private var author = ""

    var body: some View {
        NavigationView {
            ZStack {
                Color.nuiBg.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {
                        inputField("Sorte*", text: $strain, placeholder: "z.B. Northern Lights")
                        inputField("Breeder", text: $breeder, placeholder: "z.B. Royal Queen Seeds")

                        optionPicker("Goal", selection: $goal, options: ["A: Ertrag", "B: Harz", "C: Balance"])
                        optionPicker("Anbauart", selection: $growType, options: ["Photoperiode", "Autoflower"])
                        optionPicker("Substrat", selection: $substrate, options: ["Erde", "Coco", "Hydro", "Living Soil"])
                        optionPicker("Licht", selection: $lightType, options: ["LED", "LED + UV/IR", "HPS", "Sonnenlicht"])
                        optionPicker("Umgebung", selection: $environment, options: ["Indoor", "Greenhouse", "Outdoor"])

                        inputField("Trockenertrag (g)", text: $dryWeight, placeholder: "z.B. 150")
                        inputField("THC (%)", text: $thc, placeholder: "z.B. 21")
                        inputField("Notizen", text: $notes, placeholder: "Erfahrungen, Tipps...", isMultiline: true)
                        inputField("Dein Name*", text: $author, placeholder: "Dein Username")
                    }
                    .padding(16)
                }
            }
            .navigationTitle("Setup teilen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") { isPresented = false }
                        .foregroundColor(.nuiSecondaryText)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Teilen") {
                        submit()
                    }
                    .foregroundColor(Color.brandGreen)
                    .disabled(strain.isEmpty || author.isEmpty)
                }
            }
            .preferredColorScheme(.dark)
        }
    }

    private func inputField(_ label: String, text: Binding<String>, placeholder: String, isMultiline: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.system(size: DesignSystem.textSm, weight: .medium))
                .foregroundColor(.white)

            if isMultiline {
                TextEditor(text: text)
                    .scrollContentBackground(.hidden)
                    .font(.system(size: DesignSystem.textMd))
                    .foregroundColor(.white)
                    .frame(minHeight: 80)
                    .padding(12)
                    .background(Color.nuiCard)
                    .cornerRadius(DesignSystem.radiusMd)
            } else {
                TextField(placeholder, text: text)
                    .textFieldStyle(.plain)
                    .padding(12)
                    .background(Color.nuiCard)
                    .cornerRadius(DesignSystem.radiusMd)
                    .foregroundColor(.white)
            }
        }
    }

    private func optionPicker(_ label: String, selection: Binding<String>, options: [String]) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.system(size: DesignSystem.textSm, weight: .medium))
                .foregroundColor(.white)
            HStack(spacing: 6) {
                ForEach(options, id: \.self) { option in
                    Button(action: {
                        Haptics.selection()
                        selection.wrappedValue = option
                    }) {
                        Text(option)
                            .font(.system(size: DesignSystem.textXs, weight: .medium))
                            .foregroundColor(selection.wrappedValue == option ? .white : .nuiSecondaryText)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(selection.wrappedValue == option ? Color.brandGreen : Color.nuiCard)
                            .cornerRadius(DesignSystem.radiusSm)
                    }
                }
            }
        }
    }

    private func submit() {
        let profile = CommunityProfile(
            strain: strain, breeder: breeder, goal: goal,
            growType: growType, substrate: substrate, lightType: lightType,
            environment: environment,
            dryWeight: Int(dryWeight),
            thc: Double(thc),
            notes: notes, author: author
        )
        state.addCommunityProfile(profile)
        Haptics.success()
        isPresented = false
    }
}
