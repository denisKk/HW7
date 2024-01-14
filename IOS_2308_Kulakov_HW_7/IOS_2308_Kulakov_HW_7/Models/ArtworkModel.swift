//
//  ArtworkModel.swift
//  IOS_2308_Kulakov_HW_2
//
//  Created by Dev on 13.10.23.
//

import Foundation

struct ArtworkModel: Identifiable {
    let id: Int
    let title: String
    let descrittion: String
    let imageURL: URL
    let imageFullScreenURL: URL
    let materials: String
    let author: String
    let date: String
}


extension ArtworkModel {
    
    static var testData: [ArtworkModel] {
        [
            ArtworkModel(id: 1,
                             title: "Test data for TITLE",
                             descrittion: """
                            My worry here is that AcountBackEnd is the file created by coredata. So now I'd need to initilalize that in my refaftoring file, which to be honest is a question mark for me.
                            
                            I still don't know how to properly initialize that, and it's embarassing to write.

                            After this, my views should be using @ObservedObject when referencing to the refactor file. Is this right?

                            I've been looking for days now to find a solution to this, but I keep coming up flat, and with more errors.
""",
                             imageURL: URL(string: "https://www.artic.edu/iiif/2/2a6e9dc3-2ef0-9d65-49f1-a7f0f851902d/full/,300/0/default.jpg")!,
                             imageFullScreenURL: URL(string: "https://www.artic.edu/iiif/2/2a6e9dc3-2ef0-9d65-49f1-a7f0f851902d/full/full/0/default.jpg")!,
                             materials: "Wood, Gold",
                             author: "Picasso",
                         date: "1284"
                            ),
            
            ArtworkModel(id: 2,
                             title: "Test data for TITLE@ long long long",
                             descrittion: "Test description for moc model",
                             imageURL: URL(string: "https://www.artic.edu/iiif/2/aa4b8ab9-7187-b9cb-37fd-2c52ac3cad71/full/,300/0/default.jpg")!,
                             imageFullScreenURL: URL(string: "https://www.artic.edu/iiif/2/aa4b8ab9-7187-b9cb-37fd-2c52ac3cad71/full/full/0/default.jpg")!,
                             materials: "Steel, Gold",
                             author: "Rembrant",
                             date: "1573"
                            )
        ]
    }
}
