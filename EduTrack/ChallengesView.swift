// Challenges UI for Application - Muhammad Khan
import SwiftUI

// Define a model for each challenge
struct Challenge: Identifiable {
    let id = UUID()
    let title: String
    var description: String
    var duration: String
    var points: Int
    var status: String
}

struct ChallengeItem: Identifiable {
    let id = UUID()
    let title: String
    let label: String
    let points: Int
}

let CompetitiveChallenges = [
    Challenge(
        title: "Challenge with Lydia", description: "Limit screen time to 3 hours per day",
        duration: "Weekly", points: 50, status: "In Progress"),
    Challenge(
        title: "Challenge with Muhammad", description: "No social media usage for 12 hours",
        duration: "Daily", points: 100, status: "Pending"),
    Challenge(
        title: "Challenge with Jane",
        description: "Limit social media apps under 12 hours per week",
        duration: "Monthly", points: 150, status: "In Progress"),
]

struct ChallengeSelectionView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var challenges = [
        ChallengeItem(title: "Use educational apps for over 12 hours for a week", label: "Weekly", points: 300),
        ChallengeItem(title: "Limit social media apps to 1 hour per day", label: "Weekly", points: 100),
        ChallengeItem(title: "Do not use any apps for 5 hours", label: "Daily", points: 150),
        ChallengeItem(title: "Limit message app to 3 hours per day", label: "Monthly", points: 500)
    ]
    
    @State private var selectedChallenge: ChallengeItem? = nil
    var selectedFriend: String
    var onConfirm: (ChallengeItem) -> Void

    var body: some View {
        VStack {
            NavigationView {
                List($challenges) { $challenge in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(challenge.title)
                                .font(.body)
                                .padding(.vertical, 5)
                            Text(challenge.label)
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                        Spacer()
                        Text("\(challenge.points) pts")
                            .font(.caption)
                            .padding(6)
                            .background(Color.yellow)
                            .cornerRadius(8)
                        Image(systemName: selectedChallenge?.id == challenge.id ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(selectedChallenge?.id == challenge.id ? .blue : .gray)
                            .onTapGesture {
                                if selectedChallenge?.id == challenge.id {
                                    selectedChallenge = nil
                                } else {
                                    selectedChallenge = challenge
                                }
                            }
                    }
                    .contentShape(Rectangle())
                    .listRowBackground(Color.white)
                }
                .navigationBarTitle("Select a Challenge", displayMode: .inline)
                .navigationBarItems(leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                })
            }
            
            Button(action: {
                if let selectedChallenge = selectedChallenge {
                    onConfirm(selectedChallenge)
                }
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Confirm")
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .padding(.bottom, 20)
            .disabled(selectedChallenge == nil)
        }
    }
}

struct ChallengesView: View {
    @Binding var challenges: [Challenge]
    @State private var totalPoints = 7000
    @State private var showChallengeSelection = false
    var selectedFriendName: String 

    var body: some View {
        NavigationView {
            VStack {
                Text("Competitive Challenge")
                    .font(.system(size: 36, weight: .semibold, design: .default))
                    .padding(.top, 30)
                
                HStack {
                    Text("Current Points:")
                        .font(.system(size: 18))
                        .foregroundColor(.black)
                    Text("\(totalPoints)")
                        .font(.custom("DS-Digital", size: 24))
                        .foregroundColor(.black)
                    Spacer()
                }
                .padding()

                List(challenges) { challenge in
                    VStack(spacing: 8) {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(challenge.title)
                                    .font(.system(size: 24, weight: .bold))
                                Text(challenge.description)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("Duration: \(challenge.duration)")
                                    .font(.footnote)
                                    .foregroundColor(.blue)
                            }
                            Spacer()
                            VStack(alignment: .center) {
                                Text("\(challenge.points) pts")
                                    .font(.caption)
                                    .padding(6)
                                    .background(Color.yellow)
                                    .cornerRadius(8)
                                Text(challenge.status)
                                    .font(.caption2)
                                    .padding(6)
                                    .background(statusColor(status: challenge.status))
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 2)
                    }
                    .padding(.vertical, 8)
                    .listRowBackground(Color.clear)
                }
                .scrollContentBackground(.hidden)
                .background(Color.white)

                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showChallengeSelection = true
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                }
                .sheet(isPresented: $showChallengeSelection) {
                    ChallengeSelectionView(selectedFriend: selectedFriendName) { selectedChallenge in
                        addSelectedChallenge(selectedChallenge)
                    }
                }
            }
        }
        .onAppear {
            calculateTotalPoints()
        }
    }

    private func statusColor(status: String) -> Color {
        switch status {
        case "Completed":
            return Color.green
        case "In Progress":
            return Color.orange
        case "Pending":
            return Color.red
        default:
            return Color.gray
        }
    }

    private func addSelectedChallenge(_ challenge: ChallengeItem) {
        let newChallenge = Challenge(
            title: "Challenge with \(selectedFriendName)",
            description: challenge.title,
            duration: challenge.label,
            points: challenge.points,
            status: "Pending"
        )
        challenges.append(newChallenge)
    }

    private func calculateTotalPoints() {
        totalPoints = 7000 + challenges.filter { $0.status == "Completed" }.reduce(0) { $0 + $1.points }
    }
}


