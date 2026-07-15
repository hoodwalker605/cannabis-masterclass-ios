import SwiftUI
import PhotosUI

struct DiagnosisView: View {
    @EnvironmentObject var state: AppState
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker = false
    @State private var searchQuery: String = ""
    @State private var selectedCategory: String = "Alle"
    @State private var selectedSymptom: SymptomEntry? = nil

    let categories = ["Alle", "Nährstoff", "Wasser", "Umwelt", "Schädling", "Pilz", "Genetik", "Wachstum", "Licht", "Keimung", "Ernte"]

    var filteredSymptoms: [SymptomEntry] {
        SymptomData.symptoms.filter { symptom in
            let matchesCategory = selectedCategory == "Alle" || symptom.category == selectedCategory
            let matchesSearch = searchQuery.isEmpty || symptom.name.localizedCaseInsensitiveContains(searchQuery)
            return matchesCategory && matchesSearch
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color.nuiBg.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {
                        imageUploadSection
                        categoryPicker
                        symptomList
                    }
                    .padding(16)
                }

                if let symptom = selectedSymptom {
                    symptomDetailOverlay(symptom)
                }
            }
            .navigationTitle("Diagnose")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $selectedImage)
            }
            .preferredColorScheme(.dark)
        }
    }

    // MARK: - Image Upload

    private var imageUploadSection: some View {
        NuiCard {
            VStack(spacing: 12) {
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .clipped()
                        .cornerRadius(DesignSystem.radiusMd)
                } else {
                    Button(action: { showImagePicker = true }) {
                        VStack(spacing: 12) {
                            Image(systemName: "camera.fill")
                                .font(.system(size: 32))
                                .foregroundColor(Color.brandGreen)
                            Text("Foto aufnehmen oder auswählen")
                                .font(.system(size: DesignSystem.textMd))
                                .foregroundColor(.white)
                            Text("Optional — Symptome auch ohne Foto suchen")
                                .font(.system(size: DesignSystem.textSm))
                                .foregroundColor(.nuiSecondaryText)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 32)
                        .background(Color.nuiCardElevated)
                        .cornerRadius(DesignSystem.radiusMd)
                    }
                }
            }
            .padding(14)
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
        }
    }

    // MARK: - Symptom List

    private var symptomList: some View {
        LazyVStack(spacing: 8) {
            ForEach(filteredSymptoms) { symptom in
                Button(action: {
                    Haptics.light()
                    selectedSymptom = symptom
                }) {
                    NuiCard {
                        HStack(spacing: 14) {
                            Text(symptom.icon)
                                .font(.system(size: 28))
                            VStack(alignment: .leading, spacing: 4) {
                                Text(symptom.name)
                                    .font(.system(size: DesignSystem.textMd, weight: .semibold))
                                    .foregroundColor(.white)
                                Text(symptom.category)
                                    .font(.system(size: DesignSystem.textSm))
                                    .foregroundColor(.nuiSecondaryText)
                            }
                            Spacer()
                            severityBadge(symptom.severity)
                            Image(systemName: "chevron.right")
                                .foregroundColor(.nuiSecondaryText)
                                .font(.system(size: 12))
                        }
                        .padding(12)
                    }
                }
            }
        }
    }

    private func severityBadge(_ severity: String) -> some View {
        let color: Color
        let text: String
        switch severity {
        case "low":
            color = Color.brandGreen
            text = "Gering"
        case "medium":
            color = Color.brandOrange
            text = "Mittel"
        case "high":
            color = Color.brandRed
            text = "Hoch"
        default:
            color = .gray
            text = "?"
        }
        return NuiBadge(text, color: color)
    }

    // MARK: - Symptom Detail Overlay

    private func symptomDetailOverlay(_ symptom: SymptomEntry) -> some View {
        GeometryReader { geo in
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture { selectedSymptom = nil }

            VStack {
                Spacer()
                NuiCard {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text(symptom.icon)
                                    .font(.system(size: 36))
                                VStack(alignment: .leading) {
                                    Text(symptom.name)
                                        .font(.system(size: DesignSystem.textXl, weight: .bold))
                                        .foregroundColor(.white)
                                    Text(symptom.category)
                                        .font(.system(size: DesignSystem.textSm))
                                        .foregroundColor(.nuiSecondaryText)
                                }
                                Spacer()
                                Button(action: { selectedSymptom = nil }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(.nuiSecondaryText)
                                }
                            }

                            Divider().background(Color.nuiBorder)

                            // Causes
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Ursachen")
                                    .font(.system(size: DesignSystem.textMd, weight: .bold))
                                    .foregroundColor(Color.brandRed)
                                ForEach(symptom.causes, id: \.self) { cause in
                                    HStack(alignment: .top, spacing: 8) {
                                        Image(systemName: "exclamationmark.triangle.fill")
                                            .font(.system(size: 12))
                                            .foregroundColor(Color.brandRed)
                                            .padding(.top, 3)
                                        Text(cause)
                                            .font(.system(size: DesignSystem.textMd))
                                            .foregroundColor(.white)
                                    }
                                }
                            }

                            // Fixes
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Lösungen")
                                    .font(.system(size: DesignSystem.textMd, weight: .bold))
                                    .foregroundColor(Color.brandGreen)
                                ForEach(symptom.fixes, id: \.self) { fix in
                                    HStack(alignment: .top, spacing: 8) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.system(size: 12))
                                            .foregroundColor(Color.brandGreen)
                                            .padding(.top, 3)
                                        Text(fix)
                                            .font(.system(size: DesignSystem.textMd))
                                            .foregroundColor(.white)
                                    }
                                }
                            }

                            // Affected areas
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Betroffene Bereiche")
                                    .font(.system(size: DesignSystem.textMd, weight: .bold))
                                    .foregroundColor(Color.brandPurple)
                                HStack {
                                    ForEach(symptom.affectedAreas, id: \.self) { area in
                                        NuiBadge(area, color: Color.brandPurple)
                                    }
                                }
                            }
                        }
                        .padding(16)
                    }
                }
                .frame(maxHeight: geo.size.height * 0.75)
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
        }
    }
}

// MARK: - Image Picker

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.dismiss) var dismiss

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.dismiss()
        }
    }
}
