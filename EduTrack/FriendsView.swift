//
//  FriendsView.swift
//  DP4
//
//  Created by Cynthia Rosales on 10/22/24.
//
import SwiftUI

struct Friend: Identifiable {
    let id = UUID()
    let name: String
    var isSelected: Bool
}

struct FriendsView: View {
    @State private var friends = [
        // List of friends
        Friend(name: "Jane", isSelected: false),
        Friend(name: "Cynthia", isSelected: false),
        Friend(name: "Lydia", isSelected: false),
        Friend(name: "Muhammad", isSelected: false)
    ]
    
    // ChallengesView
    @State private var showChallengesView = false
    @State private var showAlert = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
             
                // Main Title
                Text("Friends")
                    .font(.system(size: 36, weight: .semibold, design: .default))
                    .padding(.top, 30)
                Text("Compete with friends and try out new challenges!")
                    .font(.system(size: 14, design: .default))
                    .padding(.top, -10)
                
                    .toolbar {
                        // Points
                        ToolbarItem(placement: .navigationBarLeading) {
                                HStack {
                                    Image(systemName: "dollarsign.circle")
                                        .imageScale(.large)
                                        .font(.system(size: 24))
                                        .foregroundColor(.black)
                                        .padding(.top, 5)
                                    
                                    Text("07000")
                                        .font(.custom("DS-Digital", size: 24))
                                        .foregroundColor(.black)
                                    Text("pts")
                                        .font(.system(size: 18))
                                        .foregroundColor(.black)
                                }
                        }
                        
                        // Settings
                        ToolbarItem(placement: .navigationBarTrailing) {
                            NavigationLink(destination: SettingView()) {
                                VStack(spacing: 2) {
                                    Image(systemName: "gearshape")
                                        .imageScale(.large)
                                        .font(.system(size: 24))
                                        .foregroundColor(.black)
                                        .padding(.top, 25)
                                    Text("Settings")
                                        .font(.system(size: 14))
                                        .foregroundColor(.black)
                                        .padding(.bottom, 5)
                                }
                            }
                        }
                    }
                
                List($friends) { $friend in
                    HStack {
                        Text(friend.name)
                            .padding(.vertical, 10)
                        Spacer()
                        Image(systemName: friend.isSelected ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(friend.isSelected ? .green : .gray)
                            .onTapGesture {
                                if friend.isSelected {
                                    friend.isSelected = false
                                } else {
                                    for index in friends.indices {
                                        friends[index].isSelected = false
                                    }
                                    friend.isSelected = true
                                }
                            }
                    }
                    .listRowBackground(Color.white)
                }
                .listStyle(InsetGroupedListStyle())
                .scrollContentBackground(.hidden)
                
                Button(action: {
                    if friends.contains(where: { $0.isSelected}) {
                        // Show challenge page if 1 friend is selected
                        showChallengesView = true
                    }
                    else {
                        // Ask user to confirm when no one is selected
                        showAlert = true
                    }
                    
                }) {
                    Text("Go to Challenges")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding()
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("No Friend Selected"),
                        message: Text("Are you sure you want to proceed?"),
                        primaryButton: .default(Text("Confirm"), action: {
                            showChallengesView = true
                        }),
                    secondaryButton: .cancel(Text("No"))
                    )
                }
                .sheet(isPresented: $showChallengesView) {
                    ChallengesView()
                }
            }
        }
    }
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}
