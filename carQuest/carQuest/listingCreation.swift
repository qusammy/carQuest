//
//  listingCreation.swift
//  carQuest
//
//  Created by Maddy Quinn on 8/29/24.
//

import SwiftUI

struct listingCreation: View {
    @State var typeOfCar: String
    var body: some View {
        VStack{
            Button(action: {
                //exits out of listing page, back to home page
            }, label: {
                ZStack{
                    Image(systemName: "x.circle.fill")
                        .resizable()
                        .frame(width:40, height:40)
                        .foregroundColor(.black)
                }
            }).offset(x:-165)

            Text("Create listing")
                .font(Font.custom("Jost-Regular", size:40))
                .offset(x:-75)
            Text("Type of car")
                .font(Font.custom("ZingRustDemo-Base", size:30))
                .offset(x:-120)
            ScrollView(.horizontal){
                HStack{
                    carType(type: "SUV")
                    carType(type: "Sedan")
                    carType(type: "Coupe")
                    carType(type: "Sport")
                    carType(type: "Truck")
                    carType(type: "Minivan")
                    carType(type: "Hatchback")
                    carType(type: "Van")
                    carType(type: "Convertible")
                    
                }
            }
        Text("Brand of car")
            .font(Font.custom("ZingRustDemo-Base", size:30))
            .offset(x:-110)
            ScrollView(.horizontal){
                HStack{
                    carBrand(brand: "Audi")
                    carBrand(brand: "BMW")
                    carBrand(brand: "Fiat")
                    carBrand(brand: "Ford")
                    carBrand(brand: "Honda")
                    carBrand(brand: "Hyundai")
                    carBrand(brand: "Infiniti")
                    carBrand(brand: "Jaguar")
                    carBrand(brand: "Jeep")
                    carBrand(brand: "Kia")
                    carBrand(brand: "Land Rover")
                    carBrand(brand: "Lexus")
                    carBrand(brand: "Mazda")
                    carBrand(brand: "Mitsubishi")
                    carBrand(brand: "Nissan")
                    carBrand(brand: "Subaru")
                    carBrand(brand: "Suzuki")
                    carBrand(brand: "Tesla")
                    carBrand(brand: "Toyota")
                    carBrand(brand: "Volkswagon")
                    carBrand(brand: "Other")

                }
            }
        }
    }
}

#Preview {
    listingCreation(typeOfCar: "")
}

struct carType: View {
    var type: String
    @State var isTypeOfCarSelected: Bool = false
    
    var body: some View {
        
            VStack{
                Button(action: { isTypeOfCarSelected.toggle() },
                          label: {
                              switch isTypeOfCarSelected {
                                  case true:
                                  ZStack{
                                      RoundedRectangle(cornerRadius: 10)
                                          .frame(width:100, height:60)
                                          .foregroundColor(Color(red: 1.0, green: 0.11372549019607843, blue: 0.11372549019607843))
                                      Text("\(type)")
                                          .font(.custom("Jost-Regular", size: 17))
                                          .foregroundColor(.white)
                                      
                                  }
                                  default:
                                  ZStack{
                                      RoundedRectangle(cornerRadius: 10)
                                          .frame(width:100, height:60)
                                          .foregroundColor(Color(hue: 1.0, saturation: 0.005, brightness: 0.92))
                                      Text("\(type)")
                                          .font(.custom("Jost-Regular", size: 17))
                                          .foregroundColor(.black)
                                  }
                              }
                   })
        }
    }
}
 
struct carBrand: View {
    var brand: String
    @State var isCarBrandSelected: Bool = false
    var body: some View {
            VStack{
                Button(action: { isCarBrandSelected.toggle() },
                          label: {
                              switch isCarBrandSelected {
                                  case true:
                                  ZStack{
                                      RoundedRectangle(cornerRadius: 10)
                                          .frame(width:100, height:60)
                                          .foregroundColor(Color(red: 1.0, green: 0.11372549019607843, blue: 0.11372549019607843))
                                      Text("\(brand)")
                                          .font(.custom("Jost-Regular", size: 17))
                                          .foregroundColor(.white)
                                  }
                                  default:
                                  ZStack{
                                      RoundedRectangle(cornerRadius: 10)
                                          .frame(width:100, height:60)
                                          .foregroundColor(Color(hue: 1.0, saturation: 0.005, brightness: 0.92))
                                      Text("\(brand)")
                                          .font(.custom("Jost-Regular", size: 17))
                                          .foregroundColor(.black)
                                  }
                              }
                   })
        }
    }
}
