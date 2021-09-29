//
//  GardenViewModel.swift
//  MindGarden
//
//  Created by Mark Jones on 8/6/21.
//

import Combine
import Firebase
import FirebaseFirestore
import Foundation
import WidgetKit

class GardenViewModel: ObservableObject {
    @Published var grid = [String: [String:[String:[String:Any]]]]()
    @Published var isYear: Bool = false
    @Published var selectedYear: Int = 2021
    @Published var selectedMonth: Int = 1
    @Published var monthTiles = [Int: [Int: (Plant?, Mood?)]]()
    @Published var totalMoods = [Mood:Int]()
    @Published var totalMins = 0
    @Published var totalSessions = 0
    @Published var favoritePlants = [String: Int]()
    @Published var recentMeditations: [Meditation] = []
    var medIds: [String] = [] //TODO turn this into a set

    var allTimeMinutes = 0
    var allTimeSessions = 0
    var placeHolders = 0
    var startsOnSunday = false
    let db = Firestore.firestore()

    init() {
        selectedMonth = (Int(Date().get(.month)) ?? 1)
        selectedYear = Int(Date().get(.year)) ?? 2021
    }

    func getRecentMeditations() {
        medIds = [String]()
        grid.values.forEach { value in //TODO sort years
            let months = value.keys.sorted { Int($0) ?? 1 > Int($1) ?? 1 }
            for mo in months  {
                if let singleDay = value[String(mo)]{
                    let days = singleDay.keys.sorted { Int($0) ?? 1 > Int($1) ?? 1 }
                    for day in days { // we can improve performance by stopping when we get the last two different sessions
                        if let sessions = singleDay[String(day)]?["sessions"] as? [[String: String]] {
                            for sess in sessions {
                                medIds.insert(sess["meditationId"] ?? "1", at: 0)
                            }
                        }
                    }
                }
            }

            var med1: Meditation?
            var med2: Meditation?
            var ids = [Int]()
            if medIds.count >= 1 {
                med1 = Meditation.allMeditations.first(where: { medd in
                    String(medd.id) == medIds[0]
                })
                if med1?.type == .lesson && med1?.belongsTo != "Open-ended Meditation" && med1?.belongsTo != "Timed Meditation" {
                    let parentCourse = Meditation.allMeditations.first { medd in
                        medd.title == med1?.belongsTo
                    }
                    med1 = parentCourse
                }
            }

            var index = 0
            while index < medIds.count {
                if med2 != nil && med1 != med2 {
                    break
                } else {
                    med2 = Meditation.allMeditations.first(where: { medd in
                        String(medd.id) == medIds[index]
                    })
                    if med2?.type == .lesson  && med2?.belongsTo != "Open-ended Meditation" && med2?.belongsTo != "Timed Meditation" {
                        let parentCourse = Meditation.allMeditations.first { medd in
                            medd.title == med2?.belongsTo
                        }
                        med2 = parentCourse
                    }
                }
                index += 1
            }
            recentMeditations = []
            if med2 != nil {
                if med1 != med2 {
                    recentMeditations.append(med2!)
                    ids.append(med2!.id)
                }
            }

            if med1 != nil {
                recentMeditations.append(med1!)
                ids.append(med1!.id)
            }


            UserDefaults.standard.setValue(ids, forKey: "recent")
        }
    }

    func populateMonth() {
        totalMins = 0
        totalSessions = 0
        placeHolders = 0
        monthTiles = [Int: [Int: (Plant?, Mood?)]]()
        totalMoods = [Mood:Int]()
        favoritePlants = [String: Int]()
        startsOnSunday = false
        let strMonth = String(selectedMonth)
        let numOfDays = Date().getNumberOfDays(month: strMonth, year: String(selectedYear))
        let intWeek = Date().weekDayToInt(weekDay: Date.dayOfWeek(day: "1", month: strMonth, year: String(selectedYear)))

        if intWeek != 0 {
            placeHolders = intWeek
        } else { //it starts on a sunday
            startsOnSunday = true
        }

        var weekNumber = 0
        for day in 1...numOfDays {
            let weekday = Date.dayOfWeek(day: String(day), month: strMonth, year: String(selectedYear))
            let weekInt = Date().weekDayToInt(weekDay: weekday)
            if weekInt == 0 && !startsOnSunday {
                weekNumber += 1
            } else if startsOnSunday {
                startsOnSunday = false
            }

            var plant: Plant? = nil
            var mood: Mood? = nil
            if let sessions = grid[String(selectedYear)]?[strMonth]?[String(day)]?[K.defaults.sessions] as? [[String: String]] {
                let fbPlant = sessions[sessions.count - 1][K.defaults.plantSelected]
                plant = Plant.allPlants.first(where: { $0.title == fbPlant })
                for session in sessions {
                    totalMins += (Double(session[K.defaults.duration] ?? "0.0") ?? 0).toInt() ?? 0
                    let plant = session[K.defaults.plantSelected] ?? ""
                    if var count = favoritePlants[plant] {
                        count += 1
                        favoritePlants[plant] = count
                    } else {
                        favoritePlants[plant] = 1
                    }
                }
                totalSessions += sessions.count
            }

            if let moods = grid[String(selectedYear)]?[strMonth]?[String(day)]?[K.defaults.moods] as? [String] {
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


            if let _ = monthTiles[weekNumber] {
                monthTiles[weekNumber]?[day] = (plant, mood)
            } else { // first for this week
                monthTiles[weekNumber] = [day: (plant,mood)]
            }
        }
    }

    func updateSelf() {
        if let defaultRecents = UserDefaults.standard.value(forKey: "recent") as? [Int] {
            self.recentMeditations = Meditation.allMeditations.filter({ med in defaultRecents.contains(med.id) }).reversed()
        }

        if let email = Auth.auth().currentUser?.email {
            db.collection(K.userPreferences).document(email).getDocument { (snapshot, error) in
                if let document = snapshot, document.exists {
                    if let gardenGrid = document[K.defaults.gardenGrid] as? [String: [String:[String:[String:Any]]]] {
                        self.grid = gardenGrid
                        UserDefaults(suiteName: "group.io.bytehouse.mindgarden.widget")?.setValue(self.grid, forKey: "grid")
                        WidgetCenter.shared.reloadAllTimelines()
                    }
                    if let allTimeMins = document["totalMins"] as? Int {
                        self.allTimeMinutes = allTimeMins
                    }
                    if let allTimeSess = document["totalSessions"] as? Int {
                        self.allTimeSessions = allTimeSess
                    }
                    self.populateMonth()
                    self.getRecentMeditations()
                }
            }
        } else {
            if let gridd = UserDefaults.standard.value(forKey: "grid") as? [String: [String:[String:[String:Any]]]] {
                self.grid = gridd
            }
            if let allTimeMins = UserDefaults.standard.value(forKey: "allTimeMinutes") as? Int {
                self.allTimeMinutes = allTimeMins
            }
            if let allTimeSess = UserDefaults.standard.value(forKey: "allTimeSessions") as? Int {
                self.allTimeSessions = allTimeSess
            }
            self.populateMonth()
            self.getRecentMeditations()
            UserDefaults(suiteName: "group.io.bytehouse.mindgarden.widget")?.setValue(self.grid, forKey: "grid")
            WidgetCenter.shared.reloadAllTimelines()

        }

    }

    func save(key: String, saveValue: Any) {
        if key == "sessions" {
            if let session = saveValue as? [String: String] {
                self.allTimeSessions += 1
                if let myNumber = (Double(session[K.defaults.duration] ?? "0.0") ?? 0).toInt() {
                    self.allTimeMinutes += myNumber
                }
            }
        }

        if let email = Auth.auth().currentUser?.email {
            let docRef = db.collection(K.userPreferences).document(email)
            docRef.getDocument { (snapshot, error) in
                if let document = snapshot, document.exists {
                    if let gardenGrid = document[K.defaults.gardenGrid] {
                        self.grid = gardenGrid as! [String: [String:[String:[String:Any]]]]
                    }
                    if let year = self.grid[Date().get(.year)] {
                        if let month = year[Date().get(.month)] {
                            if let day = month[Date().get(.day)] {
                                if var values = day[key] as? [Any] {
                                    //["plantSelected" : "coogie", "meditationId":3]
                                    values.append(saveValue)
                                    self.grid[Date().get(.year)]?[Date().get(.month)]?[Date().get(.day)]?[key] = values
                                } else { // first of that type today
                                    self.grid[Date().get(.year)]?[Date().get(.month)]?[Date().get(.day)]?[key] = [saveValue]
                                }
                            } else { // first save of type that day
                                self.grid[Date().get(.year)]?[Date().get(.month)]?[Date().get(.day)] = [key: [saveValue]]
                            }
                        } else { //first session of month
                            self.grid[Date().get(.year)]?[Date().get(.month)] = [Date().get(.day): [key: [saveValue]]]
                        }
                    } else {
                        self.grid[Date().get(.year)] = [Date().get(.month): [Date().get(.day): [key: [saveValue]]]]
                    }
                }

                self.db.collection(K.userPreferences).document(email).updateData([
                    "gardenGrid": self.grid,
                    "totalMins": self.allTimeMinutes,
                    "totalSessions": self.allTimeSessions,
                    "coins": userCoins,
                ]) { (error) in
                    if let e = error {
                        print("There was a issue saving data to firestore \(e) ")
                    } else {
                        print("Succesfully saved garden model")
                        UserDefaults(suiteName: "group.io.bytehouse.mindgarden.widget")?.setValue(self.grid, forKey: "grid")
                        WidgetCenter.shared.reloadAllTimelines()
                        self.populateMonth()
                        if key == "sessions" {
                            self.getRecentMeditations()
                        }
                    }
                }
            }
        } else {
            UserDefaults.standard.setValue(self.allTimeMinutes, forKey: "allTimeMinutes")
            UserDefaults.standard.setValue(self.allTimeSessions, forKey: "allTimeSessions")
            UserDefaults.standard.setValue(userCoins, forKey: "coins")
            if let gridd = UserDefaults.standard.value(forKey: "grid") as? [String: [String:[String:[String:Any]]]] {
                self.grid = gridd
            }
            if let year = self.grid[Date().get(.year)] {
                if let month = year[Date().get(.month)] {
                    if let day = month[Date().get(.day)] {
                        if var values = day[key] as? [Any] {
                            //["plantSelected" : "coogie", "meditationId":3]
                            values.append(saveValue)
                            self.grid[Date().get(.year)]?[Date().get(.month)]?[Date().get(.day)]?[key] = values
                        } else { // first of that type today
                            self.grid[Date().get(.year)]?[Date().get(.month)]?[Date().get(.day)]?[key] = [saveValue]
                        }
                    } else { // first save of type that day
                        self.grid[Date().get(.year)]?[Date().get(.month)]?[Date().get(.day)] = [key: [saveValue]]
                    }
                } else { //first session of month
                    self.grid[Date().get(.year)]?[Date().get(.month)] = [Date().get(.day): [key: [saveValue]]]
                }
            } else {
                self.grid[Date().get(.year)] = [Date().get(.month): [Date().get(.day): [key: [saveValue]]]]
            }
        }
        UserDefaults.standard.setValue(self.grid, forKey: "grid")
        UserDefaults(suiteName: "group.io.bytehouse.mindgarden.widget")?.setValue(self.grid, forKey: "grid")
        WidgetCenter.shared.reloadAllTimelines()
        self.populateMonth()
        if key == "sessions" {
            self.getRecentMeditations()
        }
    }
}
