//
//  AnalyticEvent.swift
//  MindGarden
//
//  Created by Mark Jones on 10/7/21.
//

import Foundation

enum AnalyticEvent {
    case sceneDidBecomeActive
    case launchedApp

    //MARK: - Onboarding
    case screen_load_onboarding //
    case onboarding_notification_on
    case onboarding_notification_off
    case onboarding_tapped_continue //
    case onboarding_tapped_sign_in //

    //experience
    case screen_load_experience //
    case experience_tapped_none //
    case experience_tapped_some //
    case experience_tapped_alot //
    case experience_tapped_continue //

    //MARK: - Reason
    case screen_load_reason
    case reason_tapped_sleep
    case reason_tapped_focus
    case reason_tapped_stress
    case reason_tapped_continue

    //MARK: - Review
    case screen_load_review
    case review_tapped_tutorial
    case review_tapped_explore

    //name
    case screen_load_name //
    case name_tapped_continue //
    //notification
    case screen_load_notification //
    case notification_tapped_done //
    case notification_tapped_turn_on //
    case notification_success //
    case notification_tapped_skip //
    case notification_go_to_settings
    // home + garden
    case onboarding_finished_mood //
    case onboarding_finished_gratitude //
    case onboarding_finished_meditation //
    case onboarding_finished_calendar //
    case onboarding_finished_stats //
    case onboarding_finished_single //
    case onboarding_finished_single_okay //
    case onboarding_finished_single_course //
    case onboarding_claimed_strawberry //
    case onboarding_came_from_referral // 

    //MARK: - Authentication
    case screen_load_onboarding_signup //
    case screen_load_onboarding_signin //
    case screen_load_signup //
    case screen_load_signin //
    case authentication_signin_successful //
    case authentication_signup_successful //
    case authentication_tapped_google //
    case authentication_tapped_apple //
    case authentication_tapped_forgot_password //

    //MARK: - Garden
    case screen_load_garden //
    case garden_next_month //
    case garden_previous_month //
    case garden_tapped_single_day //
    // left & right arrow in single day modal if present
    case garden_tapped_single_next_session //
    case garden_tapped_single_previous_session //

    //MARK: - HOME
    case screen_load_home //
    case home_tapped_plant_select //
    case home_selected_plant //
    case home_tapped_categories //
    case home_tapped_search //
    case home_tapped_recents //
    case home_tapped_favorites //
    case home_tapped_featured //
    case home_tapped_recent_meditation //
    case home_tapped_favorite_meditation //

    // bonus modal
    case home_tapped_bonus //
    case home_tapped_pro
    case home_claim_daily //
    case home_claim_seven //
    case home_claim_thirty //

    //MARK: - Store
    case screen_load_store //
    case store_tapped_plant_tile //
    case store_tapped_purchase_modal_buy //
    case store_tapped_confirm_modal_confirm //
    case store_tapped_confirm_modal_cancel //
    case store_tapped_success_modal_okay //
    case store_tapped_store_option //
    case store_tapped_badges_option //
    case store_tapped_rate_app //
    case store_tapped_refer_friend
    case store_tapped_go_pro
    case store_tapped_badge_tile

    //MARK: - Middle
    case screen_load_middle //
    case middle_tapped_favorite //
    case middle_tapped_unfavorite
    case middle_tapped_back //
    case middle_tapped_recommended //
    case middle_tapped_row //
    case middle_tapped_row_favorite //
    case middle_tapped_row_unfavorite
    case middle_tapped_locked_recommended

    //MARK: - Play
    case screen_load_play //
    case play_tapped_back //
    case play_tapped_favorite //
    case play_tapped_unfavorite
    case play_tapped_sound //
    case play_tapped_sound_rain //
    case play_tapped_sound_night //
    case play_tapped_sound_beach //
    case play_tapped_sound_nature //
    case play_tapped_sound_fire //
    case play_tapped_sound_noSound //

    //MARK: - Finished
    case screen_load_finished //
    case finished_tapped_share //
    case finished_tapped_favorite //
    case finished_tapped_unfavorite
    case finished_tapped_finished //
    case finished_med_1_minute_meditation
    case finished_med_2_minute_meditation
    case finished_med_5_minute_meditation
    case finished_med_10_minute_meditation
    case finished_med_15_minute_meditation
    case finished_med_20_minute_meditation
    case finished_med_25_minute_meditation
    case finished_med_30_minute_meditation
    case finished_med_45_minute_meditation
    case finished_med_1_hour_meditation
    case finished_med_2_hour_meditation

    case finished_med_why_meditate
    case finished_med_create_your_anchor
    case finished_med_tuning_into_your_body
    case finished_med_gaining_clarity
    case finished_med_stress_antidote
    case finished_med_compassion_x_selflove
    case finished_med_joy_on_demand

    case finished_30_second_meditation
    case finished_basic_guided_meditation
    case finished_semguided_meditation
    case finished_meditation_for_focus
    case finished_anxiety_x_stress
    case finished_body_scan
    case finished_better_faster_sleep
    // girl
    case finished_good_morning__positive_energy
    case finished_affirmations
    case finished_clearing_fears
    case finished_relieve_anxiety
    case relieve_stress__activate_intuition
    case finished_how_to_meditate
    case finished_it_lies_within_you
    case finished_basic_confidence_meditation
    case finished_emotional_balance
    case finished_deep_sleep
    case finished_a_sense_of_gratitude
    case finished_chronic_pain__safe_place
    case finished_life_is_beautiful
    case thankful_meditaiton_for_gratitude
    case sustain_focus_x_increase_motivation
    case finished_cultivate_self_love
    case finished_clearing_the_mind
    case finished_seven_days_to_happiness
    case finished_creativity_x_inspiration
    case finished_the_basics
    case finished_meditation_for_happiness
    case finished_build_confidence
    case finished_handle_insecurity
    case finished_seize_the_day
    case finished_bedtime_meditation

    //MARK: - Profile
    case screen_load_profile //
    case profile_tapped_journey //
    case profile_tapped_settings //
    case profile_tapped_email //
    case profile_tapped_reddit //
    case profile_tapped_invite //
    case profile_tapped_notifications //
    case profile_tapped_instagram //
    case profile_tapped_restore //
    case profile_tapped_feedback //
    case profile_tapped_roadmap //
    case profile_tapped_goPro //
    case profile_tapped_toggle_off_notifs //
    case profile_tapped_toggle_on_notifs //
    case profile_tapped_toggle_off_mindful //
    case profile_tapped_toggle_on_mindful //
    case profile_tapped_logout //
    case profile_tapped_refer //
    case profile_tapped_refer_friend //
    case profile_tapped_rate //
    case profile_tapped_create_account
    //MARK: - Categories
    case screen_load_categories //
    case categories_tapped_unguided //
    case categories_tapped_all //
    case categories_tapped_courses //
    case categories_tapped_anxiety //
    case categories_tapped_focus //
    case categories_tapped_growth //
    case categories_tapped_meditation //
    case categories_tapped_sleep //
    case categories_tapped_confidence //
    case categories_tapped_locked_meditation //

    //MARK: - tabs + plus
    case tabs_tapped_meditate //
    case tabs_tapped_garden //
    case tabs_tapped_store //
    case tabs_tapped_profile //
    case tabs_tapped_plus //
    //plus
    case plus_tapped_mood //
    case plus_tapped_mood_to_pricing
    //mood
    case mood_tapped_angry //
    case mood_tapped_sad //
    case mood_tapped_okay //
    case mood_tapped_happy //
    case mood_tapped_done //
    case mood_tapped_cancel
    //gratitude
    case plus_tapped_gratitude
    case plus_tapped_gratitude_to_pricing
    case gratitude_tapped_done // 
    case gratitude_tapped_cancel
    case gratitude_tapped_prompts

    case plus_tapped_meditate
    case plus_tapped_meditate_to_pricing
    case seventh_time_coming_back

    //pricing
    case screen_load_pricing
}

extension AnalyticEvent {
    static func getSound(sound: Sound) -> AnalyticEvent {
        switch sound {
        case .beach:
            return .play_tapped_sound_beach
        case .fire:
            return .play_tapped_sound_fire
        case .rain:
            return .play_tapped_sound_rain
        case .night:
            return .play_tapped_sound_night
        case .noSound:
            return .play_tapped_sound_noSound
        case .nature:
            return .play_tapped_sound_nature
        }
    }
    static func getTab(tabName: String) -> AnalyticEvent {
        switch tabName {
        case "Garden":
            return .tabs_tapped_garden
        case "Meditate":
            return .tabs_tapped_meditate
        case "Shop":
            return .tabs_tapped_store
        case "Profile":
            return .tabs_tapped_profile
        default:
            return .tabs_tapped_meditate
        }
    }
    static func getCategory(category: String) -> AnalyticEvent {
        switch category {
        case "All": return .categories_tapped_all
        case "Unguided": return .categories_tapped_unguided
        case "Courses": return .categories_tapped_courses
        case "Anxiety": return .categories_tapped_anxiety
        case "Focus": return .categories_tapped_focus
        case "Sleep": return .categories_tapped_sleep
        case "Confidence": return .categories_tapped_confidence
        case "Growth": return .categories_tapped_growth
        default: return .categories_tapped_all
        }
    }
    static func getMeditation(meditation: String) -> AnalyticEvent {
        switch meditation {
        case "finished_1_minute_meditation": return .finished_med_1_minute_meditation
        case "finished_2_minute_meditation": return .finished_med_2_minute_meditation
        case "finished_5_minute_meditation": return .finished_med_5_minute_meditation
        case "finished_10_minute_meditation": return .finished_med_10_minute_meditation
        case "finished_15_minute_meditation": return .finished_med_15_minute_meditation
        case "finished_20_minute_meditation": return .finished_med_20_minute_meditation
        case "finished_25_minute_meditation": return .finished_med_25_minute_meditation
        case "finished_30_minute_meditation": return .finished_med_30_minute_meditation
        case "finished_45_minute_meditation": return .finished_med_45_minute_meditation
        case "finished_1_hour_meditation": return .finished_med_1_hour_meditation
        case "finished_2_hour_meditation": return .finished_med_2_hour_meditation

        case "finished_why_meditate": return .finished_med_why_meditate
        case "finished_create_your_anchor": return .finished_med_create_your_anchor
        case "finished_tuning_into_your_body": return .finished_med_tuning_into_your_body
        case "finished_gaining_clarity": return .finished_med_gaining_clarity
        case "finished_stress_antidote": return .finished_med_stress_antidote
        case "finished_compassion_x_selflove": return .finished_med_compassion_x_selflove
        case "finished_joy_on_demand": return .finished_med_joy_on_demand

        case "finished_30_second_meditation": return .finished_30_second_meditation
        case "finished_basic_guided_meditation": return .finished_basic_guided_meditation
        case "finished_semguided_meditation": return .finished_semguided_meditation
        case "finished_meditation_for_focus": return .finished_meditation_for_focus
        case "finished_anxiety_x_stress": return .finished_anxiety_x_stress
        case "finished_body_scan": return .finished_body_scan
        case "finished_better_faster_sleep": return .finished_better_faster_sleep

        case "finished_good_morning__positive_energy": return .finished_good_morning__positive_energy
        case "finished_affirmations": return .finished_affirmations
        case "finished_clearing_fears": return .finished_clearing_fears
        case "finished_relieve_anxiety": return .finished_relieve_anxiety
        case "finished_relieve_stress__activate_intuition": return .relieve_stress__activate_intuition
        case "finished_how_to_meditate": return .finished_how_to_meditate
        case "finished_it_lies_within_you": return .finished_it_lies_within_you
        case "finished_basic_confidence_meditation": return .finished_basic_confidence_meditation
        case "finished_emotional_balance": return .finished_emotional_balance
        case "finished_deep_sleep": return .finished_deep_sleep
        case "finished_a_sense_of_gratitude": return .finished_a_sense_of_gratitude
        case "finished_chronic_pain__safe_place": return .finished_chronic_pain__safe_place
        case "finished_life_is_beautiful": return .finished_life_is_beautiful
        case "finished_thankful_meditaiton_for_gratitude": return .thankful_meditaiton_for_gratitude
        case "finished_sustain_focus_x_increase_motivation": return .sustain_focus_x_increase_motivation
        case "finished_cultivate_self_love": return .finished_cultivate_self_love
        case "finished_clearing_the_mind": return .finished_clearing_the_mind
        case "finished_seven_days_to_happiness": return .finished_seven_days_to_happiness
        case "finished_creativity_x_inspiration": return .finished_creativity_x_inspiration
        case "finished_the_basics": return .finished_the_basics
        case "finished_meditation_for_happiness": return .finished_meditation_for_happiness
        case "finished_build_confidence": return .finished_build_confidence
        case "finished_handle_insecurity": return .finished_handle_insecurity
        case "finished_seize_the_day": return .finished_seize_the_day
        case "finished_bedtime_meditation": return .finished_bedtime_meditation
        default: return .finished_med_1_minute_meditation
        }
    }
}

extension AnalyticEvent {
    var eventName:String {
        switch self {
        case .sceneDidBecomeActive: return "sceneDidBecomeActive"
        case .launchedApp: return "launchedApp"
        case .screen_load_onboarding: return "screen_load_onboarding"
        case .onboarding_tapped_continue: return "onboarding_tapped_continue"
        case .onboarding_tapped_sign_in: return "onboarding_tapped_sign_in"
        case .screen_load_experience: return "screen_load_experience"
        case .experience_tapped_none: return "experience_tapped_none"
        case .experience_tapped_some: return "experience_tapped_some"
        case .experience_tapped_alot: return "experience_tapped_alot"
        case .experience_tapped_continue: return "experience_tapped_continue"
        case .screen_load_reason: return "screen_load_reason"
        case .reason_tapped_sleep: return "reason_tapped_sleep"
        case .reason_tapped_focus: return "reason_tapped_focus"
        case .reason_tapped_stress: return "reason_tapped_stress"
        case .reason_tapped_continue: return "reason_tapped_continue"
        case .screen_load_name: return "screen_load_name"
        case .name_tapped_continue: return "name_tapped_continue"
        case .screen_load_notification: return "screen_load_notification"
        case .notification_tapped_done: return "notification_tapped_done"
        case .notification_tapped_turn_on: return "notifcation_tapped_turn_on"
        case .notification_success: return "notification_success"
        case .notification_tapped_skip: return "notification_tapped_skip"
        case .notification_go_to_settings: return "notification_go_to_settings"
        case .onboarding_finished_mood: return "onboarding_finished_mood"
        case .onboarding_notification_off: return "onboarding_notification_off"
        case .onboarding_notification_on: return "onboarding_notification_on"
        case .onboarding_finished_gratitude: return "onboarding_finished_meditation"
        case .onboarding_finished_meditation: return "onboarding_finished_meditation"
        case .onboarding_finished_calendar: return "onboarding_finished_calendar"
        case .onboarding_finished_stats: return "onboarding_finished_stats"
        case .onboarding_finished_single: return "onboarding_finshed_single"
        case .onboarding_finished_single_okay: return "onboarding_finshed_single_okay"
        case .onboarding_finished_single_course: return "onboarding_finished_single_course"
        case .screen_load_onboarding_signup: return "screen_load_onboarding_signup"
        case .onboarding_claimed_strawberry: return "onboarding_claimed_strawberry"
        case .screen_load_onboarding_signin:  return "screen_load_onboarding_signin:"
        case .onboarding_came_from_referral: return "onboarding_came_from_referral"
        case .screen_load_signup: return "screen_load_signup"
        case .screen_load_signin: return "screen_load_signin"
        case .authentication_signin_successful: return "authentication_signin_successful"
        case .authentication_signup_successful: return "authentication_signup_successful"
        case .authentication_tapped_google: return "authentication_tapped_google"
        case .authentication_tapped_apple:  return "authentication_tapped_apple"
        case .authentication_tapped_forgot_password: return "authentication_tapped_forgot_password"
        case .screen_load_garden: return "screen_load_garden"
        case .garden_next_month: return "garden_next_month"
        case .garden_previous_month: return "garden_previous_month"
        case .garden_tapped_single_day: return "garden_previous_month"
        case .garden_tapped_single_next_session: return "garden_tapped_single_next_session"
        case .garden_tapped_single_previous_session: return "garden_tapped_single_previous_session"
        case .screen_load_home: return "screen_load_home"
        case .home_tapped_plant_select: return "home_tapped_plant_select"
        case .home_tapped_pro: return "home_tapped_pro"
        case .home_selected_plant: return "home_selected_plant"
        case .home_tapped_categories: return "home_tapped_categories"
        case .home_tapped_search: return "home_tapped_search"
        case .home_tapped_recents: return "home_tapped_recents"
        case .home_tapped_favorites: return "home_tapped_favorites"
        case .home_tapped_featured: return "home_tapped_featured"
        case .home_tapped_recent_meditation: return "home_tapped_recent_meditation"
        case .home_tapped_favorite_meditation: return "home_tapped_favorite_meditation"
        case .home_tapped_bonus: return "home_tapped_bonus"
        case .home_claim_daily: return "home_claim_daily:"
        case .home_claim_seven: return "home_claim_seven"
        case .home_claim_thirty: return "home_claim_thirty"
        case .screen_load_store: return "screen_load_store"
        case .store_tapped_plant_tile: return "store_tapped_plant_tile"
        case .store_tapped_purchase_modal_buy: return "store_tapped_purchase_modal_buy"
        case .store_tapped_confirm_modal_confirm: return "store_tapped_confirm_modal_confirm"
        case .store_tapped_confirm_modal_cancel: return "store_tapped_confirm_modal_cancel"
        case .store_tapped_success_modal_okay: return "store_tapped_success_modal_okay"
        case .store_tapped_store_option: return "store_tapped_store_option"
        case .store_tapped_badges_option: return "store_tapped_badges_option"
        case .store_tapped_rate_app: return "store_tapped_rate_app"
        case .store_tapped_refer_friend: return "store_tapped_refer_friend"
        case .store_tapped_go_pro: return "store_tapped_go_pro"
        case .store_tapped_badge_tile: return "store_tapped_badge_tile"
        case .screen_load_middle: return "screen_load_middle"
        case .middle_tapped_favorite: return "middle_tapped_favorite"
        case .middle_tapped_unfavorite: return "middle_tapped_unfavorite"
        case .middle_tapped_back: return "middle_tapped_back"
        case .middle_tapped_recommended: return "middle_tapped_recommended"
        case .middle_tapped_row: return "middle_tapped_row"
        case .middle_tapped_row_favorite: return "middle_tapped_row_favorite"
        case .middle_tapped_row_unfavorite: return "middle_tapped_row_unfavorite"
        case .middle_tapped_locked_recommended: return "middle_tapped_locked_recommended"
        case .screen_load_play: return "screen_load_play"
        case .play_tapped_back: return "play_tapped_back"
        case .play_tapped_favorite: return "play_tapped_favorite"
        case .play_tapped_unfavorite: return "play_tapped_unfavorite"
        case .play_tapped_sound: return "play_tapped_sound"
        case .play_tapped_sound_rain: return "play_tapped_sound_rain"
        case .play_tapped_sound_night: return "play_tapped_sound_night"
        case .play_tapped_sound_nature: return "play_tapped_sound_nature"
        case .play_tapped_sound_fire: return "play_tapped_sound_fire"
        case .play_tapped_sound_noSound: return "play_tapped_sound_noSound"
        case .screen_load_finished: return "screen_load_finished"
        case .finished_tapped_share: return "finished_tapped_share"
        case .finished_tapped_favorite: return "finished_tapped_favorite"
        case .finished_tapped_unfavorite: return "finished_tapped_unfavorite"
        case .finished_tapped_finished: return "finished_tapped_finished"
        case .finished_med_1_minute_meditation:  return "finished_med_1_minute_meditation"
        case .finished_med_2_minute_meditation: return "finished_med_2_minute_meditation"
        case .finished_med_5_minute_meditation: return "finished_med_5_minute_meditation"
        case .finished_med_10_minute_meditation: return "finished_med_10_minute_meditation"
        case .finished_med_15_minute_meditation: return "finished_med_15_minute_meditation:"
        case .finished_med_20_minute_meditation: return "finished_med_20_minute_meditation"
        case .finished_med_25_minute_meditation: return "finished_med_25_minute_meditation"
        case .finished_med_30_minute_meditation: return "finished_med_30_minute_meditation"
        case .finished_med_45_minute_meditation: return "finished_med_45_minute_meditation"
        case .finished_med_1_hour_meditation: return "finished_med_1_hour_meditation"
        case .finished_med_2_hour_meditation: return "finished_med_2_hour_meditation"
        case .finished_med_why_meditate: return "finished_med_why_meditate"
        case .finished_med_create_your_anchor: return "finished_med_create_your_anchor"
        case .finished_med_tuning_into_your_body: return "finished_med_tuning_into_your_body"
        case .finished_med_gaining_clarity: return "finished_med_gaining_clarity"
        case .finished_med_stress_antidote: return "finished_med_stress_antidote"
        case .finished_med_compassion_x_selflove: return "finished_med_compassion_x_selflove"
        case .finished_med_joy_on_demand: return "finished_med_joy_on_demand"
        case .finished_30_second_meditation: return "finished_30_second_meditation"
        case .finished_basic_guided_meditation: return "finished_basic_guided_meditation"
        case .finished_semguided_meditation: return "finished_semguided_meditation"
        case .finished_meditation_for_focus: return "finished_meditation_for_focus"
        case .finished_anxiety_x_stress: return "finished_anxiety_x_stress"
        case .finished_body_scan: return "finished_body_scan"
        case .finished_better_faster_sleep: return "finished_better_faster_sleep"
        case .finished_good_morning__positive_energy: return "finished_good_morning__positive_energy"
        case .finished_affirmations: return "finished_affirmations"
        case .finished_clearing_fears: return "finished_clearing_fears"
        case .finished_relieve_anxiety: return "finished_relieve_anxiety"
        case .relieve_stress__activate_intuition: return "relieve_stress__activate_intuition"
        case .finished_how_to_meditate: return "finished_how_to_meditate"
        case .finished_it_lies_within_you: return "finished_it_lies_within_you"
        case .finished_basic_confidence_meditation: return "finished_basic_confidence_meditation"
        case .finished_emotional_balance: return "finished_emotional_balance"
        case .finished_deep_sleep: return "finished_deep_sleep"
        case .finished_a_sense_of_gratitude: return "finished_a_sense_of_gratitude"
        case .finished_chronic_pain__safe_place: return "finished_chronic_pain__safe_place"
        case .finished_life_is_beautiful: return "finished_life_is_beautiful"
        case .thankful_meditaiton_for_gratitude: return "thankful_meditaiton_for_gratitude"
        case .sustain_focus_x_increase_motivation: return "sustain_focus_x_increase_motivation"
        case .finished_cultivate_self_love: return "finished_cultivate_self_love"
        case .finished_clearing_the_mind: return "finished_clearing_the_mind"
        case .finished_seven_days_to_happiness: return "finished_seven_days_to_happiness"
        case .finished_creativity_x_inspiration: return "finished_creativity_x_inspiration"
        case .finished_the_basics: return "finished_the_basics"
        case .finished_meditation_for_happiness: return "finished_meditation_for_happiness"
        case .finished_build_confidence: return "finished_build_confidence"
        case .finished_handle_insecurity: return "finished_handle_insecurity"
        case .finished_seize_the_day: return "finished_seize_the_day"
        case .finished_bedtime_meditation: return "finished_bedtime_meditation"
        case .screen_load_profile: return "screen_load_profile"
        case .profile_tapped_journey: return "profile_tapped_journey"
        case .profile_tapped_settings: return "profile_tapped_settings"
        case .profile_tapped_email: return "profile_tapped_email"
        case .profile_tapped_reddit: return "profile_tapped_reddit"
        case .profile_tapped_invite: return "profile_tapped_invite"
        case .profile_tapped_notifications: return "profile_tapped_notifications"
        case .profile_tapped_instagram: return "profile_tapped_instagram"
        case .profile_tapped_restore: return "profile_tapped_restore"
        case .profile_tapped_toggle_off_notifs: return "profile_tapped_toggle_off_notifs"
        case .profile_tapped_toggle_on_notifs: return "profile_tapped_toggle_on_notifs"
        case .profile_tapped_toggle_off_mindful: return "profile_tapped_toggle_on_mindful"
        case .profile_tapped_toggle_on_mindful: return "profile_tapped_toggle_off_mindful"
        case .profile_tapped_logout: return "profile_tapped_logout"
        case .profile_tapped_feedback: return "profile_tapped_feedback"
        case .profile_tapped_roadmap: return "profile_tapped_roadmap"
        case .profile_tapped_goPro: return "profile_tapped_goPro"
        case .profile_tapped_refer_friend: return "profile_tapped_refer_friend"
        case .profile_tapped_refer: return "profile_tapped_refer_friend"
        case .profile_tapped_rate: return "profile_tapped_rate"
        case .profile_tapped_create_account: return "profile_tapped_create_account"
        case .screen_load_categories: return "screen_load_categories"
        case .categories_tapped_unguided: return "categories_tapped_unguided"
        case .categories_tapped_all: return "categories_tapped_all"
        case .categories_tapped_courses: return "categories_tapped_courses"
        case .categories_tapped_anxiety: return "categories_tapped_anxiety"
        case .categories_tapped_focus: return "categories_tapped_focus"
        case .categories_tapped_growth: return "categories_tapped_growth"
        case .categories_tapped_meditation: return "categories_tapped_meditation"
        case .categories_tapped_sleep: return "categories_tapped_sleep"
        case .categories_tapped_confidence: return "categories_tapped_confidence"
        case .categories_tapped_locked_meditation: return "categories_tapped_locked_meditation"
        case .tabs_tapped_meditate: return "tabs_tapped_meditate"
        case .tabs_tapped_garden: return "tabs_tapped_garden"
        case .tabs_tapped_store: return "tabs_tapped_store"
        case .tabs_tapped_profile: return "tabs_tapped_profile"
        case .tabs_tapped_plus: return "tabs_tapped_plus"
        case .plus_tapped_mood: return "plus_tapped_mood"
        case .mood_tapped_angry: return "mood_tapped_angry"
        case .mood_tapped_sad: return "mood_tapped_sad"
        case .mood_tapped_okay: return "mood_tapped_okay"
        case .mood_tapped_happy: return "mood_tapped_happy"
        case .mood_tapped_done: return "mood_tapped_done"
        case .mood_tapped_cancel: return "mood_tapped_cancel"
        case .plus_tapped_gratitude: return "plus_tapped_gratitude"
        case .plus_tapped_mood_to_pricing: return "plus_tapped_mood_to_pricing"
        case .plus_tapped_gratitude_to_pricing: return "plus_tapped_gratitude_to_pricing"
        case .plus_tapped_meditate_to_pricing: return "plus_tapped_meditate_to_pricing"
        case .gratitude_tapped_done: return "gratitude_tapped_done"
        case .gratitude_tapped_cancel: return "gratitude_tapped_cancel"
        case .gratitude_tapped_prompts: return "gratitude_tapped_prompts"
        case .plus_tapped_meditate: return "plus_tapped_meditate"
        case .play_tapped_sound_beach: return "play_tapped_sound_beach"
        case .seventh_time_coming_back: return "seventh_time_coming_back"
        case .screen_load_pricing: return "screen_load_pricing"
        case .screen_load_review: return "screen_load_review"
        case .review_tapped_tutorial: return "review_tapped_tutorial"
        case .review_tapped_explore: return "review_tapped_explore"
        }
    }
}
