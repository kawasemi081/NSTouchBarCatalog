/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Custom NSCustomTouchBarItem class for text content.
 */

import Cocoa

@available(OSX 10.12.2, *)
class TextScrubberBarItemSample: NSCustomTouchBarItem, NSScrubberDelegate, NSScrubberDataSource, NSScrubberFlowLayoutDelegate {
    
    private static let itemViewIdentifier = "TextItemViewIdentifier"
    
    var scrubberItemWidth: Int = 100
    let testStrings = ["Alaska", "California", "New York", "Texas", "Washington", "Shows how to create bars and items for use in the Touch Bar."]
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(identifier: NSTouchBarItem.Identifier) {
        super.init(identifier: identifier)
        
        let scrubber = NSScrubber()
        scrubber.scrubberLayout = NSScrubberFlowLayout()
        scrubber.register(NSScrubberTextItemView.self, forItemIdentifier: NSUserInterfaceItemIdentifier(TextScrubberBarItemSample.itemViewIdentifier))
        
        scrubber.mode = .free
        scrubber.selectionBackgroundStyle = .outlineOverlay
        scrubber.delegate = self
        scrubber.dataSource = self
        
        view = scrubber
    }
    
    func numberOfItems(for scrubber: NSScrubber) -> Int {
        return testStrings.count
    }
    
    // Scrubber is asking for a custom view represention for a particuler item index.
    func scrubber(_ scrubber: NSScrubber, viewForItemAt index: Int) -> NSScrubberItemView {
        var returnItemView = NSScrubberItemView()
        if let itemView =
            scrubber.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: type(of: self).itemViewIdentifier),
                              owner: nil) as? NSScrubberTextItemView {
            itemView.textField.stringValue = testStrings[index]
            itemView.textField.backgroundColor = NSColor.systemBlue
            itemView.textField.sizeToFit()
            returnItemView = itemView
        }
        return returnItemView
    }
    
    // Scrubber is asking for the size for a particular item.
    func scrubber(_ scrubber: NSScrubber, layout: NSScrubberFlowLayout, sizeForItemAt itemIndex: Int) -> NSSize {
        let size = NSSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)

        // Specify a system font size of 0 to automatically use the appropriate size.
        let title = testStrings[itemIndex]
        let textRect = title.boundingRect(with: size, options: [.usesFontLeading, .usesLineFragmentOrigin],
                                          attributes: [NSAttributedStringKey.font: NSFont.systemFont(ofSize: 0)])
        //+6:  spacing.
        //+10: NSTextField horizontal padding, no good way to retrieve this though.
        let width: CGFloat = textRect.size.width + 6 + 10

        return NSSize(width: width, height: 30)
//        return NSSize(width: scrubberItemWidth, height: 30)
    }
    
    // User chose a particular image inside the scrubber.
    func scrubber(_ scrubber: NSScrubber, didSelectItemAt index: Int) {
        print("\(#function) at index \(index)")
    }
}

