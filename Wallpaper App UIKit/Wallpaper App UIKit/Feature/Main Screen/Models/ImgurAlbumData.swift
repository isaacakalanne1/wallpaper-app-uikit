//
//  ImgurAlbumData.swift
//  Wallpaper App UIKit
//
//  Created by iakalann on 06/12/2021.
//

import Foundation

struct ImgurAlbumData: Codable {
    let data: [ImgurImageData]
}

struct ImgurImageData: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id, title, description, dateTime, type, animated, width, height, size, views, bandwidth, vote, nsfw, section, edited, link
        case favourite = "favorite"
        case accountUrl = "account_url"
        case accountId = "account_id"
        case isAd = "is_ad"
        case inMostViral = "in_most_viral"
        case hasSound = "has_sound"
        case adType = "ad_type"
        case adUrl = "ad_url"
        case inGallery = "in_gallery"
    }
    
    let id: String?
    let title: String?
    let description: String?
    let dateTime: Int?
    let type: String?
    let animated: Bool?
    let width: Int?
    let height: Int?
    let size: Int?
    let views: Int?
    let bandwidth: Int?
    let vote: String?
    let favourite: String?
    let nsfw: String?
    let section: String?
    let accountUrl: String?
    let accountId: String?
    let isAd: String?
    let inMostViral: String?
    let hasSound: String?
    let adType: String?
    let adUrl: String?
    let edited: String?
    let inGallery: Bool?
    let link: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try? container.decode(String.self, forKey: .id)
        self.title = try? container.decode(String.self, forKey: .title)
        self.description = try? container.decode(String.self, forKey: .description)
        self.dateTime = try? container.decode(Int.self, forKey: .dateTime)
        self.type = try? container.decode(String.self, forKey: .type)
        self.animated = try? container.decode(Bool.self, forKey: .animated)
        self.width = try? container.decode(Int.self, forKey: .width)
        self.height = try? container.decode(Int.self, forKey: .height)
        self.size = try? container.decode(Int.self, forKey: .size)
        self.views = try? container.decode(Int.self, forKey: .views)
        self.bandwidth = try? container.decode(Int.self, forKey: .bandwidth)
        self.vote = try? container.decode(String.self, forKey: .vote)
        self.favourite = try? container.decode(String.self, forKey: .favourite)
        self.nsfw = try? container.decode(String.self, forKey: .nsfw)
        self.section = try? container.decode(String.self, forKey: .section)
        self.accountUrl = try? container.decode(String.self, forKey: .accountUrl)
        self.accountId = try? container.decode(String.self, forKey: .accountId)
        self.isAd = try? container.decode(String.self, forKey: .isAd)
        self.inMostViral = try? container.decode(String.self, forKey: .inMostViral)
        self.hasSound = try? container.decode(String.self, forKey: .hasSound)
        self.adType = try? container.decode(String.self, forKey: .adType)
        self.adUrl = try? container.decode(String.self, forKey: .adUrl)
        self.edited = try? container.decode(String.self, forKey: .edited)
        self.inGallery = try? container.decode(Bool.self, forKey: .inGallery)
        
        self.link = try container.decode(String.self, forKey: .link)
    }
}

extension ImgurAlbumData {
    
    var links: [String] {
        return data.map { $0.link }
    }
    
}
