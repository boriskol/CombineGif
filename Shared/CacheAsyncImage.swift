//
//  CacheAsyncImage.swift
//  InsertionSortGifs
//
//  Created by Borna Libertines on 16/02/22.
//

import Foundation
import SwiftUI

struct CacheAsyncImage<Content>: View where Content: View {
   
   private let url: URL
   private let scale: CGFloat
   private let transaction: Transaction
   private let content: (AsyncImagePhase) -> Content
   
   init(
      url: URL,
      scale: CGFloat = 1.0,
      transaction: Transaction = Transaction(),
      @ViewBuilder content: @escaping (AsyncImagePhase) -> Content
   ) {
      self.url = url
      self.scale = scale
      self.transaction = transaction
      self.content = content
   }
   
   var body: some View {
      //if let cached = ItemCache.shared.getItem(for: url){
      if let cached = ImageCache[url] {
         content(.success(cached))
      } else {
         //let _ = print("request \(url.absoluteString)")
         AsyncImage(
            url: url,
            scale: scale,
            transaction: transaction
         ) { phase in
            cacheAndRender(phase: phase)
         }
      }
   }
   
   func cacheAndRender(phase: AsyncImagePhase) -> some View {
      if case .success(let image) = phase {
         ImageCache[url] = image
      }
      
      return content(phase)
   }
}

// TODO:  Fix this withNSCach
fileprivate class ImageCache {
   static private var cache: [URL: Image] = [:]
   //static private var imageCache = NSCache<NSURL, Image>()
   
   static subscript(url: URL) -> Image? {
      get {
         ImageCache.cache[url]
         //ImageCache.imageCache = NSCache<url, Image>
      }
      set {
         ImageCache.cache[url] = newValue
         //ImageCache.imageCache[url as NSURL] = newValue
         
      }
   }
}

class StructWrapper<T>: NSObject {
    let value: T
    init(_ _struct: T) {
        value = _struct
    }
}
class ItemCache: NSCache<NSString, StructWrapper<Image>> {
    static let shared = ItemCache()

    func cache(_ item: Image, for key: URL) {
        let itemWrapper = StructWrapper(item)
       self.setObject(itemWrapper, forKey: key.absoluteString as NSString )
    }
    func getItem(for key: URL) -> Image? {
       let itemWrapper = self.object(forKey: key.absoluteString as NSString)
        return itemWrapper?.value
    }
}
