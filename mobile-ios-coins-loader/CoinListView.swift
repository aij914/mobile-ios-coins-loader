//
//  ContentView.swift
//  mobile-ios-coins-loader
//
//  Created by Kiu Ai on 1/18/21.
//

import SwiftUI
import Combine

struct CoinListView: View {
    
    private let viewModel = CoinListViewModel()
    
    var body: some View {
        Text("Hello, world!").onAppear(perform: {
            self.viewModel.fetchCoins()
        })
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
}

struct CoinViewModel: Hashable {
    private let coin: Coin
    
    var name: String {
        return coin.name
    }
    
    var formattedPrice: String {
        return coin.price
    }
    
    init(_ coin: Coin) {
        self.coin = coin
    }
}
