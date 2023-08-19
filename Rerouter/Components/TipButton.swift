//
//  TipButton.swift
//  Rerouter
//
//  Created by Shawn Davis on 5/7/23.
//

import SwiftUI
import OSLog
import StoreKit

struct TipButton: View {
    @State private var tipped: Bool = false
    @State private var isTipping: Bool = false
    
    var body: some View {
        Button(action: {
            Task {
                isTipping = true
                await purchase()
            }
        }, label: {
            if isTipping {
                Label(title: {
                    Text("Leave a Tip")
                        .foregroundColor(.secondary)
                }, icon: {
                    ProgressView()
                        .tint(.white)
                })
                .labelStyle(ColorfulIconLabelStyle(color: .accentColor))
                
            } else {
                Label(title: {
                    Text("Leave a Tip")
                        .foregroundColor(.primary)
                }, icon: {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.white)
                })
                .labelStyle(ColorfulIconLabelStyle(color: .accentColor))
            }
        })
        .animation(.default, value: isTipping)
        .disabled(isTipping)
        .alert("Thank You!", isPresented: $tipped, actions: {
            Button("Dismiss", role: .cancel, action: {
                tipped = false
            })
        }, message: {
            Text("Your support means the world to me!")
        })
    }
    
    @MainActor
    func purchase() async {
        do {
            let products = try await Product.products(for: ["RerouteTip1"])
            guard let product = products.first else {
                throw TipError.noProduct
            }
            let result = try await product.purchase()

            switch result {
            case .success(let verification):
                switch verification {
                case .verified(let transaction):
                    await transaction.finish()
                    tipped = true
                    isTipping = false
                case .unverified(_,_):
                    isTipping = false
                    Logger.tool.notice("TipButton: A purchase returned unverified.")
                }
            case .userCancelled, .pending:
                isTipping = false
                break
            default:
                isTipping = false
                break
            }
        } catch {
            Logger.tool.error("TipButton: An unexpected error occured during purchase().")
        }
    }
}

fileprivate enum TipError: LocalizedError {
    case noProduct
}

struct TipButton_Previews: PreviewProvider {
    static var previews: some View {
        TipButton()
    }
}

