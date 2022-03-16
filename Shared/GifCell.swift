//
//  GifCell.swift
//  InsertionSortGifs
//
//  Created by Borna Libertines on 16/02/22.
//

import Foundation

import SwiftUI

struct GifCell: View {
   
   @State var gif: GifCollectionViewCellViewModel
   @State var geometry: GeometryProxy
   
   var body: some View {
      
      LazyVStack(alignment: .leading, spacing: 8) {
         if let im = gif.Image{
            HStack(alignment: .center) {
               CacheAsyncImage(url: im, transaction: .init(animation: .spring(response: 1.6))) { phase in
                  switch phase {
                  case .empty:
                     ProgressView()
                        .progressViewStyle(.circular)
                  case .success(let image):
                     image.resizable()
                        .aspectRatio(contentMode: .fill)
                  case .failure:
                     Text("Failed fetching image.")
                        .foregroundColor(.red)
                  @unknown default:
                     Text("Unknown error. Please try again.")
                        .foregroundColor(.red)
                  }
               }
               .frame(width: geometry.size.width/4, height: geometry.size.width/4, alignment: .center)
               .clipShape(RoundedRectangle(cornerRadius: 8))
               
               if let title = gif.title {
                  VStack{
                     HStack(alignment: VerticalAlignment.center, spacing: 8) {
                        Text("\(title)")
                     }
                  }
                  Spacer()
               }
            }
         }
         
      }.frame(maxWidth: .infinity)
      
   }
}

