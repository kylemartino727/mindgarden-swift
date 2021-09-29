//
//  PlantTile.swift
//  MindGarden
//
//  Created by Mark Jones on 6/14/21.
//

import SwiftUI

struct PlantTile: View {
    @EnvironmentObject var userModel: UserViewModel
    let width, height: CGFloat
    let plant: Plant
    let isShop: Bool
    var isOwned: Bool = false
    var isBadge: Bool = false

    var body: some View {
            ZStack {
                Rectangle()
                    .foregroundColor(isBadge ? isOwned ? Clr.darkWhite : .gray.opacity(0.2): isOwned ? .gray.opacity(0.2) : Clr.darkWhite)
                    .frame(width: width * 0.35, height: height * 0.3)
                    .cornerRadius(15)
                    .overlay(RoundedRectangle(cornerRadius: 15)
                    .stroke(Clr.darkgreen, lineWidth: !isShop && plant == userModel.selectedPlant ? 3 : 0))
                    .padding()
                VStack(alignment: isShop ? .leading : .center, spacing: 0) {
                    isShop ?
                   (!isBadge ?
                    plant.packetImage
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: width * 0.30, height: height * 0.18)
                        .shadow(color: .black.opacity(0.25), radius: 4, x: 4, y: 4)
                        .opacity(isOwned ? 0.4 : 1) :
                    plant.coverImage
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: width * 0.30, height: height * 0.18)
                        .shadow(color: .black.opacity(0.25), radius: 4, x: 4, y: 4)
                        .opacity(1)
                   )
                        : plant.coverImage
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: width * 0.30, height: height * 0.18)
                        .shadow(color: .black.opacity(0.25), radius: 4, x: 4, y: 4)
                        .opacity(1)
                    Text(plant.title)
                        .font(Font.mada(.bold, size: 20))
                        .foregroundColor(Clr.black1)
                        .opacity(isOwned ? 0.4 : 1)
                        .lineLimit(1)
                        .minimumScaleFactor(0.05)
                        .frame(width: width * 0.35 * 0.85, alignment: .leading)
                        .padding(.leading, isBadge ? 3 : isShop ? 0 : 5)
                    if isShop {
                        if isOwned && !isBadge{
                            Text("Bought")
                                .font(Font.mada(.bold, size: 20))
                                .foregroundColor(Clr.darkgreen)
                                .opacity(0.4)
                        } else {
                            HStack(spacing: isBadge ? 0 : 5) {
                                if isBadge {
                                    if userModel.ownedPlants.contains(plant) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(Clr.brightGreen)
                                    } else {
                                        Image(systemName: "lock.fill")
                                            .renderingMode(.original)
                                    }
                                } else {
                                    Img.coin
                                        .renderingMode(.original)
                                }

                                Text(isBadge ? Plant.badgeDict[plant.price] ?? "" : String(plant.price))
                                    .font(Font.mada(.semiBold, size: isBadge ? 16 : 20))
                                    .foregroundColor(Clr.black2)
                                    .multilineTextAlignment(.trailing)
                                    .padding(.leading, 5)
                            }.frame(width: width * 0.35 * 0.85, alignment: .leading)
                        }
                    } else {
                        Capsule()
                            .fill(plant == userModel.selectedPlant  ? Clr.yellow : Clr.darkgreen)
                            .overlay(Text(plant == userModel.selectedPlant ? "Selected" : "Select")
                                        .font(Font.mada(.semiBold, size: 18))
                                        .foregroundColor(plant == userModel.selectedPlant ? Clr.black1 : .white)
                                        .padding()
                            )
                            .frame(width: width * 0.30, height: height * 0.04)
                            .buttonStyle(NeumorphicPress())
                            .padding(.top, 5)
                    }
                }
            }
    }
}

struct PlantTile_Previews: PreviewProvider {
    static var previews: some View {
        PlantTile(width: 300, height: 700, plant: Plant(title: "Red Tulip", price: 90, selected: false, description: "Red Tulips are a genus of spring-blooming perennial herbaceous bulbiferous geophytes. Red tulips symbolize eternal love, undying love, perfect love, true love.", packetImage: Img.redTulipsPacket, one: Img.redTulips1, two: Img.redTulips2,  coverImage: Img.redTulips3, head: Img.redTulipHead, badge: Img.redTulipsBadge), isShop: false)
    }
}
