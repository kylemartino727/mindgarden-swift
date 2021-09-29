//
//  MindGardenWidget.swift
//  MindGardenWidget
//
//  Created by Mark Jones on 12/26/21.
//

import WidgetKit
import SwiftUI
import Intents


struct Provider: IntentTimelineProvider {
    let gridd = [String: [String:[String:[String:Any]]]]()
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), grid: gridd, streakNumber: 1, isPro: false, configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), grid: gridd, streakNumber: 1, isPro: false, configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = [] 
        let userDefaults = UserDefaults(suiteName: "group.io.bytehouse.mindgarden.widget")

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        let grid = userDefaults?.value(forKey: "grid") as? [String: [String:[String:[String:Any]]]]
        let streakNumber = userDefaults?.integer(forKey: "streakNumber")
        let isPro = userDefaults?.bool(forKey: "isPro")
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, grid: grid ?? [String: [String:[String:[String:Any]]]](), streakNumber: streakNumber ?? 1, isPro: isPro ?? false,  configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let grid: [String: [String:[String:[String:Any]]]]
    let streakNumber: Int
    let isPro: Bool
    let configuration: ConfigurationIntent
}

struct MindGardenWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family
    @State var moods: [Mood: Int]
    @State var gratitudes: Int
    @State var streak: Int
    @State var plants: [Plnt]
    @State var dayTime: Bool

    @ViewBuilder
    var body: some View {
        GeometryReader { g in
            let width = g.size.width
            let height = g.size.height
            ZStack {
                Color("darkWhite")
                switch family {
                case .systemSmall:
                    Text("Small")
                case .systemMedium:
                    if entry.isPro {
                        MediumWidget(width: width, height: height, moods: $moods, gratitudes: $gratitudes, streak: $streak)
                    } else {
                        HStack {
                            Spacer()
                            VStack {
                                Spacer()
                                Text("This is pro only feature")
                                    .font(Font.mada(.bold, size: 18))
                                    .foregroundColor(Color("superBlack"))
                                Link(destination: URL(string: "pro://io.bytehouse.mindgarden")!)  {
                                    Capsule()
                                        .fill(Color("darkgreen"))
                                        .overlay(Text("👨‍🌾 Go Pro!")
                                                    .foregroundColor(.white)
                                                    .font(Font.mada(.bold, size: 14)))
                                        .frame(width: 125, height: 35)
                                        .padding(.top, 5)
                                        .neoShadow()
                                }
                                Spacer()
                                }
                                Spacer()
                            }
                            Spacer()
                        }
//                case .systemLarge:
//                    VStack(spacing: 5) {
//                        MediumWidget(width: width, height: height * 0.425, moods: $moods, gratitudes: $gratitudes, streak: $streak)
//                        ZStack {
//                            Rectangle()
//                                .fill(Color("skyBlue"))
//                                .cornerRadius(14)
//                                .frame(width: width * 0.875)
//                                .opacity(0.5)
//                                .neoShadow()
//                            VStack(alignment: .center) {
//                                Spacer()
//                                if !plants.isEmpty {
//                                    HStack {
////                                        Text(plants[0].title)
////                                            .font(Font.mada(.bold, size: 40))
//                                        ForEach(0..<20) { idx in
//                                            let xPos = Int.random(in: -25...25)
//                                            let _ = print(xPos, idx, plants[idx])
//                                            Image(plants[idx].title)
//                                                .resizable()
//                                                .aspectRatio(contentMode: .fit)
//                                                .frame(width: 35, height: height * 0.2)
//                                                .position(y: 250)
////                                                .offset(x: CGFloat(xPos))
//                                        }
//                                    }.frame(width: width * 0.85, height: height)
//                                    HStack {
//                                        ForEach(plants.count/2..<plants.count) { idx in
//                                            let xPos = Double.random(in: (-width * 0.15)...(width*0.15))
//                                            let _ = print(xPos)
//                                            Text(plants[idx].title)
//                                                .font(Font.mada(.bold, size: 5))
//                                                .frame(width: 60, height: height * 0.1)
////                                                .offset(x: xPos)
//                                        }
//                                    }
//                                }
//                                Image("sun")
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fit)
//                                    .position(x: -75, y: 40)
//                                    .frame(width: width * 0.15)
//                                if !plants.isEmpty {
//                                    HStack {
//                                        Text(String(plants.count))
//                                            .font(Font.mada(.bold, size: 40))
//                                    }.frame(width: width, height: height * 0.2)
//                                }
//                            }.frame(width: width, height: height * 0.4)
//                        }.frame(width: width * 0.85, height: height * 0.45)
//                        .padding(.bottom, 5)
                default:
                    Text("Some other WidgetFamily in the future.")
                }
            }
        }.onAppear {
            let hour = Calendar.current.component( .hour, from:Date() )
            if hour <= 17 {
                dayTime = true
            } else {
                dayTime = false
            }
            extractData()
        }
    }
    struct MediumWidget: View {
        let width: CGFloat
        let height: CGFloat
        @Binding var moods: [Mood: Int]
        @Binding var gratitudes: Int
        @Binding var streak: Int


        var body: some View {
            HStack(alignment: .center, spacing: 10) {
                VStack(spacing: 15) {
                    Link(destination: URL(string: "mood://io.bytehouse.mindgarden")!)  {
                        MenuChoice(title: "Mood", img: Image(systemName: "face.smiling"), width: width)
                            .frame(height: 30)
                            .neoShadow()
                    }
                    Link(destination: URL(string: "gratitude://io.bytehouse.mindgarden")!)  {
                        MenuChoice(title: "Gratitude", img: Image(systemName: "square.and.pencil"), width: width)
                            .frame(height: 30)
                            .neoShadow()
                    }
                    Link(destination: URL(string: "meditate://io.bytehouse.mindgarden")!)  {
                        MenuChoice(title: "Meditate", img: Image(systemName: "play"), width: width)
                            .frame(height: 30)
                            .neoShadow()
                    }
                }.padding(10)
                    .frame(width: width * 0.4, height: height, alignment: .center)
                ZStack {
                    Rectangle()
                        .fill(Color("darkWhite"))
                        .cornerRadius(14)
                    VStack {
                        Text("\(Date().getMonthName(month: Date().get(.month)))")
                            .font(Font.mada(.bold, size: 12))
                            .foregroundColor(Color("superBlack"))
                            .offset(y: 5)
                        HStack(spacing: 5) {
                             Image("newStar")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: width * 0.05)
                            Text("Streak:")
                                .font(Font.mada(.regular, size: 14))
                                .foregroundColor(Color("black2"))
                            Spacer()
                            Text("\(streak)")
                                .font(Font.mada(.bold, size: 16))
                                .foregroundColor(Color("darkgreen"))
                        }.frame(width: width * 0.39, alignment: .leading)
                        HStack(spacing: 5) {
                            Image("hands")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: width * 0.05)
                            Text("Gratitudes:")
                                .font(Font.mada(.regular, size: 14))
                                .foregroundColor(Color("black2"))
                            Spacer()
                            Text("\(gratitudes)")
                                .font(Font.mada(.bold, size: 16))
                                .foregroundColor(Color("darkgreen"))
                        }.frame(width: width * 0.39, alignment: .leading)
                        HStack(spacing: 10) {
                            SingleMood(mood: .happy, count: moods[.happy] ?? 0)
                            SingleMood(mood: .okay, count: moods[.okay] ?? 0)
                            SingleMood(mood: .sad, count: moods[.sad] ?? 0)
                            SingleMood(mood: .angry, count: moods[.angry] ?? 0)
                        }.frame(height: height * 0.25)
                        .padding(.horizontal, 8)
                    }
                }.frame(width: width * 0.45, height: height * 0.8, alignment: .center)
                    .neoShadow()
                    .padding([.vertical])
            }
        }

    }


    func extractData() {
//       var monthTiles = [Int: [Int: (String?, Mood?)]]()
       var totalMoods = [Mood:Int]()
       var startsOnSunday = false
       var placeHolders = 0
       let strMonth = Date().get(.month)
       var favoritePlants = [String: Int]()
       let numOfDays = Date().getNumberOfDays(month: strMonth, year: Date().get(.year))
       let intWeek = Date().weekDayToInt(weekDay: Date.dayOfWeek(day: "1", month: strMonth, year: Date().get(.year)))

       if intWeek != 0 {
           placeHolders = intWeek
       } else { //it starts on a sunday
           startsOnSunday = true
       }
       var allPlants = [String]()
       var weekNumber = 0
       for day in 1...numOfDays {
           var plant: String? = nil
           var mood: Mood? = nil
           let weekday = Date.dayOfWeek(day: String(day), month: strMonth, year: Date().get(.year))
           let weekInt = Date().weekDayToInt(weekDay: weekday)

           if weekInt == 0 && !startsOnSunday {
               weekNumber += 1
           } else if startsOnSunday {
               startsOnSunday = false
           }

           if let sessions = entry.grid[String(Date().get(.year))]?[strMonth]?[String(day)]?[K.defaults.sessions] as? [[String: String]] {
               for session in sessions {
                   let plant = session[K.defaults.plantSelected] ?? ""
//                   print(plant, "-")
                   allPlants.append(plant)
               }
           }

           if let moods = entry.grid[String(Date().get(.year))]?[strMonth]?[String(day)]?[K.defaults.moods] as? [String] {
               mood = Mood.getMood(str: moods[moods.count - 1])
               for forMood in moods {
                   let singleMood = Mood.getMood(str: forMood)
                   if var count = totalMoods[singleMood] {
                       count += 1
                       totalMoods[singleMood] = count
                   } else {
                       totalMoods[singleMood] = 1
                   }
               }
           }

           if let gratitudez = entry.grid[Date().get(.year)]?[strMonth]?[String(day)]?[K.defaults.gratitudes] as? [String] {
               gratitudes += gratitudez.count
           }
   }
        var plantz = [Plnt]()
        for plant in allPlants {
            if  plant != "Bonsai Tree"  {
                if let img = K.plantImages[plant]{
                    let plnt = Plnt(title: img, id: plant)
                    plantz.append(plnt)
                }
            }
        }
        plantz = plantz.reversed()
        plants = plantz
        moods = totalMoods
    }


    struct SingleMood: View {
        let mood: Mood
        let count: Int

        var body: some View {
            VStack(spacing: 2) {
                K.getMoodImage(mood: mood)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Text("\(count)")
                    .font(Font.mada(.bold, size: 12))
                    .foregroundColor(Color("darkgreen"))
            }

        }
    }

    struct MenuChoice: View {
        let title: String
        let img: Image
        let width: CGFloat

        var body: some View {
            ZStack {
                Capsule()
                    .fill(Color("darkWhite"))
                HStack(spacing: -5) {
                    Text(title)
                        .font(Font.mada(.medium, size: 16))
                        .minimumScaleFactor(0.5)
                        .foregroundColor(Color("darkgreen"))
                        .frame(width: width * 0.3, alignment: .leading)
                        .padding(.leading, 5)
                        .offset(x: 10)
                    img
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color("darkgreen"))
                        .padding(3)
                        .frame(width: width * 0.07)
                }.frame(width: width * 0.4, alignment: .leading)
            }
        }
    }
}

struct Plnt: Identifiable {
    let title,id:String
}

@main
struct MindGardenWidget: Widget {
    let kind: String = "MindGardenWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            MindGardenWidgetEntryView(entry: entry, moods: [Mood: Int](), gratitudes: 0, streak: 1, plants: [Plnt](), dayTime: true)
        }
        .configurationDisplayName("MindGarden Widget")
        .description("⚙️ This is the first version of our MindGarden widget. If you would like new features or layouts or experience a bug please fill out the feedback form in the settings page of the app :) We're a small team of 3 so all this feedback will be taken very seriously.")
        .supportedFamilies([.systemMedium])
    }
}

struct MindGardenWidget_Previews: PreviewProvider {
    static var previews: some View {
        MindGardenWidgetEntryView(entry: SimpleEntry(date: Date(), grid: [String: [String:[String:[String:Any]]]]()
                                                     , streakNumber: 1, isPro: false, configuration: ConfigurationIntent()), moods: [Mood: Int](), gratitudes: 0, streak: 1, plants: [Plnt](), dayTime: true)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
