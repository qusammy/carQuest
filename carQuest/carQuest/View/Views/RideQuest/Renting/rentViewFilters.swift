//
//  rentViewFilters.swift
//  carQuest
//
//  Created by Maddy Quinn on 2/10/25.
//

import SwiftUI

//struct rentViewFilters: View {
//    @Environment(\.dismiss) var dismiss
//    @State var selectedYear = "2025"
//    let years = ["1960", "1961", "1962", "1963", "1964", "1965", "1966", "1967", "1968", "1969", "1970", "1971", "1972", "1973", "1974", "1975", "1976", "1977", "1978", "1979", "1980", "1981", "1982", "1983", "1984", "1985", "1986", "1987", "1988", "1989", "1990", "1991", "1992", "1993", "1994", "1995", "1996", "1997", "1998", "1999", "2000", "2001", "2002", "2003", "2004", "2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018", "2019", "2020", "2021", "2022", "2023", "2024", "2025"]
//    @State var selectedMake = ""
//        let makes = ["Acura", "Alfa Romeo", "Aston Martin", "Audi", "Bentley", "BMW", "Bugatti", "Buick", "Cadillac", "Chevrolet", "Chrysler", "Citroën", "Dodge", "Ferrari", "Fiat", "Ford", "Genesis", "GMC", "Honda", "Hyundai", "Infiniti", "Jaguar", "Jeep", "Kia", "Koenigsegg", "Lamborghini", "Lancia", "Land Rover","Lexus", "Lincoln", "Lotus", "Maserati", "Mazda", "McLaren", "Mercedes-Benz", "Mini", "Mitsubishi", "Nissan", "Pagani", "Peugeot", "Porsche", "Ram", "Renault", "Rolls-Royce", "Saab", "Subaru", "Suzuki", "Tesla", "Toyota", "Volkswagen", "Volvo"]
//    @State var selectedModel = "Model"
//    @State var modelSearch = ""
//    @State var selectedType = ""
//    let types = ["Sedan", "Coupe", "Hatchback", "Convertible", "Sport", "Wagon", "Crossover", "SUV", "Pickup", "Minivan", "Van", "Luxury", "EV", "Hybrid", "Off-Road", "Hypercar", "Roadster", "Microcar", "Kei", "Grand Tourer", "Limousine"
//    ]
//
//    var body: some View {
//        VStack{
//            HStack{
//                Button(action: {
//                    dismiss()
//                }, label: {
//                    Text("Reset")
//                        .foregroundColor(Color.accentColor)
//                        .font(Font.custom("Jost-Regular", size:18))
//                        .underline()
//                })
//                Spacer()
//                Text("Filters")
//                    .font(.custom("ZingRustDemo-Base", size: 30))
//                    .foregroundStyle(Color.foreground)
//                Spacer()
//                Button(action: {
//                    dismiss()
//                }, label: {
//                    Image(systemName:"checkmark")
//                        .resizable()
//                        .foregroundStyle(Color.accentColor)
//                        .frame(width:25, height:25)
//                })
//            }
//            List{
//                Section {
//                    Picker("Year", selection: $selectedYear) {
//                        ForEach(years, id: \.self) {
//                            Text($0)
//                        }
//                    }.font(.custom("Jost", size: 18))
//                }
//                Section {
//                    Picker("Make", selection: $selectedMake) {
//                        ForEach(makes, id: \.self) {
//                            Text($0)
//                                
//                        }
//                    }.font(.custom("Jost", size: 18))
//                }
//                Section {
//                    HStack{
//                        Text("Model")
//                            .font(.custom("Jost", size: 18))
//                            .foregroundStyle(Color.foreground)
//                        Spacer()
//                        TextField("Model", text: $modelSearch)
//                            .font(.custom("Jost", size: 18))
//                            .foregroundColor(Color(red: 0.541, green: 0.541, blue: 0.554))
//                            .multilineTextAlignment(.trailing)
//                    }
//                }
//                Section {
//                    Picker("Type", selection: $selectedType) {
//                        ForEach(types, id: \.self) {
//                            Text($0)
//                        }
//                    }.font(.custom("Jost", size: 18))
//                }
//            }.listStyle(.plain)
//        }.padding()
//    }
//}
//
//#Preview {
//    rentViewFilters()
//}
