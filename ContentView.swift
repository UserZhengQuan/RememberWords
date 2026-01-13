import SwiftUI

struct WordItem: Identifiable, Equatable {
    let id = UUID()
    var term: String
    var isRemembered: Bool = false
}

struct ContentView: View {
    @State private var newWord = ""
    @State private var words: [WordItem] = []

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                HStack {
                    TextField("Add a word", text: $newWord)
                        .textFieldStyle(.roundedBorder)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)

                    Button("Add") {
                        addWord()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(newWord.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding(.horizontal)

                if words.isEmpty {
                    ContentUnavailableView(
                        "No words yet",
                        systemImage: "text.book.closed",
                        description: Text("Add a word you want to remember.")
                    )
                    .padding()
                } else {
                    List {
                        ForEach(words) { word in
                            HStack {
                                Text(word.term)
                                    .strikethrough(word.isRemembered)
                                    .foregroundColor(word.isRemembered ? .secondary : .primary)

                                Spacer()

                                Image(systemName: word.isRemembered ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(word.isRemembered ? .green : .gray)
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                toggleRemembered(for: word)
                            }
                        }
                        .onDelete(perform: deleteWords)
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Remember Words")
            .toolbar {
                if !words.isEmpty {
                    EditButton()
                }
            }
        }
    }

    private func addWord() {
        let trimmed = newWord.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        words.insert(WordItem(term: trimmed), at: 0)
        newWord = ""
    }

    private func toggleRemembered(for word: WordItem) {
        guard let index = words.firstIndex(of: word) else { return }
        words[index].isRemembered.toggle()
    }

    private func deleteWords(at offsets: IndexSet) {
        words.remove(atOffsets: offsets)
    }
}

#Preview {
    ContentView()
}
