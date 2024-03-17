//
//  ContentView.swift
//  RandomCat
//
//  Created by apprenant68 on 14/03/2024.
//

import SwiftUI

struct Cat : Decodable, Identifiable{
    let id : String
    let url : String
//    let width : Int
//    let heigth : Int
    
}

class CatViewModel: ObservableObject {
    @Published var cat :[Cat] = []
    func fetchCat() {
        guard let url = URL(string: "https://api.thecatapi.com/v1/images/search") else {
            print("URL invalide")
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode([Cat].self, from: data)
                    DispatchQueue.main.async {
                        self.cat = decodedData
                    }
                } catch {
                    print("Erreur de décodage: \(error)")
                }
            }
        }.resume()
    }
}
struct ContentView: View {
    @StateObject var viewmodel = CatViewModel()
    var body: some View {
        ZStack{
            Color.yellow.ignoresSafeArea()
            VStack{
                Spacer()
                if viewmodel.cat.isEmpty {
                                    ProgressView()
                } else {
                    AsyncImage(url: URL(string: viewmodel.cat[0].url))
                    { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                    } placeholder: {
                        ProgressView()
                    }
                }
                Button {
                    viewmodel.fetchCat()
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 40)
                            .frame(width: 125,height: 60)
                            .foregroundStyle(.black)
                        Image(systemName: "cat")
                            .foregroundStyle(.white)
                            .font(.title)
                    }
                }
                .padding(.top,50)
                Spacer()
            }
            .onAppear {
                viewmodel.fetchCat()
            }
        }
    }
}

#Preview {
    ContentView()
}
