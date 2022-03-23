//
//  ContentView.swift
//  Pushup Tracker
//
//  Created by Sam Gulinello on 1/22/22.
//

import SwiftUI

struct ContentView: View {
    // Create Day Object
    @ObservedObject var progress = ProgressController()
    @Environment(\.scenePhase) var scenePhase
    
    let notificationManager = NotificationController()
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ZStack{
            Color(red: 35 / 255, green: 39/255, blue: 45/255)
                .ignoresSafeArea()
            VStack {
                VStack{
                    Text("PushUp Tracker")
                        .foregroundColor(Color(.white)).font(.system(.title3)).fontWeight(.bold)
                    HStack {
                        VStack {
                            Text("Current Streak").foregroundColor(Color(.white)).font(.system(.title2))
                            Text(String(progress.currentStreak)).foregroundColor(Color(.white)).font(.system(.title2))
                            Text("Days").foregroundColor(Color(.white)).font(.system(.title2))
                        }.padding()
                        ZStack {
                            Circle()
                                .stroke(lineWidth: 20.0)
                                .opacity(0.3)
                                .foregroundColor(Color.white)
                                .frame(width:140, height: 140)
                            
                            Circle()
                                .trim(from: 0.0, to: CGFloat(min(progress.progress, 1.0)))
                                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                                .foregroundColor(Color.white)
                                .rotationEffect(Angle(degrees: 270.0))
                                .frame(width: 140, height: 140)
                            
                            Text(String(format: "%.0f %%", min(progress.progress, 1.0)*100.0))
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(Color(.white))
                        }.padding()
                    }
                }.padding()
                ZStack {
                    Rectangle()
                        .cornerRadius(35)
                        .foregroundColor(Color(red: 40 / 260, green: 44/255, blue: 45/255))
                    VStack {
                        Text("Progress").foregroundColor(Color(.white)).font(.system(.title3)).fontWeight(.bold).padding()
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 20) {
                                    ForEach(progress.dayList, id: \.self) { item in
                                        ZStack {
                                            Circle()
                                                .foregroundColor(item.complete ? .green : .gray)
                                                .frame(width: 40, height: 40)
                                            Text(String(item.number)).foregroundColor(Color(.white))
                                        }
                                    }
                                }
                        }
                    }
                }.padding()
                Button("10 MORE REPS") {
                    progress.increasePercent()

                    if progress.progress > 0.9 {
                        progress.currentStreak += 1
                        let today = Day(complete: true, number: progress.dayNum, date: Date())
                        progress.dayList.append(today)
                        progress.progress = 0
                        progress.dayNum += 1
                    } else {
                        let remaining = 10 - (progress.progress * 10)
                        if remaining > 1 {
                            
                            let date = Date()
                            let calendar = Calendar.current
                            
                            let minute = calendar.component(.minute, from: date)
                            
                            notificationManager.schedule(Minute: minute)
                        }
                    }
                    
                }
                .buttonStyle(IncrementButton())
            }
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    progress.populateMissed()
                    if let last = progress.getLast() {
                        if last.complete == false {
                            progress.currentStreak = 0
                        }
                    }
                } else if newPhase == .inactive {
                } else if newPhase == .background {
                    print("BACKGROUND")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension Color {
    static let accentRed = Color(red: 0.99, green: 0.34, blue: 0.39)
    static let darkGreen = Color(red: 0 / 255, green: 111 / 255, blue: 60 / 255)
    static let darkRed = Color(red: 191 / 255, green: 33 / 255, blue: 47 / 255)
}
