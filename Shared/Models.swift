//
//  Models.swift
//  InsertionSortGifs
//
//  Created by Borna Libertines on 16/02/22.
//

import Foundation

struct APIListResponse: Codable {
   let data: [GifObject]
}

struct GifObject: Codable {
   
   let id: String?
   let title: String?
   let source_tld: String?
   let rating: String?
   let url: URL?
   let images: Images?
   struct Images: Codable {
      let fixed_height: Image?
      struct Image: Codable {
         let url: URL?
         let width: String?
         let height: String?
         let mp4: URL?
      }
   }
}

// MARK: GifCollectionViewCellViewModel Model
struct GifCollectionViewCellViewModel: Comparable {
   
   let id: String
   let title: String
   let rating: String?
   let Image: URL?
   let url: URL?
   
   static func < (lhs: GifCollectionViewCellViewModel, rhs: GifCollectionViewCellViewModel) -> Bool {
      return lhs.title < rhs.title
   }
   
   static func == (lhs: GifCollectionViewCellViewModel, rhs: GifCollectionViewCellViewModel) -> Bool {
      return lhs.title == rhs.title
   }
}
