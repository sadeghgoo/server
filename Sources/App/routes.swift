import Vapor
import SwiftSoup

func routes(_ app: Application) throws {
    let apiGroup = app.grouped("api")
    apiGroup.on(.GET, "radioJavan") { request async throws in
        let link = try request.query.decode(RadioJavanURLQuery.self)
        guard let lastPartOfURL = link.link.split(separator: "/").last else {
            throw Abort(.notAcceptable, reason: "Link is not valid.")
        }
        let response = try await request.client.get("https://rj-deskcloud.com/api2/mp3?id=\(lastPartOfURL)")
        let musicModel = try response.content.decode(MusicModel.self)
        
        return RadioJavanMusicDownloadResponse(artistName: musicModel.artist, songName: musicModel.song, songURL: musicModel.link)
    }
}

struct RadioJavanURLQuery: Content {
    let link: String
}

struct RadioJavanMusicDownloadResponse: Content {
    let artistName: String?
    let songName: String?
    let songURL: String?
}

// MARK: - MusicModel
struct MusicModel: Content {
    let id: Int?
    let title: String?
    let explicit: Bool?
    let link: String?
    let photo, thumbnail: String?
    let plays, artist, song: String?
    let photo240: String?
    let likes, dislikes, downloads: String?
    let photoPlayer: String?
    let permlink: String?
    let shareLink: String?
    let createdAt: Date?
    let type: MusicModelType?
    let duration: Double?
    let sampleStart: Int?
    let hlsLink: String?
    let lqLink, hqLink: String?
    let lqHLS, hqHLS: String?
    let lufs: Double?
    let credits: String?
    let creditTags, artistTags, bgColors: [String]?
    let artistFarsi, songFarsi, date: String?
    let related: [MusicModel]?
    let lyric: String?
    let lyricSynced: [LyricSynced]?
    let allowSelfie: Bool?
    let selfies: [Selfy]?
}

// MARK: - LyricSynced
struct LyricSynced: Content {
    let time: Double?
    let text: String?
}

// MARK: - Selfy
struct Selfy: Content {
    let id: Int?
    let hashID: String?
    let title: String?
    let mp3: Int?
    let artist: String?
    let song: String?
    let hqLink, link: String?
    let filename: String?
    let shareLink: String?
    let photo, thumbnail: String?
    let verified: Bool?
    let type: String?
    let likes, likesPretty: String?
    let hls, hdvc: String?
    let user: User?
    let location: String?
}


// MARK: - User
struct User: Content {
    let thumbnail: String?
    let displayName, username: String?
}

enum MusicModelType: String, Content {
    case mp3 = "mp3"
}
