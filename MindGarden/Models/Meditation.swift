//
//  Meditation.swift
//  MindGarden
//
//  Created by Mark Jones on 8/7/21.
//

import SwiftUI
// https://feed.podbean.com/mindgarden/feed.xml
struct Meditation: Hashable {
    let title: String
    let description: String
    let belongsTo: String
    let category: Category
    let img: Image
    let type: MeditationType
    let id: Int
    let duration: Float
    let reward: Int
    let url: String
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: Meditation, rhs: Meditation) -> Bool {
        return lhs.title == rhs.title
    }

    static var lockedMeditations = [25,41,42,43,37,39,40,49,50,51,52,53,54]

    func returnEventName() -> String {
        return self.title.replacingOccurrences(of: "?", with: "").replacingOccurrences(of: "&", with: "x").replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: ",", with: "_")
            .replacingOccurrences(of: " ", with: "_")
            .replacingOccurrences(of: "7", with: "seven")
            .lowercased()
    }

    static var allMeditations = [
//        Meditation(title: "Open-Ended Meditation", description: "Unguided meditation with no time limit, with the option to add a gong sounds every couple of minutes.", belongsTo: "none", category: .unguided, img: Img.starfish, type: .course, id: 1, duration: 0, reward: 0),

        Meditation(title: "Timed Meditation", description: "Timed unguided (no talking) meditation, with the option to turn on background noises such as rain. A bell will signal the end of your session.", belongsTo: "none", category: .unguided, img: Img.chatBubble, type: .course, id: 2, duration: 0, reward: 0, url: ""),
        Meditation(title: "1 Minute Meditation", description: "Timed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal the end of your session.",  belongsTo: "Timed Meditation", category: .unguided, img: Img.daisy3, type: .lesson, id: 3, duration: 60, reward: 2, url: ""),
        Meditation(title: "2 Minute Meditation", description: "Timed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal the end of your session.",  belongsTo: "Timed Meditation", category: .unguided, img: Img.daisy3, type: .lesson, id: 4, duration: 120, reward: 4, url: ""),
        Meditation(title: "5 Minute Meditation", description: "Timed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal the end of your session.",  belongsTo: "Timed Meditation", category: .unguided, img: Img.daisy3, type: .lesson, id: 5, duration: 300, reward: 6, url: ""),
        Meditation(title: "10 Minute Meditation", description: "Timed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal the end of your session.",  belongsTo: "Timed Meditation", category: .unguided, img: Img.daisy3, type: .lesson, id: 28, duration: 600, reward: 10, url: ""),
        Meditation(title: "15 Minute Meditation", description: "Timed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal the end of your session.",  belongsTo: "Timed Meditation", category: .unguided, img: Img.daisy3, type: .lesson, id: 29, duration: 900, reward: 14, url: ""),
        Meditation(title: "20 Minute Meditation", description: "Timed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal the end of your session.",  belongsTo: "Timed Meditation", category: .unguided, img: Img.daisy3, type: .lesson, id: 30, duration: 1200, reward: 17, url: ""),
        Meditation(title: "25 Minute Meditation", description: "Timed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal the end of your session.",  belongsTo: "Timed Meditation", category: .unguided, img: Img.daisy3, type: .lesson, id: 31, duration: 1500, reward: 20, url: ""),
        Meditation(title: "30 Minute Meditation", description: "Timed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal the end of your session.",  belongsTo: "Timed Meditation", category: .unguided, img: Img.daisy3, type: .lesson, id: 32, duration: 1800, reward: 22, url: ""),
        Meditation(title: "45 Minute Meditation", description: "Timed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal the end of your session.",  belongsTo: "Timed Meditation", category: .unguided, img: Img.daisy3, type: .lesson, id: 33, duration: 2700, reward: 25, url: ""),
        Meditation(title: "1 Hour Meditation", description: "Timed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal the end of your session.",  belongsTo: "Timed Meditation", category: .unguided, img: Img.daisy3, type: .lesson, id: 34, duration: 3600, reward: 30, url: ""),
        Meditation(title: "2 Hour Meditation", description: "Timed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal the end of your session.",  belongsTo: "Timed Meditation", category: .unguided, img: Img.daisy3, type: .lesson, id: 35, duration: 7200, reward: 35, url: ""),

        // Beginners Course
        Meditation(title: "Intro to Meditation", description: "Learn how to meditate and why making it a habit can drastically improve happiness, focus and so much more", belongsTo: "none", category: .beginners, img: Img.juiceBoxes, type: .course, id: 6, duration: 0, reward: 0, url: "1d"),
        Meditation(title: "Why Meditate?", description: "Learn why millions of people around the world use this daily practice.", belongsTo: "Intro to Meditation", category: .courses, img: Img.juiceBoxes, type: .lesson, id: 7, duration: 320, reward: 8, url: ""),
        Meditation(title: "Create Your Anchor", description: "Learn how to create an anchor that can help ground you during your most busy and stormy seasons.", belongsTo: "Intro to Meditation", category: .courses, img: Img.juiceBoxes, type: .lesson, id: 8, duration: 322, reward: 8, url: ""),
        Meditation(title: "Tuning Into Your Body", description: "Discover how to use the body scan meditation to become more aware of your bodily experiences and the emotions tied to them.", belongsTo: "Intro to Meditation", category: .courses, img: Img.juiceBoxes, type: .lesson, id: 9, duration: 429, reward: 8, url: ""),
        Meditation(title: "Gaining Clarity", description: "Learn how meditating can help you think and observe much more clearly.", belongsTo: "Intro to Meditation", category: .courses, img: Img.juiceBoxes, type: .lesson, id: 10, duration: 292, reward: 8, url: ""),
        Meditation(title: "Stress Antidote", description: "Learn how daily meditation can be the perfect cure and preventer of stress and anxiety", belongsTo: "Intro to Meditation", category: .courses, img: Img.juiceBoxes, type: .lesson, id: 12, duration: 365, reward: 8, url: ""),
        Meditation(title: "Compassion & Self-Love", description: "Discover how meditating can create boundless amounts of love & compassion for yourself & the people around you", belongsTo: "Intro to Meditation", category: .courses, img: Img.juiceBoxes, type: .lesson, id: 13, duration: 314, reward: 8, url: ""),
        Meditation(title: "Joy on demand", description: "Discover how meditating can help you create the super power of generating happiness on demand.", belongsTo: "Intro to Meditation", category: .courses, img: Img.juiceBoxes, type: .lesson, id: 11, duration: 324, reward: 8, url: ""),

        //Intermediate Course
        Meditation(title: "7 Days to Happiness", description: "A 7 day series, where we use meditation to become focused, happier and motivated.", belongsTo: "none", category: .courses, img: Img.kiwi, type: .course, id: 14, duration: 0, reward: 0, url: ""),
        Meditation(title: "Clearing the Mind", description: "Learn the fundamentals of clearing all the noise in your head so you can finally learn to listen the right signals.", belongsTo: "7 Days to Happiness", category: .beginners, img: Img.gnome, type: .single_and_lesson, id: 15, duration: 617, reward: 10, url: "https://mcdn.podbean.com/mf/web/khbnmt/1454C_Clearing_the_Mind_10_min_VOCALS929z1.mp3"),
        Meditation(title: "Cultivate Self Love", description: "Do you constantly put your self down? Learn the basics of loving yourself and accepting who you are.", belongsTo: "7 Days to Happiness", category: .growth, img: Img.lemon, type: .single_and_lesson, id: 16, duration: 629, reward: 10, url: "https://mcdn.podbean.com/mf/web/jsffxx/1441_Cultivate_Beautiful_Self_Love_-_10_min_VOCALSa4nt3.mp3"),
        Meditation(title: "Creativity & Inspiration", description: "Do you constantly feel stuck? Learn how to break-through and unleash the creativity hidden inside you", belongsTo: "7 Days to Happiness", category: .focus, img: Img.pencil, type: .single_and_lesson, id: 17, duration: 606, reward: 10, url: "https://mcdn.podbean.com/mf/web/bgbwzn/1446C_Enhance_Creativity_and_Boost_Inspiration_10_min_VOCALSaiunb.mp3"),
        Meditation(title: "Sustain Focus & Increase Motivation", description: "Build the discipline of laser like focus and rock solid motivation through some breath work and simple observation", belongsTo: "7 Days to Happiness", category: .focus, img: Img.target, type: .single_and_lesson, id: 18, duration: 615, reward: 10, url: "https://mcdn.podbean.com/mf/web/244bfv/1440C_Sustain_Focus_and_Increase_Motivation_10_min_VOCALS8fk39.mp3"),
        Meditation(title: "The Basics", description: "A simple 10 minute guided meditaiton you can do anywhere at anytime, empty the mind, get relaxed and receive clarity.", belongsTo: "7 Days to Happiness", category: .beginners, img: Img.icecream, type: .single_and_lesson, id: 19, duration: 616, reward: 10, url: "https://mcdn.podbean.com/mf/web/2p2ww9/1433_10_Minute_Guided_Meditation_that_you_can_listen_to_every_day_VOCALS9v8ek.mp3"),
        Meditation(title: "Thankful Meditation for Gratitude", description: "Gratitude is the easiest thing you can do to become happier, learn to truly be thankful when having a clear focused mind.", belongsTo: "7 Days to Happiness", category: .growth, img: Img.hands, type: .single_and_lesson, id: 20, duration: 608, reward: 10, url: "https://mcdn.podbean.com/mf/web/ez7xsw/1456C_Thankful_Meditation_for_Gratitude_10_min_VOCALSbfhth.mp3"),
        Meditation(title: "Life is Beautiful", description: "When you have no agenda, and simply observe you come to realize just how breath taking life truly is.", belongsTo: "7 Days to Happiness", category: .growth, img: Img.tree, type: .single_and_lesson, id: 21, duration: 623, reward: 10, url: "https://mcdn.podbean.com/mf/web/5w8mig/1530_A_Meditation_Called_Life_is_Beautiful_10_min_VOCALS99c8u.mp3"),

        // Singles
        Meditation(title: "30 Second Meditation", description: "A super quick, 30 second breath work session.", belongsTo: "none", category: .all, img: Img.strawberryMilk, type: .single, id: 22, duration: 37, reward: 1, url: ""),
        Meditation(title: "Basic Guided Meditation", description: "A 5 minute guided meditation to help you start or end the day in a mindful matter.", belongsTo: "none", category: .beginners, img: Img.starfish, type: .single, id: 23, duration: 310, reward: 5, url: "https://mcdn.podbean.com/mf/web/8cuz7s/Basic_Guided_Meditationbwagl.mp3"),
        Meditation(title: "Semi-Guided Meditation", description: "A 10 minute semi-guided meditation for more advanced meditators looking to start or end their day present, focused, and calm.", belongsTo: "none", category: .beginners, img: Img.bonfire, type: .single, id: 24, duration: 607, reward: 10, url: "https://mcdn.podbean.com/mf/web/56xviu/Semi-Guided_Meditation6qqb0.mp3"),
        Meditation(title: "Meditation for Focus", description: "A simple 5 minute guided meditation to help you calm your mind, and enter a relaxed focused state.", belongsTo: "none", category: .focus, img: Img.magnifyingGlass, type: .single, id: 25, duration: 315, reward: 5, url: "https://mcdn.podbean.com/mf/web/7d2g5m/Meditation_for_Focus8fetr.mp3"),
        Meditation(title: "Body Scan", description: "A short guided meditation to help you tune into your body, reconnect to your physical self and notice any sensations without any judgement. ", belongsTo: "none", category: .all, img: Img.heart, type: .single, id: 25, duration: 345, reward: 5, url: "https://mcdn.podbean.com/mf/web/3dqhaz/Body_Scanairn6.mp3"),
        Meditation(title: "Better Faster Sleep", description: "A 5 minute guided meditation to help you relax, let go and fall into a deep restful sleep.", belongsTo: "none", category: .sleep, img: Img.moon, type: .single, id: 27, duration: 335, reward: 5, url: "https://mcdn.podbean.com/mf/web/n283c3/Better_Faster_Sleep9pxwf.mp3"),
        // girl
        Meditation(title: "Chronic Pain, Safe Place", description: "Learn to deal with chronic stress and ease the emotional stress it brings through breath work.", belongsTo: "none", category: .anxiety, img: Img.house, type: .single, id: 36, duration: 828, reward: 15, url: "https://mcdn.podbean.com/mf/web/3x43dz/228_Relieve_Stress_and_Activate_Intuition_VOCALSaj10d.mp3"),
        Meditation(title: "A Sense of Gratitude", description: "In this meditation learn how to cultivate a sense of gratitude.", belongsTo: "none", category: .growth, img: Img.wateredPot, type: .single, id: 37, duration: 1147, reward: 20, url: "https://mcdn.podbean.com/mf/web/gjbfjp/365_Sense_of_Gratitude_VOCALS6inm8.mp3"),
        Meditation(title: "Relieve Stress, Activate Intuition", description: "Learn the secret to relieving stress, and activating your inner intuition", belongsTo: "none", category: .anxiety, img: Img.brain, type: .single, id: 38, duration: 1225, reward: 21, url: "https://mcdn.podbean.com/mf/web/3x43dz/228_Relieve_Stress_and_Activate_Intuition_VOCALSaj10d.mp3"),
        Meditation(title: "Deep Sleep", description: "A 20 minute meditation for people looking to quickly fall into a deep sleep", belongsTo: "none", category: .sleep, img: Img.moonFull, type: .single, id: 39, duration: 1285, reward: 20, url: "https://mcdn.podbean.com/mf/web/4vxfi9/366_Deep_Sleep_VOCALS86ffx.mp3"),
        Meditation(title: "Meditation for Happiness", description: "Learn that happiness, just like anything else in life can be learned..", belongsTo: "none", category: .growth, img: Img.daisy3, type: .single, id: 40, duration: 1227, reward: 20, url: "https://mcdn.podbean.com/mf/web/hu3net/372_Meditation_for_Happiness_VOCALS827d7.mp3"),
        Meditation(title: "Build Confidence", description: "Learn to feel confidence and break away from your negative thought patterns", belongsTo: "none", category: .confidence, img: Img.sunglasses, type: .single, id: 41, duration: 1160, reward: 20, url: "https://mcdn.podbean.com/mf/web/2aysdh/358_Experience_Confidence_VOCALS64r7q.mp3"),
        Meditation(title: "Emotional Balance", description: "Learn to balance your tricky emotions and experience peace & clarity", belongsTo: "none", category: .growth, img: Img.watermelon, type: .single, id: 42, duration: 1143, reward: 20, url: "https://mcdn.podbean.com/mf/web/etnx62/361_Emotional_Balance_VOCALSaba3g.mp3"),
        Meditation(title: "Basic Confidence Meditation", description: "A basic guided meditation to build confidence and break away from your negative thought patterns", belongsTo: "none", category: .confidence, img: Img.candle, type: .single, id: 43, duration: 845, reward: 15, url: "https://mcdn.podbean.com/mf/web/2aysdh/358_Experience_Confidence_VOCALS64r7q.mp3"),
        Meditation(title: "It Lies Within You", description: "Learn that confidence lies within you and how to bring it out", belongsTo: "none", category: .confidence, img: Img.gnome, type: .single, id: 44, duration: 1154, reward: 20, url: "https://mcdn.podbean.com/mf/web/2aysdh/358_Experience_Confidence_VOCALS64r7q.mp3"),
        Meditation(title: "How to Meditate", description: "Learn how to meditate and simply it truly is", belongsTo: "none", category: .beginners, img: Img.books, type: .single, id: 45, duration: 305, reward: 5, url: "https://mcdn.podbean.com/mf/web/tr4dnq/1403_How_To_Meditate_VOCALSbrsfv.mp3"),
        Meditation(title: "Relieve Anxiety", description: "In this guided meditation gain control over your anxiety & experience peace and calmness.", belongsTo: "none", category: .anxiety, img: Img.cloud, type: .single, id: 46, duration: 609, reward: 10, url: "https://mcdn.podbean.com/mf/web/y39bbt/1432_Guided_Meditation_for_Anxiety_10_min_VOCALSajbr7.mp3"),
        Meditation(title: "Good Morning, Positive Energy", description: "Learn how to cultive creatity and boost inspiration by being present.", belongsTo: "none", category: .growth, img: Img.eggs, type: .single, id: 49, duration: 607, reward: 10, url: "https://mcdn.podbean.com/mf/web/h6wmv9/1523_Good_Morning_Positive_Energy_Meditation_10_min_VOCALSbgvsn.mp3"),
        Meditation(title: "Affirmations", description: "Affirmations for health, wealth, love and happiness.", belongsTo: "none", category: .growth, img: Img.bee, type: .single, id: 50, duration: 632, reward: 10, url: "https://mcdn.podbean.com/mf/web/y39bbt/1432_Guided_Meditation_for_Anxiety_10_min_VOCALSajbr7.mp3"),
        Meditation(title: "Clearing Fears", description: "Learn to focus on what you can control & to quiet your fears", belongsTo: "none", category: .anxiety, img: Img.hand, type: .single, id: 51, duration: 547, reward: 10, url: "https://mcdn.podbean.com/mf/web/rtmi4k/1540_Clearing_Fears_Held_in_the_Body_Scan_9_min_VOCALS8kge3.mp3"),
        Meditation(title: "Handle Insecurity", description: "Learn to quiet your insecurities and replace it with inspiration.", belongsTo: "none", category: .anxiety, img: Img.wave, type: .single, id: 52, duration: 1185, reward: 20, url: "https://mcdn.podbean.com/mf/web/xm4jyj/390_Handle_Insecurity_VOCALS92hmv.mp3"),
        Meditation(title: "Seize the Day", description: "Prepare yourself to crush the day ahead.", belongsTo: "none", category: .anxiety, img: Img.sun, type: .single, id: 53, duration: 626, reward: 10, url: "https://mcdn.podbean.com/mf/web/rucidp/1398_Seize_the_Day_Morning_Meditation_VOCALSb63wx.mp3"),
        Meditation(title: "Bedtime Meditation", description: "Relax & fall asleep to this peaceful meditation", belongsTo: "none", category: .sleep, img: Img.sheep, type: .single, id: 54, duration: 590, reward: 10, url: "https://mcdn.podbean.com/mf/web/rucidp/1398_Seize_the_Day_Morning_Meditation_VOCALSb63wx.mp3"),
        Meditation(title: "Studying Meditation", description: "Want an edge over your classmates? Use this meditation before very study session to enter a laser focused state.", belongsTo: "none", category: .focus, img: Img.kidStudying, type: .single, id: 55, duration: 486, reward: 12, url: "https://mcdn.podbean.com/mf/web/293n4c/meditation-for-studying.mp3"),
        Meditation(title: "Exam Anxiety Meditation", description: "Feeling test jitters? Can't focus? Overthinking? Use this meditation to enter a calm zen state.", belongsTo: "none", category: .anxiety, img: Img.cando, type: .single, id: 56, duration: 672, reward: 10, url: "https://mcdn.podbean.com/mf/web/4ywe6m/exam-anxiety-meditation.mp3"),

        // Open Ended Meditation
        Meditation(title: "Open-ended Meditation", description: "Untimed unguided (no talking) meditation, with the option to turn on background noises such as rain. You may also play a bell every x minutes to stay focused.", belongsTo: "none", category: .unguided, img: Img.bell, type: .course, id: 57, duration: 0, reward: 0, url: ""),
        Meditation(title: "Play bell every 1 minute", description: "Untimed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal you every 1 minute.",  belongsTo: "Open-ended Meditation", category: .unguided, img: Img.bell, type: .lesson, id: 58, duration: -1, reward: -1, url: ""),
        Meditation(title: "Play bell every 2 minutes", description: "Untimed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal you every 2 minutes.",  belongsTo: "Open-ended Meditation", category: .unguided, img: Img.bell, type: .lesson, id: 59, duration: -1, reward: -1, url: ""),
        Meditation(title: "Play bell every 5 minutes", description: "Untimed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal you every 5 minutes.",  belongsTo: "Open-ended Meditation", category: .unguided, img: Img.bell, type: .lesson, id: 60, duration: -1, reward: -1, url: ""),
        Meditation(title: "Play bell every 10 minutes", description: "Untimed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal you every 10 minutes.",  belongsTo: "Open-ended Meditation", category: .unguided, img: Img.bell, type: .lesson, id: 61, duration: -1, reward: -1, url: ""),
        Meditation(title: "Play bell every 15 minutes", description: "Untimed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal you every 15 minutes.",  belongsTo: "Open-ended Meditation", category: .unguided, img: Img.bell, type: .lesson, id: 62, duration: -1, reward: -1, url: ""),
        Meditation(title: "Play bell every 20 minutes", description: "Untimed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal you every 20 minutes.",  belongsTo: "Open-ended Meditation", category: .unguided, img: Img.bell, type: .lesson, id: 63, duration: -1, reward: -1, url: ""),
        Meditation(title: "Play bell every 25 minutes", description: "Untimed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal you every 25 minutes.",  belongsTo: "Open-ended Meditation", category: .unguided, img: Img.bell, type: .lesson, id: 64, duration: -1, reward: -1, url: ""),
        Meditation(title: "Play bell every 30 minutes", description: "Untimed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal you every 30 minutes.",  belongsTo: "Open-ended Meditation", category: .unguided, img: Img.bell, type: .lesson, id: 65, duration: -1, reward: -1, url: ""),
        Meditation(title: "Play bell every 1 hour", description: "Timed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal the end of your session.",  belongsTo: "Open-ended Meditation", category: .unguided, img: Img.bell, type: .lesson, id: 66, duration: -1, reward: -1, url: ""),
    ]
}

enum MeditationType {
    case single
    case lesson
    case course
    case single_and_lesson
}
