//
//  UserViewModel.swift
//  MindGarden
//
//  Created by Mark Jones on 7/25/21.
//

import Foundation
import Combine
import Firebase
import FirebaseFirestore
import Purchases
import WidgetKit

var userCoins: Int = 0
class UserViewModel: ObservableObject {
    @Published var ownedPlants: [Plant] = [Plant(title: "White Daisy", price: 100, selected: false, description: "With their white petals and yellow centers, white daisies symbolize innocence and the other classic daisy traits, such as babies, motherhood, hope, and new beginnings.", packetImage: Img.daisyPacket, one: Img.daisy1, two: Img.daisy2, coverImage: Img.daisy3, head: Img.daisyHead, badge: Img.daisyBadge)]
    @Published var selectedPlant: Plant?
    @Published var willBuyPlant: Plant?
    private var validationCancellables: Set<AnyCancellable> = []

    var name: String = ""
    var joinDate: String = ""
    var greeting: String = ""
    var referredStack: String = ""
    let db = Firestore.firestore()
    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter
    }()

    init() {
        getSelectedPlant()
        getGreeting()
    }

    func getSelectedPlant() {
        if let plantTitle = UserDefaults.standard.string(forKey: K.defaults.selectedPlant) {
            self.selectedPlant = Plant.allPlants.first(where: { plant in
                return plant.title == plantTitle
            })
        }
    }

    func updateSelf() {
        if let defaultName = UserDefaults.standard.string(forKey: "name") {
            self.name = defaultName
        }
        if let coins = UserDefaults.standard.value(forKey: "coins") as? Int {
            userCoins = coins
        }

        
        if let email = Auth.auth().currentUser?.email {
            db.collection(K.userPreferences).document(email).getDocument { (snapshot, error) in
                if let document = snapshot, document.exists {
                    if let joinDate = document[K.defaults.joinDate] as? String {
                        self.joinDate = joinDate
                    }

                    if let coins = document[K.defaults.coins] as? Int {
                        userCoins = coins
                        UserDefaults.standard.set(userCoins, forKey: "coins")
                    }

                    if let name = document["name"] as? String {
                        self.name = name
                        UserDefaults.standard.set(self.name, forKey: "name")
                        tappedSignIn = false
                    }
        

                    if let fbPlants = document[K.defaults.plants] as? [String] {
                        self.ownedPlants = Plant.allPlants.filter({ plant in
                            return fbPlants.contains(where: { str in
                                plant.title == str
                            })
                        })
                    }
                }
            }
        } else {
            if let plants = UserDefaults.standard.value(forKey: K.defaults.plants) as? [String] {
                self.ownedPlants = Plant.plants.filter({ plant in
                    return plants.contains(where: { str in
                        plant.title == str
                    })
                })
                let badgePlants = Plant.badgePlants.filter({ plant in
                    return plants.contains(where: { str in
                        plant.title == str
                    })
                })
                    self.ownedPlants += badgePlants
            }
            if let joinDate = UserDefaults.standard.string(forKey: "joinDate") {
                self.joinDate = joinDate
            }
        }

        //set selected plant
        selectedPlant = Plant.allPlants.first(where: { plant in
            return plant.title == UserDefaults.standard.string(forKey: K.defaults.selectedPlant)
        })
    }
    func updateReffered(refDate: String, numRefs: Int) {
        UserDefaults.standard.setValue(true, forKey: "isPro")
        var dte = dateFormatter.date(from: self.referredStack == "" ? dateFormatter.string(from: Date()) : refDate)

        if dte ?? Date() < Date() {
            dte = Date()
        }
        if numRefs >= 1 && !UserDefaults.standard.bool(forKey: "referPlant") {
            willBuyPlant = Plant.badgePlants.first(where: {$0.title == "Venus Fly Trap"})
            buyPlant(unlockedStrawberry: true)
            UserDefaults.standard.setValue(true, forKey: "referPlant")
        }

        let newDate = Calendar.current.date(byAdding: .weekOfMonth, value: 1, to: dte ?? Date())
        let newDateString = dateFormatter.string(from: newDate ?? Date())
        self.referredStack = newDateString+"+"+String(numRefs)
        if let email = Auth.auth().currentUser?.email {
            Firestore.firestore().collection(K.userPreferences).document(email).updateData([
                "referredStack": self.referredStack,
            ]) { (error) in
                if let e = error {
                    print("There was a issue saving data to firestore \(e) ")
                } else {
                    print("Succesfully saved new items")
                }
            }
        }
    }

    func checkIfPro() {
        var isPro = false
        Purchases.shared.purchaserInfo { [self] (purchaserInfo, error) in
            if purchaserInfo?.entitlements.all["isPro"]?.isActive == true {
                if !UserDefaults.standard.bool(forKey: "bonsai") {
                    self.willBuyPlant = Plant.badgePlants.first(where: { $0.title == "Bonsai Tree"})
                    self.buyPlant(unlockedStrawberry: true)
                    UserDefaults.standard.setValue(true, forKey: "bonsai")
                }
                UserDefaults.standard.setValue(true, forKey: "isPro")
                UserDefaults(suiteName: "group.io.bytehouse.mindgarden.widget")?.setValue(true, forKey: "isPro")
                WidgetCenter.shared.reloadAllTimelines()
            } else {
                if !UserDefaults.standard.bool(forKey: "trippleTapped") {
                    UserDefaults.standard.setValue(false, forKey: "isPro")
                    if referredStack != "" {
                        let plusIndex = referredStack.indexInt(of: "+") ?? 0
                        if dateFormatter.date(from: referredStack.substring(to: plusIndex)) ?? Date() > Date() {
                            UserDefaults.standard.setValue(true, forKey: "isPro")
                            isPro = true
                        } else {
                            UserDefaults.standard.setValue(false, forKey: "isPro")
                        }
                    }
                    UserDefaults(suiteName: "group.io.bytehouse.mindgarden.widget")?.setValue(true, forKey: "isPro")
                    WidgetCenter.shared.reloadAllTimelines()
                    if let email = Auth.auth().currentUser?.email {
                        Firestore.firestore().collection(K.userPreferences).document(email).updateData([
                            "isPro": isPro,
                        ]) { (error) in
                            if let e = error {
                                print("There was a issue saving data to firestore \(e) ")
                            } else {
                                print("Succesfully saved new items")
                            }
                        }
                    }
                }
            }
        }
    }


    func getGreeting() {
        let hour = Calendar.current.component( .hour, from:Date() )

        if hour < 11 {
            greeting = "Good Morning"
        }
        else if hour < 16 {
            greeting = "Good Afternoon"
        }
        else {
            greeting = "Good Evening"
        }
    }

    func buyPlant(isUnlocked: Bool = false, unlockedStrawberry: Bool = false) {
        if let plant = willBuyPlant {
            if !unlockedStrawberry {
                userCoins -= willBuyPlant?.price ?? 0
            }
            ownedPlants.append(plant)
            if !isUnlocked {
                if !unlockedStrawberry {
                    selectedPlant = willBuyPlant
                }
            }
            var finalPlants: [String] = [String]()
            if let email = Auth.auth().currentUser?.email {
                let docRef = db.collection(K.userPreferences).document(email)
                docRef.getDocument { (snapshot, error) in
                    if let document = snapshot, document.exists {
                        if let plants = document[K.defaults.plants] as? [String] {
                            finalPlants = plants
                        }
                        finalPlants.append(plant.title)
                    }
                    self.db.collection(K.userPreferences).document(email).updateData([
                        K.defaults.plants: finalPlants,
                        K.defaults.coins: userCoins
                    ]) { (error) in
                        if let e = error {
                            print("There was a issue saving data to firestore \(e) ")
                        } else {
                            print("Succesfully saved user model")
                        }
                    }
                }
            } else {
                if let plants = UserDefaults.standard.value(forKey: K.defaults.plants) as? [String] {
                    var newPlants = plants
                    newPlants.append(plant.title)
                    UserDefaults.standard.setValue(newPlants, forKey: K.defaults.plants)
                } else {
                    var newPlants = ["White Daisy"]
                    newPlants.append(plant.title)
                    UserDefaults.standard.setValue(newPlants, forKey: K.defaults.plants)
                }
                UserDefaults.standard.setValue(userCoins, forKey: K.defaults.coins)
            }
        }
    }
}
