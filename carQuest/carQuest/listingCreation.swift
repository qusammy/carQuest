//
//  listingCreation.swift
//  carQuest
//
//  Created by Maddy Quinn on 8/29/24.
//

import SwiftUI

struct listingCreation: View {
    @State var typeOfCar: String
    @State var location: String
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
            }).frame(maxWidth: 375, alignment: .leading)


            Text("Create listing")
                .font(Font.custom("Jost-Regular", size:40))
                .frame(maxWidth: 375, alignment: .leading)
            Text("Type of car")
                .font(Font.custom("ZingRustDemo-Base", size:30))
                .frame(maxWidth: 375, alignment: .leading)
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
            }.frame(maxWidth: 375, alignment: .leading)
        Text("Brand of car")
            .font(Font.custom("ZingRustDemo-Base", size:30))
            .frame(maxWidth: 375, alignment: .leading)
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
            }.frame(maxWidth: 375, alignment: .leading)
            Text("Location")
                .font(Font.custom("ZingRustDemo-Base", size:30))
                .frame(maxWidth: 375, alignment: .leading)
            TextField("City, zip, address", text: $location)
                .foregroundColor(.black)
                .frame(width:375, height:50)
                .font(.custom("Jost-Regular", size: 20))
                .background(Color(hue: 1.0, saturation: 0.005, brightness: 0.927))
                .cornerRadius(10)
                .multilineTextAlignment(.leading)
                .disableAutocorrection(true)
        }
    }
}

#Preview {
    listingCreation(typeOfCar: "", location: "")
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
