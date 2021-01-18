//
//  CrytoService.swift
//  mobile-ios-coins-loader
//
//  Created by Kiu Ai on 1/18/21.
//

import Foundation
import Combine

final class CrytoService {
    var components: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.coinranking.com"  //https://api.coinranking.com/v2/coins
        components.path = "/v2/coins"
        
        return components
    }
    
    var coinsRequest: URLRequest {
        let url = URL(string: "https://api.coinranking.com/v2/coins")
        var request = URLRequest(url: url!)
        request.setValue("coinrankingfb3942deec26ce768e2e94225daab24c18455f17e8c8c154", forHTTPHeaderField: "x-access-token")
        
        return request
    }
    
    func fetchCoins() -> AnyPublisher<CryptoDataContainer, Error> {
        return URLSession.shared.dataTaskPublisher(for: coinsRequest)
            .map{ $0.data }
            .decode(type: CryptoDataContainer.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    func fetchCoins1()  {
        
        URLSession.shared.dataTask(with: coinsRequest) { (data, response, error) in
            guard let data = data else { return }
            do {
                let rss = try JSONDecoder().decode(CryptoDataContainer.self, from: data)
                    print(rss)
                DispatchQueue.main.async {
//                            self.results = rss.feed.results
                }
            } catch {
                print("Failed to decode: \(error)")
            }
        }.resume()
        
    }
}

struct CryptoDataContainer: Decodable {
    let status: String
    let data: CryptoData
}

struct CryptoData: Decodable {
    let stats: Stats
    let coins: [Coin]
}

struct Stats: Decodable {
    let total: Int
    let totalMarkets: Int
    let totalExchanges: Int
    let totalMarketCap: String
    let total24hVolume: String
    
}

struct Coin: Decodable, Hashable {
    let uuid: String
    let symbol: String
    let name: String
    let iconUrl: String
    let price: String
}




