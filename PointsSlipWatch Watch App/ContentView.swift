import SwiftUI

struct ContentView: View {
    @State private var counts: [Int] = Array(repeating: 0, count: 20)
    
    let labels: [String] = [
        "Pages Read (10/page)",
        "Videos/Lectures (5/min)",
        "Pass Theory Checkout (3/page)",
        "Give Theory Checkout (3/page)",
        "Finding MUs (5/word)",
        "Checkout on Demo (3 each)",
        "Definitions/Derivations (3 each)",
        "Word Clearing (150/hr)",
        "Theory Coaching (5/line)",
        "Drill <15 min (40)",
        "Verbatim Learning (10/line)",
        "Drill >15 min (150/hr)",
        "Drill >1 hr (500)",
        "Checksheet Req (5)",
        "Self-Originated (3)",
        "Clay Demo (50)",
        "Essays/Charts (10)",
        "Course Completions (2000)",
        "Days ahead of target (2000)",
        "Days overdue (-200)"
    ]
    
    let pointsPerUnit: [Int] = [
        10, 5, 3, 3, 5, 3, 3, 150, 5, 40,
        10, 150, 500, 5, 3, 50, 10, 2000, 2000, -200
    ]
    
    init() {
        if let saved = UserDefaults.standard.array(forKey: "counts") as? [Int], saved.count == 20 {
            _counts = State(initialValue: saved)
        }
    }
    
    func saveCounts() {
        UserDefaults.standard.set(counts, forKey: "counts")
    }
    
    func resetCounts() {
        counts = Array(repeating: 0, count: 20)
        saveCounts()
    }
    
    var pagesReadBonus: Int {
        let pages = counts.first ?? 0
        return (pages / 50) * 25
    }
    
    var totalPoints: Int {
        zip(counts, pointsPerUnit).map { $0 * $1 }.reduce(0, +) + pagesReadBonus
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 8) {
                    ForEach(labels.indices, id: \.self) { index in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(labels[index])
                                    .font(.caption2)
                                if index == 0 {
                                    Text("Bonus: +25 per 50 pages")
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                }
                            }
                            Spacer()
                            HStack(spacing: 4) {
                                Button {
                                    if counts[index] > 0 {
                                        counts[index] -= 1
                                        saveCounts()
                                    }
                                } label: {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(.red)
                                        .font(.title3)
                                }
                                Text("\(counts[index])")
                                    .frame(minWidth: 30)
                                Button {
                                    counts[index] += 1
                                    saveCounts()
                                } label: {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(.green)
                                        .font(.title3)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    
                    Divider()
                    
                    Button(role: .destructive) {
                        resetCounts()
                    } label: {
                        Label("Reset All", systemImage: "arrow.counterclockwise")
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Points: \(totalPoints)")
        }
    }
}

#Preview {
    ContentView()
}

