//
//  Play.swift
//  MindGarden
//
//  Created by Mark Jones on 6/18/21.
//

import SwiftUI
import AVKit
import UIKit
import MediaPlayer

struct Play: View {
    var progressValue: Float {
        if model.isOpenEnded {
            return 1
        } else {
            return 1 - (model.secondsRemaining/model.totalTime)
        }
    }
    @State var timerStarted: Bool = true
    @State var favorited: Bool = false
    @State var player : AVAudioPlayer!
    @State var mainPlayer: AVPlayer!
    @State var data : Data = .init(count: 0)
    @State var title = ""
    @State var del = AVdelegate()
    @State var finish = false
    @State var showNatureModal = false
    @State var selectedSound: Sound? = .noSound
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var model: MeditationViewModel
    @EnvironmentObject var userModel: UserViewModel
    @State var sliderData = SliderData()
    @State var bellSlider = SliderData()
    @State var showTutorialModal = false

    var body: some View {
            ZStack {
                GeometryReader { g in
                    let width = g.size.width
                    let height = g.size.height
                    Clr.darkWhite.edgesIgnoringSafeArea(.all)
                    HStack(alignment: .center) {
                        Spacer()
                        VStack(alignment: .center) {
                            //Navbar
                            HStack {
                                UserDefaults.standard.string(forKey: K.defaults.onboarding) == "gratitude" ? backArrow.opacity(0) : backArrow.opacity(1)
                                Spacer()
                                Text(model.selectedMeditation?.title ?? "")
                                    .padding(.leading, 10)
                                Spacer()
                                HStack{sound; heart}
                            }.padding(.horizontal)
                            .padding(.top, height * 0.07)
                            HStack(alignment: .center) {
                                ZStack {
                                    Circle()
                                        .stroke(lineWidth: 20.0)
                                        .foregroundColor(Clr.superLightGray)
                                    Circle()
                                        .trim(from: 0.0, to: CGFloat(min(self.progressValue, 1.0)))
                                        .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                                        .foregroundColor(Clr.brightGreen)
                                        .rotationEffect(Angle(degrees: 270.0))
                                        .animation(.linear(duration: 2), value: model.secondsRemaining)
                                    Circle()
                                        .frame(width: K.isPad() ? 480 : 230)
                                        .foregroundColor(Clr.darkWhite)
                                        .shadow(color: .black.opacity(0.35), radius: 20.0, x: 10, y: 5)
                                    //four different plant stages
                                    if model.secondsRemaining <= model.totalTime * 0.25 || (model.secondsRemaining >= 300 && model.selectedMeditation?.duration == -1) { //secoond
                                        withAnimation {
                                            model.playImage
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: model.lastSeconds ? width/3 : width/5, height: model.lastSeconds ? height/5 : height/7)
                                                .animation(.easeIn(duration: 2.0))
                                        }
                                    } else if model.secondsRemaining <= model.totalTime * 0.5 || (model.secondsRemaining >= 200 && model.selectedMeditation?.duration == -1) {
                                        model.playImage
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .animation(.easeIn(duration: 2.0))
                                            .frame(width: width/4, height: height/6)
                                            .offset(y: 25)
                                        
                                    } else if model.secondsRemaining <= model.totalTime * 0.75 || (model.secondsRemaining >= 100 && model.selectedMeditation?.duration == -1) {
                                        model.playImage
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .animation(.easeIn(duration: 2.0))
                                            .frame(width: width/6, height: height/8)
                                            .offset(y: 50)
                                    } else {
                                        model.playImage
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .animation(.easeIn(duration: 1.0))
                                            .frame(width: width/10, height: height/12)
                                            .offset(y: 75)
                                    }
                                }
                                .frame(width: K.isPad() ? 500 : 250)
                            }
                            Text(model.secondsToMinutesSeconds(totalSeconds: model.isOpenEnded ? model.secondsCounted : model.secondsRemaining))
                                .foregroundColor(Clr.black1)
                                .font(Font.mada(.bold, size: 60))
                                .padding(.horizontal)
                            HStack(alignment: .center, spacing: 20) {
                                if model.selectedMeditation?.belongsTo != "Open-ended Meditation" {
                                    Button {
                                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                        if model.selectedMeditation?.belongsTo != "Timed Meditation" {
                                            goBackward()
                                        }
                                        if model.secondsRemaining + 15 <= model.selectedMeditation?.duration ?? 0.0 {
                                            model.secondsRemaining += model.selectedMeditation?.url != "" ? 14 : 15
                                        } else {
                                            model.secondsRemaining = model.selectedMeditation?.duration ?? 0.0
                                        }
                                    } label: {
                                        ZStack {
                                            Circle()
                                                .fill(Clr.darkWhite)
                                                .frame(width: 70)
                                                .neoShadow()
                                            VStack {
                                                Image(systemName: "backward.fill")
                                                    .foregroundColor(Clr.brightGreen)
                                                    .font(.title)
                                                Text("15")
                                                    .font(.caption)
                                                    .foregroundColor(Clr.darkgreen)
                                            }
                                        }
                                    }
                                }
                                Button {
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    if model.selectedMeditation?.belongsTo != "Timed Meditation" && model.selectedMeditation?.belongsTo != "Open-ended Meditation"  {
                                        if (mainPlayer.rate != 0 && mainPlayer.error == nil) {
                                            self.mainPlayer.rate = 0
                                        } else {
                                            mainPlayer.play()
                                        }
                                    }

                                    if player.isPlaying {
                                        player.pause()
                                    } else {
                                        player.play()
                                    }

                                    if timerStarted {
                                        model.stop()
                                    } else {
                                        model.startCountdown()
                                    }

                                    timerStarted.toggle()
                                } label: {
                                    ZStack {
                                        Circle()
                                            .fill(Clr.darkWhite)
                                            .frame(width: 90)
                                            .neoShadow()
                                        Image(systemName: timerStarted ? "pause.fill" : "play.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .foregroundColor(Clr.brightGreen)
                                            .frame(width: 35)
                                            .padding(.leading, 5)
                                    }
                                }
                                if model.selectedMeditation?.belongsTo != "Open-ended Meditation" {
                                    Button {
                                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                        if model.selectedMeditation?.belongsTo != "Timed Meditation" {
                                            goForward()
                                        }
                                        if model.secondsRemaining >= 15 {
                                            model.secondsRemaining -= model.selectedMeditation?.url != "" ? 14 : 15
                                        } else {
                                            model.secondsRemaining = 0
                                        }
                                    } label: {
                                        ZStack {
                                            Circle()
                                                .fill(Clr.darkWhite)
                                                .frame(width: 70)
                                                .neoShadow()
                                            VStack {
                                                Image(systemName: "forward.fill")
                                                    .foregroundColor(Clr.brightGreen)
                                                    .font(.title)
                                                Text("15")
                                                    .font(.caption)
                                                    .foregroundColor(Clr.darkgreen)
                                            }
                                        }
                                    }
                                } else {
                                    Button {
                                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                        model.stop()
                                        withAnimation {
                                            viewRouter.currentPage = .finished
                                        }
                                    } label: {
                                        Image(systemName: "square.fill")
                                            .foregroundColor(Clr.brightGreen)
                                            .aspectRatio(contentMode: .fit)
                                            .font(.system(size: 40))
                                    }
                                }
                            }
                        }
                        Spacer()
                    }.opacity(showNatureModal ? 0.3 : 1)
                    if showNatureModal || showTutorialModal {
                        Color.black
                            .opacity(0.3)
                            .edgesIgnoringSafeArea(.all)
                    }
                    NatureModal(show: $showNatureModal, sound: $selectedSound, change: self.changeSound, player: player, sliderData: $sliderData, bellSlider: $bellSlider)
                        .offset(y: showNatureModal ? 0 : g.size.height)
                        .animation(.default)
                    TutorialModal(show: $showTutorialModal)
                        .offset(y: showTutorialModal ? 0 : g.size.height)
                        .animation(.default)
                }
            }
        .transition(.move(edge: .trailing))
        .animation(.easeIn)
        .onAppearAnalytics(event: .screen_load_play)
        .onAppear {
            if model.selectedMeditation?.id != 22 {
                showTutorialModal = !UserDefaults.standard.bool(forKey: "playTutorialModal")
            }
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
               try AVAudioSession.sharedInstance().setActive(true)
             } catch {
               print(error)
             }
            model.selectedPlant = userModel.selectedPlant
            model.checkIfFavorited()
            favorited = model.isFavorited
            model.setup(viewRouter)
            if let defaultSound = UserDefaults.standard.string(forKey: "sound") {
                if defaultSound != "noSound"  {
                    selectedSound = Sound.getSound(str: defaultSound)
                    let url = Bundle.main.path(forResource: selectedSound?.title, ofType: "mp3")
                    player = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: url!))
                    player.delegate = self.del
                    player.prepareToPlay()
                    if let vol = UserDefaults.standard.value(forKey: "backgroundVolume") as? Float {
                        player.volume = vol
                        sliderData.sliderValue = vol
                    } else {
                        player.volume = 0.5
                        sliderData.sliderValue = 0.5
                    }
                    sliderData.setPlayer(player: self.player!)
                    player.numberOfLoops = -1
                    player.play()
                } else {
                    let url = Bundle.main.path(forResource: "", ofType: "mp3")
                    player = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: url!))
                }
            }



            //bell at the end of a session
            let url = Bundle.main.path(forResource: "bell", ofType: "mp3")
            model.bellPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: url!))
            model.bellPlayer.delegate = self.del

            if let bellVolume = UserDefaults.standard.value(forKey: "bellVolume") as? Float {
                model.bellPlayer.volume = bellVolume
                bellSlider.sliderValue = bellVolume
            } else {
                model.bellPlayer.volume = 0.5
                bellSlider.sliderValue = 0.5
            }
            bellSlider.setPlayer(player: model.bellPlayer)

            if model.selectedMeditation?.url != "" {
                if  let url = URL(string: model.selectedMeditation?.url ?? "") {
                    let playerItem = AVPlayerItem(url: url)
                    self.mainPlayer = AVPlayer(playerItem: playerItem)
                    mainPlayer.play()
                    model.startCountdown()
                }
            } else if model.selectedMeditation?.belongsTo != "Timed Meditation" && model.selectedMeditation?.belongsTo != "Open-ended Meditation"  {
                let url = Bundle.main.path(forResource: model.selectedMeditation?.title ?? "", ofType: "mp3")
                self.mainPlayer = AVPlayer(url: URL(fileURLWithPath: url!))
                mainPlayer.play()
                model.startCountdown()
            } else {
                model.startCountdown()
            }
        }
        .onDisappear {
            if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "gratitude" {
                UserDefaults.standard.setValue("meditate", forKey: K.defaults.onboarding)
            }
            if player.isPlaying {
                player.stop()
            }
            if model.selectedMeditation?.belongsTo != "Timed Meditation" && model.selectedMeditation?.belongsTo != "Open-ended Meditation"  {
                if (mainPlayer.rate != 0 && mainPlayer.error == nil) {
                    self.mainPlayer.rate = 0
                }
            }
        }
    }
    func goForward() {
        guard let duration  = mainPlayer?.currentItem?.duration else {
            return
        }
        let playerCurrentTime = CMTimeGetSeconds(mainPlayer!.currentTime())
        let newTime = playerCurrentTime + 15

        if newTime < (CMTimeGetSeconds(duration) - 15) {

            let time2: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
            self.mainPlayer!.seek(to: time2, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        }
    }

    func goBackward() {
        let playerCurrentTime = CMTimeGetSeconds(mainPlayer!.currentTime())
            var newTime = playerCurrentTime - 15

            if newTime < 0 {
                newTime = 0
            }
        let time2: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
        mainPlayer!.seek(to: time2, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
    }


    //MARK: - nav
    var backArrow: some View {
        Image(systemName: "arrow.backward")
            .font(.system(size: 24))
            .foregroundColor(Clr.lightGray)
            .onTapGesture {
                withAnimation {
                    if UserDefaults.standard.string(forKey: K.defaults.onboarding) != "gratitude" {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        Analytics.shared.log(event: .play_tapped_back)
                        model.stop()
                        viewRouter.currentPage = .meditate
                    }
                }
            }
    }
    var sound: some View {
        Image(systemName: "music.note.list")
            .font(.system(size: 24))
            .foregroundColor(Clr.lightGray)
            .onTapGesture {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                withAnimation {
                    Analytics.shared.log(event: .play_tapped_sound)
                    showNatureModal = true
                }
            }
    }
    var heart: some View {
        Image(systemName: favorited ? "heart.fill" : "heart")
            .font(.system(size: 24))
            .foregroundColor(favorited ? Color.red : Clr.lightGray)
            .onTapGesture {
                Analytics.shared.log(event: .play_tapped_favorite)
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                if let med = model.selectedMeditation {
//                    Analytics.shared.log(event: "favorited_\(med.returnEventName())")
                    model.favorite(selectMeditation: med)
                }
                favorited.toggle()
            }
    }

    //MARK: - tutorial modal
    struct TutorialModal: View {
        @Binding var show: Bool

        var body: some View {
           GeometryReader { g in
                VStack(spacing: 10) {
                    Spacer()
                    HStack(alignment: .center) {
                        Spacer()
                        VStack(alignment: .center, spacing: 0) {
                            HStack {
                                Spacer()
                                Text("🔔 New: increase & decrease bell volume")
                                    .font(Font.mada(.bold, size: 28))
                                    .foregroundColor(Clr.black2)
                                    .frame(height: g.size.height * 0.06)
                                Spacer()
                            }.padding([.top, .horizontal], 40)
                            Img.tutorialImage
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: g.size.width * 0.85 * 0.9, height: g.size.height * 0.55 * 0.65)
                            Spacer()
                            Button {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                withAnimation {
                                    show = false
                                    UserDefaults.standard.setValue(true, forKey: "playTutorialModal")
                                }
                            } label: {
                                Capsule()
                                    .fill(Clr.brightGreen)
                                    .overlay(
                                        Text("Got it!")
                                            .font(Font.mada(.bold, size: 18))
                                            .foregroundColor(.white)
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.5)
                                    )
                                    .frame(width: g.size.width * 0.7 * 0.5, height: g.size.height * 0.05)
                            }.buttonStyle(NeumorphicPress())
                                .padding()
                            Spacer()
                        }
                        .font(Font.mada(.regular, size: 18))
                        .frame(width: g.size.width * 0.85, height: g.size.height * (K.hasNotch() ? 0.60 : 0.65), alignment: .center)
                        .minimumScaleFactor(0.05)
                        .background(Clr.darkWhite)
                        .neoShadow()
                        .cornerRadius(12)
                        .offset(y: -50)
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
    }

    //MARK: - nature modal
    struct NatureModal: View {
        @State private var volume: Double = 0.0
        @Binding var show: Bool
        @Binding var sound: Sound?
        var change: () -> Void
        var player: AVAudioPlayer?
        @Binding var sliderData: SliderData
        @Binding var bellSlider: SliderData

        var  body: some View {
            GeometryReader { g in
                VStack {
                    Spacer()
                    HStack(alignment: .center) {
                        Spacer()
                        VStack(alignment: .center, spacing: 0) {
                            Text("Background Noise")
                                .foregroundColor(Clr.black1)
                                .font(Font.mada(.bold, size: 24))
                                .lineLimit(1)
                                .minimumScaleFactor(0.05)
                                .multilineTextAlignment(.center)
                                .padding(.bottom)
                            HStack {
                                SoundButton(type: .nature, selectedType: $sound, change: self.change, player: player, sliderData: $sliderData)
                                SoundButton(type: .rain, selectedType: $sound, change: self.change, player: player, sliderData: $sliderData)
                                SoundButton(type: .night, selectedType: $sound, change: self.change, player: player, sliderData: $sliderData)
                                SoundButton(type: .beach, selectedType: $sound, change: self.change, player: player, sliderData: $sliderData)
                                SoundButton(type: .fire, selectedType: $sound, change: self.change, player: player, sliderData: $sliderData)
                            }
                            GeometryReader { geometry in
                                Slider(value: self.$sliderData.sliderValue, in: 0.0...3.0, step: 0.03)
                                    .accentColor(Clr.darkgreen)
                            }.frame(height: 30)
                                .padding(.horizontal, 30)
                                .padding(.top)
                            Text("Bell Volume")
                                .foregroundColor(Clr.black1)
                                .font(Font.mada(.bold, size: 24))
                                .lineLimit(1)
                                .minimumScaleFactor(0.05)
                                .multilineTextAlignment(.center)
                                .padding()
                            GeometryReader { geometry in
                                Slider(value: self.$bellSlider.sliderValue, in: 0.0...1.0, step: 0.01)
                                    .accentColor(Clr.darkgreen)
                            }.frame(height: 30)
                                .padding(.horizontal, 30)
                                .padding(.top, 10)
                            Button {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                withAnimation {
                                    show = false
                                }
                                UserDefaults.standard.setValue(sliderData.sliderValue, forKey: "backgroundVolume")
                                UserDefaults.standard.setValue(bellSlider.sliderValue, forKey: "bellVolume")
                            } label: {
                                Text("Done")
                                    .font(Font.mada(.bold, size: 18))
                                    .foregroundColor(Clr.black2)
                                    .frame(width: g.size.width/3, height: 35)
                                    .background(Clr.yellow)
                                    .clipShape(Capsule())
                                    .padding(.top, 25)
                            }
                            .neoShadow()
                            .animation(.default)

                            
                        }.frame(width: g.size.width * 0.85, height: g.size.height * 0.45, alignment: .center)
                        .background(Clr.darkWhite)
                        .cornerRadius(20)
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
    }

    struct SoundButton: View {
        var type: Sound?
        @Binding var selectedType: Sound?
        var change: () -> Void
        var player: AVAudioPlayer?
        @Binding var sliderData: SliderData

        var body: some View {
            Button {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                withAnimation {
                    if selectedType == type {
                        Analytics.shared.log(event: .play_tapped_sound_noSound)
                        selectedType = .noSound
                        player?.pause()
                    } else {
                        Analytics.shared.log(event: AnalyticEvent.getSound(sound: type!))
                        selectedType = type
                        change()
                    }
                    UserDefaults.standard.setValue(selectedType?.title, forKey: "sound")
                }
            } label: {
                ZStack {
                    Rectangle()
                        .fill(selectedType == type ? Clr.darkgreen : Color.gray.opacity(0.5))
                        .aspectRatio(1.0, contentMode: .fit)
                        .cornerRadius(12)
                    type?.img
                        .resizable()
                        .renderingMode(.template)
                        .padding(10)
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.white)
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: type != selectedType ? 40 : 0, height: 3)
                        .opacity(0.9)
                        .rotationEffect(.degrees(-45))
                }.frame(width: 50, height: 50)
            }.buttonStyle(NeumorphicPress())

        }
    }


     func changeSound() {
        player.stop()
        let url = Bundle.main.path(forResource: selectedSound?.title, ofType: "mp3")
        player = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: url!))
        player.delegate = self.del
        player.numberOfLoops = -1
        player.volume = sliderData.sliderValue
        self.data = .init(count: 0)
        player.prepareToPlay()
        self.player.play()
        self.sliderData.setPlayer(player: player!)
    }
}

import Combine

final class SliderData: ObservableObject {
  let didChange = PassthroughSubject<SliderData,Never>()
    var player: AVAudioPlayer?

    var sliderValue: Float = 0 {
        willSet {
            updateVolume(vol: newValue)
            didChange.send(self)
        }
    }

    func updateVolume(vol: Float) {
        self.player?.volume = vol
    }

    func setPlayer(player: AVAudioPlayer) {
        self.player = player
    }
}


class AVdelegate : NSObject,AVAudioPlayerDelegate{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name("Finish"), object: nil)
    }
}


struct Play_Previews: PreviewProvider {
    static var previews: some View {
        Play()
            .environmentObject(MeditationViewModel())
    }
}
