//
//  ContentView.swift
//  mobile-ios-coins-loader
//
//  Created by Kiu Ai on 1/18/21.
//

import SwiftUI
import Combine

struct CoinListView: View {
    
    @ObservedObject private var viewModel = CoinListViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.coinViewModels, id: \.self) { coinViewModel in
                Text(coinViewModel.displayText)
            }.navigationTitle("Coins")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CoinListView()
    }
}

class CoinListViewModel: ObservableObject {
    @Published var coinViewModels = [CoinViewModel]()
    
    private let crytoService = CrytoService()
    
    var cancellable: AnyCancellable?
    
    func fetchCoins() {
        cancellable = crytoService.fetchCoins().sink(receiveCompletion: { (_) in

        }, receiveValue: { cryptoContainer in
            self.coinViewModels = cryptoContainer.data.coins.map{ CoinViewModel($0) }
            print(self.coinViewModels)
        })
    }
    
    init() {
        self.fetchCoins()
    }
}

struct CoinViewModel: Hashable {
    private let coin: Coin
    
    var name: String {
        return coin.name
    }
    
    var formattedPrice: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        
        guard let price = Double(coin.price), let formattedPrice = numberFormatter.string(from: NSNumber(value: price)) else {
            return ""
        }
        
        return formattedPrice
    }
    
    var displayText: String {
        return name + " - " + formattedPrice
    }
    
    init(_ coin: Coin) {
        self.coin = coin
    }
}
