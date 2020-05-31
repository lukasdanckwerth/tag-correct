//
//  ID3CorrectorTests.swift
//  ID3CorrectorTests
//
//  Created by Lukas Danckwerth on 08.08.19.
//  Copyright © 2019 Lukas Danckwerth. All rights reserved.
//

import XCTest

class ID3CorrectorTests: XCTestCase {
    
    let removementsFileURL = Bundle(for: ID3CorrectorTests.self).url(forResource: "removements", withExtension: "txt")!
    
    let replacementsFileURL = Bundle(for: ID3CorrectorTests.self).url(forResource: "replacements", withExtension: "txt")!
    
    let incorrectGenresFileURL = Bundle(for: ID3CorrectorTests.self).url(forResource: "incorrect-genres", withExtension: "txt")!
    
    let incorrectFeaturesFileURL = Bundle(for: ID3CorrectorTests.self).url(forResource: "incorrect-features", withExtension: "txt")!
    
    let incorrectProducedByFileURL = Bundle(for: ID3CorrectorTests.self).url(forResource: "incorrect-produced-by", withExtension: "txt")!
    
    override func setUp() {
        ID3Corrector.replacements = ID3Corrector.dictionary(at: replacementsFileURL)
        ID3Corrector.genres = ID3Corrector.dictionary(at: incorrectGenresFileURL)
        ID3Corrector.feats = ID3Corrector.lines(at: incorrectFeaturesFileURL)
        ID3Corrector.producedBy = ID3Corrector.lines(at: incorrectProducedByFileURL)
    }
    
    func testGenreCorrection() {
        
        let wrongHipHopList = [ "hip hop", "hip-hop", "Hip-Hop", "Rap", "Rap / Hip Hop" ]
        
        for wrongHipHop in wrongHipHopList {
            let corrected = ID3Corrector.correctGenre(wrongHipHop)
            XCTAssert(corrected == "Hip Hop", "Expected '\(wrongHipHop)' to be corrected as 'Hip Hop'.")
        }
    }
    
    func testNameCorrection() {
        
        
        textCorrection("Haiyti - Coco Chanel (prod. by Macloud & MIKSU)",
                       "Haiyti - Coco Chanel (Prod. by Macloud & MIKSU)")
        
        textCorrection("Haiyti - Coco Chanel prod. Macloud & MIKSU",
                       "Haiyti - Coco Chanel (Prod. by Macloud & MIKSU)")
        
        textCorrection("Haiyti - Coco Chanel prod. by Macloud & MIKSU",
                       "Haiyti - Coco Chanel (Prod. by Macloud & MIKSU)")
        
        textCorrection("Haiyti - Coco Chanel (prod. Macloud & MIKSU)",
                       "Haiyti - Coco Chanel (Prod. by Macloud & MIKSU)")
        
        textCorrection("Kodie Shane - Flex On Me ft. TK Kravitz",
                       "Kodie Shane - Flex On Me (feat. TK Kravitz)")
        
        textCorrection("Hanybal - CHECK (prod. von Jimmy Torrio)",
                       "Hanybal - CHECK (Prod. by Jimmy Torrio)")
        
        textCorrection("Club Soda feat. Action Bronson",
                       "Club Soda (feat. Action Bronson)")
        
        textCorrection("Good Grief (Ft. Diamante)",
                       "Good Grief (feat. Diamante)")
        
        textCorrection("Hold the Line (feat. Raquel Rodriguez) (Prod. Vicky Nguyen]",
                       "Hold the Line (feat. Raquel Rodriguez) (Prod. by Vicky Nguyen)")
        
        textCorrection("Lykke Li - deep end (alt version)",
                       "Lykke Li - deep end (Alternative Version)")
        
        textCorrection("KAY AY FT. IZZA - EINE WIE DU (Prod BY ISY BEATZ & C55)",
                       "KAY AY (feat. IZZA) - EINE WIE DU (Prod. by ISY BEATZ & C55)")
        
        textCorrection("Lil Lano - Fische (Prod. By HNDRX)",
                       "Lil Lano - Fische (Prod. by HNDRX)")
        
        textCorrection("Hanybal - CHECK (prod. von Jimmy Torrio)",
                       "Hanybal - CHECK (Prod. by Jimmy Torrio)")
        
        textCorrection("Nekfeu - Ma dope ft. SPri Noir",
                       "Nekfeu - Ma dope (feat. SPri Noir)")
        
        textCorrection("Respiration Ft. Scolla",
                       "Respiration (feat. Scolla)")
        
        textCorrection("Good Grief (Ft. Diamante)",
                       "Good Grief (feat. Diamante)")
        
        textCorrection("EARTHGANG - Trippin ft Kehlani",
                       "EARTHGANG - Trippin (feat. Kehlani)")
        
        //        textCorrection("ZUNA - CAZAL feat. MIAMI YACINE prod. by Lucry",
        //                       "ZUNA - CAZAL (feat. MIAMI YACINE) (Prod. by Lucry)")
        
        
        // should stay the same
        textCorrection("BHZ - SO LEBEN KANN (Prod. by MotB)",
                       "BHZ - SO LEBEN KANN (Prod. by MotB)")
        
        
        // check replacement of 'Prod. by by'
        textCorrection("BHZ - SO LEBEN KANN (Prod. by by MotB)",
                       "BHZ - SO LEBEN KANN (Prod. by MotB)")
        
    }
    
    func textCorrection(_ name: String,_ expectation: String) {
        let corrected = ID3Corrector.correctName(name)
        assert(name, corrected, isEqual: expectation, after: "Correct Name")
    }
    
    // ===-----------------------------------------------------------------------------------------------------------===
    //
    // MARK: - Remove
    // ===-----------------------------------------------------------------------------------------------------------===
    
    func testRemovements() {
        remove("Ferge X Fisherman – Backstage // JUICE PREMIERE",
               "Ferge X Fisherman – Backstage")
        remove("The Buttertones - \"Denial You Win Again\" (Official Video)",
               "The Buttertones - \"Denial You Win Again\"")
        remove("HAFTBEFEHL - 1999 Part.5 (prod. von Bazzazian) [Official Audio]",
               "HAFTBEFEHL - 1999 Part.5 (prod. von Bazzazian)")
        remove("Gabber Eleganza & HDMIRROR – Frozen Dopamina (Official Video) [LFEK008]",
               "Gabber Eleganza & HDMIRROR – Frozen Dopamina [LFEK008]")
        remove("Moses Sumney - Cut Me | A COLORS SHOW",
               "Moses Sumney - Cut Me")
    }
    
    func remove(_ name: String, _ expectation: String) {
        let removed = ID3Corrector.remove(wordsAt: removementsFileURL, in: name)
        assert(name, removed, isEqual: expectation, after: "Remove")
    }
    
    // ===-----------------------------------------------------------------------------------------------------------===
    //
    // MARK: - Auxiliary
    // ===-----------------------------------------------------------------------------------------------------------===
    
    func assert(_ name: String, _ corrected: String, isEqual expectation: String, after operation: String) {
        XCTAssert(corrected == expectation, """
            \n\n
            Error during \(operation)
            
            Source     \(name)
            Removed    \(corrected)
            Expected   \(expectation)
            \n
            """)
    }
}