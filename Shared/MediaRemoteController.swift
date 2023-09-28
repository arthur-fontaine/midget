//
//  MediaRemoteController.swift
//  midget-widgetExtension
//
//  Created by Arthur Fontaine on 27/09/2023.
//

import Foundation
import AppIntents

class MediaRemoteController {
    
    static let shared = MediaRemoteController()
    
    private init() {
        // Private constructor to enforce singleton pattern
    }
    
    enum MRCommand: String, AppEnum {
        static var typeDisplayRepresentation: TypeDisplayRepresentation = TypeDisplayRepresentation(name: "Media command")
        
        static var caseDisplayRepresentations: [MRCommand: DisplayRepresentation] = [
                .play: "Play",
                .pause: "Pause",
                .togglePlayPause: "Toggle Play/Pause",
                .stop: "Stop",
                .nextTrack: "Next Track",
                .previousTrack: "Previous Track",
                .toggleShuffle: "Toggle Shuffle",
                .toggleRepeat: "Toggle Repeat",
                .startForwardSeek: "Start Forward Seek",
                .endForwardSeek: "End Forward Seek",
                .startBackwardSeek: "Start Backward Seek",
                .endBackwardSeek: "End Backward Seek",
                .goBackFifteenSeconds: "Go Back Fifteen Seconds",
                .skipFifteenSeconds: "Skip Fifteen Seconds",
                .likeTrack: "Like Track",
                .banTrack: "Ban Track",
                .addTrackToWishList: "Add Track to Wish List",
                .removeTrackFromWishList: "Remove Track from Wish List"
            ]
        
        case play = "0"
        case pause = "1"
        case togglePlayPause = "2"
        case stop = "3"
        case nextTrack = "4"
        case previousTrack = "5"
        case toggleShuffle = "6"
        case toggleRepeat = "7"
        case startForwardSeek = "8"
        case endForwardSeek = "9"
        case startBackwardSeek = "10"
        case endBackwardSeek = "11"
        case goBackFifteenSeconds = "12"
        case skipFifteenSeconds = "13"
        case likeTrack = "0x6A"
        case banTrack = "0x6B"
        case addTrackToWishList = "0x6C"
        case removeTrackFromWishList = "0x6D"
    }
    
    struct MediaInfo {
        let totalDiscCount: Int?
        let shuffleMode: Int?
        let trackNumber: Int?
        let duration: TimeInterval?
        let repeatMode: Int?
        let title: String?
        let playbackRate: Double?
        let artworkData: Data?
        let album: String?
        let totalQueueCount: Int?
        let artworkMIMEType: String?
        let mediaType: Int?
        let discNumber: Int?
        let timestamp: Double?
        let genre: String?
        let queueIndex: Int?
        let artist: String?
        let defaultPlaybackRate: Float?
        let elapsedTime: TimeInterval?
        let totalTrackCount: Int?
        let isMusicApp: Bool?
        let uniqueIdentifier: String?
        let chapterNumber: Int?
        let composer: String?
        let isAdvertisement: Bool?
        let isBanned: Bool?
        let isInWishList: Bool?
        let isLiked: Bool?
        let prohibitsSkip: Bool?
        let radioStationIdentifier: String?
        let supportsFastForward15Seconds: Bool?
        let supportsRewind15Seconds: Bool?
        let startTime: TimeInterval?
        let totalChapterCount: Int?
        let radioStationHash: Int?
        
        init(_ info: [String: Any]) {
            totalDiscCount = info["kMRMediaRemoteNowPlayingInfoTotalDiscCount"] as? Int
            shuffleMode = info["kMRMediaRemoteNowPlayingInfoShuffleMode"] as? Int
            trackNumber = info["kMRMediaRemoteNowPlayingInfoTrackNumber"] as? Int
            duration = info["kMRMediaRemoteNowPlayingInfoDuration"] as? TimeInterval
            repeatMode = info["kMRMediaRemoteNowPlayingInfoRepeatMode"] as? Int
            title = info["kMRMediaRemoteNowPlayingInfoTitle"] as? String
            playbackRate = info["kMRMediaRemoteNowPlayingInfoPlaybackRate"] as? Double
            artworkData = info["kMRMediaRemoteNowPlayingInfoArtworkData"] as? Data
            album = info["kMRMediaRemoteNowPlayingInfoAlbum"] as? String
            totalQueueCount = info["kMRMediaRemoteNowPlayingInfoTotalQueueCount"] as? Int
            artworkMIMEType = info["kMRMediaRemoteNowPlayingInfoArtworkMIMEType"] as? String
            mediaType = info["kMRMediaRemoteNowPlayingInfoMediaType"] as? Int
            discNumber = info["kMRMediaRemoteNowPlayingInfoDiscNumber"] as? Int
            timestamp = info["kMRMediaRemoteNowPlayingInfoTimestamp"] as? Double
            genre = info["kMRMediaRemoteNowPlayingInfoGenre"] as? String
            queueIndex = info["kMRMediaRemoteNowPlayingInfoQueueIndex"] as? Int
            artist = info["kMRMediaRemoteNowPlayingInfoArtist"] as? String
            defaultPlaybackRate = info["kMRMediaRemoteNowPlayingInfoDefaultPlaybackRate"] as? Float
            elapsedTime = info["kMRMediaRemoteNowPlayingInfoElapsedTime"] as? TimeInterval
            totalTrackCount = info["kMRMediaRemoteNowPlayingInfoTotalTrackCount"] as? Int
            isMusicApp = info["kMRMediaRemoteNowPlayingInfoIsMusicApp"] as? Bool
            uniqueIdentifier = info["kMRMediaRemoteNowPlayingInfoUniqueIdentifier"] as? String
            chapterNumber = info["kMRMediaRemoteNowPlayingInfoChapterNumber"] as? Int
            composer = info["kMRMediaRemoteNowPlayingInfoComposer"] as? String
            isAdvertisement = info["kMRMediaRemoteNowPlayingInfoIsAdvertisement"] as? Bool
            isBanned = info["kMRMediaRemoteNowPlayingInfoIsBanned"] as? Bool
            isInWishList = info["kMRMediaRemoteNowPlayingInfoIsInWishList"] as? Bool
            isLiked = info["kMRMediaRemoteNowPlayingInfoIsLiked"] as? Bool
            prohibitsSkip = info["kMRMediaRemoteNowPlayingInfoProhibitsSkip"] as? Bool
            radioStationIdentifier = info["kMRMediaRemoteNowPlayingInfoRadioStationIdentifier"] as? String
            supportsFastForward15Seconds = info["kMRMediaRemoteNowPlayingInfoSupportsFastForward15Seconds"] as? Bool
            supportsRewind15Seconds = info["kMRMediaRemoteNowPlayingInfoSupportsRewind15Seconds"] as? Bool
            startTime = info["kMRMediaRemoteNowPlayingInfoStartTime"] as? TimeInterval
            totalChapterCount = info["kMRMediaRemoteNowPlayingInfoTotalChapterCount"] as? Int
            radioStationHash = info["kMRMediaRemoteNowPlayingInfoRadioStationHash"] as? Int
        }
    }

    
    // MARK: - Public Methods
    
    func getCurrentMediaInfo(completion: @escaping (MediaInfo?) -> Void) {
        MRMediaRemoteGetNowPlayingInfo { information in
            let mediaInfo = MediaInfo(information)
            completion(mediaInfo)
        }
    }
    
    func controlMedia(command: MRCommand) {
        if let value = Int(command.rawValue) {
            MRMediaRemoteSendCommand(value, 0)
        }
    }
    
    // MARK: - Private Methods
    
    private func MRMediaRemoteGetNowPlayingInfo(_ completion: @escaping ([String: Any]) -> Void) {
        guard let bundle = CFBundleCreate(kCFAllocatorDefault, NSURL(fileURLWithPath: "/System/Library/PrivateFrameworks/MediaRemote.framework")) else {
            completion([:])
            return
        }
        
        guard let MRMediaRemoteGetNowPlayingInfoPointer = CFBundleGetFunctionPointerForName(bundle, "MRMediaRemoteGetNowPlayingInfo" as CFString) else {
            completion([:])
            return
        }
        
        typealias MRMediaRemoteGetNowPlayingInfoFunction = @convention(c) (DispatchQueue, @escaping ([String: Any]) -> Void) -> Void
        let MRMediaRemoteGetNowPlayingInfo = unsafeBitCast(MRMediaRemoteGetNowPlayingInfoPointer, to: MRMediaRemoteGetNowPlayingInfoFunction.self)
        
        MRMediaRemoteGetNowPlayingInfo(DispatchQueue.main) { information in
            completion(information)
        }
    }
    
    private func MRMediaRemoteSendCommand(_ command: Int, _ param: Int) {
        guard let bundle = CFBundleCreate(kCFAllocatorDefault, NSURL(fileURLWithPath: "/System/Library/PrivateFrameworks/MediaRemote.framework")) else {
            return
        }
        
        guard let MRMediaRemoteSendCommandPointer = CFBundleGetFunctionPointerForName(bundle, "MRMediaRemoteSendCommand" as CFString) else {
            return
        }
        
        typealias MRMediaRemoteSendCommandFunction = @convention(c) (Int, Int) -> Void
        let MRMediaRemoteSendCommand = unsafeBitCast(MRMediaRemoteSendCommandPointer, to: MRMediaRemoteSendCommandFunction.self)
        
        MRMediaRemoteSendCommand(command, param)
    }
}
