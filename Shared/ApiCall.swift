//
//  ApiCall.swift
//  InsertionSortGifs
//
//  Created by Borna Libertines on 16/02/22.
//

import Foundation
import Combine

public enum APIError: Error {
   case internalError
   case serverError
   case parsingError
}
enum Constants {}
extension Constants {
   // MARK: Constants
   // Get an API key from https://developers.giphy.com/dashboard/
   static let giphyApiKey = "XbMKr0q0vnZMyi1ljDgUZML8U6oCbO1N"
   //static let screenSize = UIScreen.main.bounds.size
   
   static let https = "https://api.giphy.com/v1/gifs/"
   static let trending = "trending"
   static let searchGif = "q"
   static let search = "search"
   static let limitNum = "15"
   static let limit = "limit"
   static let rating = "g"
   static let lang = "en"
}

private struct Domain {
   static let scheme = "https"
   static let host = "api.giphy.com"
   static let path = "/v1/gifs/"
}
class ApiLoader {
   
   public init() {}
   
   private func createUrl(urlParams: [String:String], gifacces: String?) -> URLRequest {
      var queryItems = [URLQueryItem]()
      queryItems.append(URLQueryItem(name: "api_key", value: Constants.giphyApiKey))
      for (key,value) in urlParams {
         queryItems.append(URLQueryItem(name: key, value: value))
      }
      
      var components = URLComponents()
      components.scheme = Domain.scheme
      components.host = Domain.host
      components.path = Domain.path+gifacces!
      components.queryItems = queryItems.isEmpty ? nil : queryItems
      guard let url = components.url else { preconditionFailure("Bad URL") }
      debugPrint(url.absoluteString)
      
      let request = URLRequest(url: url)
      return request
   }
   
   public func fetchAPI<T: Codable>(urlParams: [String:String], gifacces: String?) -> AnyPublisher<T, APIError> {
     return fetchAndDecode(url: createUrl(urlParams: urlParams, gifacces: gifacces).url!)
   }
   
   private func fetchAndDecode<T: Codable>(url: URL) -> AnyPublisher<T, APIError> {
           return URLSession.shared.dataTaskPublisher(for: url)
               .subscribe(on: DispatchQueue.global(qos: .background))
               .receive(on: DispatchQueue.main)
               .mapError{ _ in APIError.serverError }
               .tryMap { $0.data }
               .decode(type: T.self, decoder: JSONDecoder())
               .mapError { _ in APIError.parsingError }
               //.replaceError(with: )
               .eraseToAnyPublisher()
      
   }
   
   deinit{
      debugPrint("ApiLoader deinit")
   }
}
