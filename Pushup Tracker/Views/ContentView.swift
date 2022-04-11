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
    
    @FetchRequest(sortDescriptors: []) var days: FetchedResults<ManagedDay>
    @Environment(\.managedObjectContext) var moc
    
    let notificationManager = NotificationController()
    let defaults = UserDefaults.standard
    let date = Date()
    let impactMed = UIImpactFeedbackGenerator(style: .medium)
    
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
                    Text(date, style: .date).foregroundColor(Color(.white)).opacity(0.5).frame(width: 300, height: 10, alignment: .leading).padding(.top)
                    Text("Today").foregroundColor(Color(.white)).font(.system(.title3)).fontWeight(.bold).frame(width: 300, height: 25, alignment: .leading)
                    ZStack{
                        Rectangle()
                            .cornerRadius(35)
                            .foregroundColor(Color(red: 40 / 260, green: 44/255, blue: 45/255))
                        HStack {
                            Text("Current Streak \n" + String(progress.currentStreak) + " Days").foregroundColor(Color(.white)).multilineTextAlignment(.center).font(.system(size: 20))
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
                    }.padding([.leading, .trailing])
                    Text("Progress").foregroundColor(Color(.white)).font(.system(.title3)).fontWeight(.bold).frame(width: 300, height: 20, alignment: .leading)
                    ZStack {
                        Rectangle()
                            .cornerRadius(35)
                            .foregroundColor(Color(red: 40 / 260, green: 44/255, blue: 45/255))
                        VStack {
                            ScrollView {
                                LazyVGrid(columns: columns, spacing: 20) {
                                        ForEach(progress.dayList, id: \.self) { item in
                                            ZStack {
                                                Circle()
                                                    .foregroundColor(item.complete ? .green : .gray)
                                                    .frame(width: 40, height: 40)
                                                Text(String(item.number)).foregroundColor(Color(.white))
                                            }.padding()
                                        }
                                    }
                            }
                        }
                    }.padding([.leading, .trailing])
                    Button("10 MORE REPS") {
                        impactMed.impactOccurred()
                        if progress.lock == false {
                            progress.increasePercent()

                            if progress.progress > 0.9 {

                                let today = Day(complete: true, number: progress.dayNum, date: Date())
                                progress.dayList.append(today)
                                progress.progress = 1
                                progress.dayNum += 1
                                progress.currentStreak += 1
                                progress.lock = true
                                notificationManager.cancelNotification(id: "HourlyReminder")
                                
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
                    }.padding()
                    .buttonStyle(IncrementButton())
                }
            Banner()
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    print("ACTIVE")
                    progress.dayList = UserDefaults.standard.object([Day].self, with: "test") ?? []
                    progress.populateMissed()
                    progress.currentStreak = defaults.integer(forKey: "currentStreak")
                    progress.progress = defaults.double(forKey: "progress")
                    progress.lock = defaults.bool(forKey: "lock")
                    print(progress.dayList)
                    if let last = progress.getLast() {
                        if last.complete == false {
                            progress.currentStreak = 0
                        }
                    }
                } else if newPhase == .inactive {
                    UserDefaults.standard.set(object: progress.dayList, forKey: "test")
                    defaults.set(progress.currentStreak, forKey: "currentStreak")
                    defaults.set(progress.progress, forKey: "progress")
                    defaults.set(progress.lock, forKey: "lock")
                    print("INACTIVE")
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
.previewInterfaceOrientation(.portrait)
    }
}

extension Color {
    static let accentRed = Color(red: 0.99, green: 0.34, blue: 0.39)
    static let darkGreen = Color(red: 0 / 255, green: 111 / 255, blue: 60 / 255)
    static let darkRed = Color(red: 191 / 255, green: 33 / 255, blue: 47 / 255)
}

extension UserDefaults {
    func object<T: Codable>(_ type: T.Type, with key: String, usingDecoder decoder: JSONDecoder = JSONDecoder()) -> T? {
        guard let data = self.value(forKey: key) as? Data else { return nil }
        return try? decoder.decode(type.self, from: data)
    }

    func set<T: Codable>(object: T, forKey key: String, usingEncoder encoder: JSONEncoder = JSONEncoder()) {
        let data = try? encoder.encode(object)
        self.set(data, forKey: key)
    }
}
