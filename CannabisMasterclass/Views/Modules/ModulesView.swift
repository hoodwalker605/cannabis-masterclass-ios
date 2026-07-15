import SwiftUI

struct ModulesView: View {
    @EnvironmentObject var state: AppState
    @State private var selectedCategory: String = "Alle"
    @State private var searchText: String = ""

    let categories = ["Alle", "Grundlagen", "Biologie", "Wirkstoffe", "Düngung", "Substrate", "Technik", "Klima", "Ernte"]

    var filteredModules: [Module] {
        ModuleData.modules.filter { module in
            let matchesCategory = selectedCategory == "Alle" || module.category == selectedCategory
            let matchesSearch = searchText.isEmpty || module.title.localizedCaseInsensitiveContains(searchText)
            return matchesCategory && matchesSearch
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color.nuiBg.ignoresSafeArea()

                VStack(spacing: 0) {
                    categoryPicker
                        .padding(.top, 8)

                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredModules) { module in
                                NavigationLink(destination: ModuleDetailView(module: module)) {
                                    moduleCard(module)
                                }
                            }
                        }
                        .padding(16)
                    }
                }
            }
            .navigationTitle("Lernmodule")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: "Module suchen...")
            .preferredColorScheme(.dark)
        }
    }

    // MARK: - Category Picker

    private var categoryPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(categories, id: \.self) { category in
                    Button(action: {
                        Haptics.selection()
                        selectedCategory = category
                    }) {
                        Text(category)
                            .font(.system(size: DesignSystem.textSm, weight: .medium))
                            .foregroundColor(selectedCategory == category ? .white : .nuiSecondaryText)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(selectedCategory == category ? Color.brandGreen : Color.nuiCard)
                            .cornerRadius(DesignSystem.radiusFull)
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }

    // MARK: - Module Card

    private func moduleCard(_ module: Module) -> some View {
        let progress = state.moduleProgressPercent(moduleId: module.id)

        return NuiCard {
            HStack(spacing: 14) {
                Text(module.icon)
                    .font(.system(size: 32))

                VStack(alignment: .leading, spacing: 6) {
                    Text(module.title)
                        .font(.system(size: DesignSystem.textMd, weight: .semibold))
                        .foregroundColor(.white)
                        .lineLimit(2)

                    Text(module.description)
                        .font(.system(size: DesignSystem.textSm))
                        .foregroundColor(.nuiSecondaryText)
                        .lineLimit(2)

                    HStack(spacing: 8) {
                        NuiBadge(module.category, color: Color.brandPurple)
                        NuiBadge("\(module.readTime)", color: Color.brandGreen)
                        HStack(spacing: 2) {
                            ForEach(1...module.difficulty, id: \.self) { _ in
                                Image(systemName: "star.fill")
                                    .font(.system(size: 8))
                                    .foregroundColor(Color.brandOrange)
                            }
                        }
                    }
                }

                Spacer()

                VStack(spacing: 4) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.nuiSecondaryText)
                        .font(.system(size: 14))
                    if progress > 0 {
                        Text("\(Int(progress * 100))%")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(Color.brandGreen)
                    }
                }
            }
            .padding(14)
        }
    }
}

// MARK: - Module Detail View

struct ModuleDetailView: View {
    let module: Module
    @EnvironmentObject var state: AppState
    @State private var showQuiz: Bool = false
    @State private var quizAnswers: [Int: Int] = [:]
    @State private var quizSubmitted: Bool = false

    var body: some View {
        ZStack {
            Color.nuiBg.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 16) {
                    header
                    sections
                    if let quiz = module.quiz, !quiz.isEmpty {
                        quizSection(quiz)
                    }
                }
                .padding(16)
            }
        }
        .navigationTitle(module.title)
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
    }

    private var header: some View {
        VStack(spacing: 12) {
            Text(module.icon)
                .font(.system(size: 48))
            Text(module.title)
                .font(.system(size: DesignSystem.textXl, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            Text(module.description)
                .font(.system(size: DesignSystem.textMd))
                .foregroundColor(.nuiSecondaryText)
                .multilineTextAlignment(.center)

            HStack(spacing: 8) {
                NuiBadge(module.category, color: Color.brandPurple)
                NuiBadge(module.readTime, color: Color.brandGreen)
                HStack(spacing: 2) {
                    ForEach(1...5, id: \.self) { i in
                        Image(systemName: i <= module.difficulty ? "star.fill" : "star")
                            .font(.system(size: 10))
                            .foregroundColor(i <= module.difficulty ? Color.brandOrange : Color.nuiBorder)
                    }
                }
            }
        }
    }

    private var sections: some View {
        ForEach(module.sections) { section in
            sectionCard(section)
        }
    }

    private func sectionCard(_ section: ModuleSection) -> some View {
        NuiCard {
            VStack(alignment: .leading, spacing: 10) {
                Text(section.title)
                    .font(.system(size: DesignSystem.textLg, weight: .bold))
                    .foregroundColor(.white)

                switch section.type {
                case .text, .highlighted:
                    Text(section.content)
                        .font(.system(size: DesignSystem.textMd))
                        .foregroundColor(.white)
                case .bulletList:
                    ForEach(section.items ?? [], id: \.self) { item in
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "circle.fill")
                                .font(.system(size: 6))
                                .foregroundColor(Color.brandGreen)
                                .padding(.top, 6)
                            Text(item)
                                .font(.system(size: DesignSystem.textMd))
                                .foregroundColor(.white)
                        }
                    }
                case .formula:
                    Text(section.content)
                        .font(.system(size: DesignSystem.textMd, design: .monospaced))
                        .foregroundColor(Color.brandGreen)
                        .padding(12)
                        .background(Color.brandGreen.opacity(0.1))
                        .cornerRadius(DesignSystem.radiusSm)
                case .tip:
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "lightbulb.fill")
                            .foregroundColor(Color.brandOrange)
                        Text(section.content)
                            .font(.system(size: DesignSystem.textMd))
                            .foregroundColor(Color.brandOrange)
                    }
                    .padding(12)
                    .background(Color.brandOrange.opacity(0.1))
                    .cornerRadius(DesignSystem.radiusSm)
                }

                if let items = section.items, section.type == .text {
                    ForEach(items, id: \.self) { item in
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "circle.fill")
                                .font(.system(size: 6))
                                .foregroundColor(Color.brandGreen)
                                .padding(.top, 6)
                            Text(item)
                                .font(.system(size: DesignSystem.textMd))
                                .foregroundColor(.white)
                        }
                    }
                }

                // Progress toggle
                if let index = module.sections.firstIndex(where: { $0.id == section.id }) {
                    Button(action: {
                        Haptics.light()
                        state.toggleModuleProgress(moduleId: module.id, sectionIndex: index)
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: state.moduleProgress[module.id]?[index] == true ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(state.moduleProgress[module.id]?[index] == true ? Color.brandGreen : .nuiSecondaryText)
                            Text(state.moduleProgress[module.id]?[index] == true ? "Gelesen" : "Als gelesen markieren")
                                .font(.system(size: DesignSystem.textSm))
                                .foregroundColor(.nuiSecondaryText)
                        }
                    }
                }
            }
            .padding(14)
        }
    }

    private func quizSection(_ quiz: [QuizQuestion]) -> some View {
        NuiCard {
            VStack(alignment: .leading, spacing: 14) {
                NuiSectionHeader("Quiz", icon: "❓")

                ForEach(Array(quiz.enumerated()), id: \.element.id) { qi, question in
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(qi + 1). \(question.question)")
                            .font(.system(size: DesignSystem.textMd, weight: .medium))
                            .foregroundColor(.white)

                        ForEach(Array(question.options.enumerated()), id: \.offset) { oi, option in
                            Button(action: {
                                Haptics.selection()
                                quizAnswers[qi] = oi
                            }) {
                                HStack(spacing: 10) {
                                    Circle()
                                        .fill(selectedAnswer(qi, option: oi))
                                        .frame(width: 18, height: 18)
                                    Text(option)
                                        .font(.system(size: DesignSystem.textSm))
                                        .foregroundColor(.white)
                                    Spacer()
                                    if quizSubmitted {
                                        if oi == question.correctIndex {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(.green)
                                        } else if quizAnswers[qi] == oi {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.red)
                                        }
                                    }
                                }
                                .padding(10)
                                .background(quizSubmitted && oi == question.correctIndex ? Color.green.opacity(0.1) : Color.nuiCardElevated)
                                .cornerRadius(DesignSystem.radiusSm)
                            }
                        }

                        if quizSubmitted {
                            HStack(spacing: 6) {
                                Image(systemName: "info.circle.fill")
                                    .foregroundColor(Color.brandPurple)
                                Text(question.explanation)
                                    .font(.system(size: DesignSystem.textSm))
                                    .foregroundColor(Color.brandPurple)
                            }
                            .padding(10)
                            .background(Color.brandPurple.opacity(0.1))
                            .cornerRadius(DesignSystem.radiusSm)
                        }
                    }
                    if qi < quiz.count - 1 { Divider().background(Color.nuiBorder) }
                }

                NuiButton(title: quizSubmitted ? "Nochmal" : "Quiz abschließen") {
                    if quizSubmitted {
                        quizAnswers = [:]
                        quizSubmitted = false
                    } else {
                        var score = 0
                        for (qi, question) in quiz.enumerated() {
                            if quizAnswers[qi] == question.correctIndex { score += 1 }
                        }
                        state.saveQuizScore(moduleId: module.id, score: score)
                        quizSubmitted = true
                        Haptics.success()
                    }
                }
            }
            .padding(14)
        }
    }

    private func selectedAnswer(_ questionIndex: Int, option: Int) -> Color {
        guard quizAnswers[questionIndex] == option else { return .clear }
        return quizSubmitted ? (option == module.quiz?[questionIndex].correctIndex ? .green : .red) : Color.brandGreen
    }
}
