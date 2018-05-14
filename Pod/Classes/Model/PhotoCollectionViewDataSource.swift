// The MIT License (MIT)
//
// Copyright (c) 2015 Joakim Gyllström
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit
import Photos

/**
Gives UICollectionViewDataSource functionality with a given data source and cell factory
*/
final class PhotoCollectionViewDataSource : NSObject, UICollectionViewDataSource {
    var selections = [PHAsset]()
    var fetchResult: PHFetchResult<PHAsset>
    
    fileprivate let photoCellIdentifier = "photoCellIdentifier"
    fileprivate let photosManager = PHCachingImageManager.default()
    fileprivate let imageContentMode: PHImageContentMode = .aspectFill
    
    let settings: BSImagePickerSettings?
    var imageSize: CGSize = CGSize.zero
    
    init(fetchResult: PHFetchResult<PHAsset>, selections: [PHAsset]? = nil, settings: BSImagePickerSettings?) {
        self.fetchResult = fetchResult
        self.settings = settings
        if let selections = selections {
            self.selections = selections
        }
    
        super.init()
    }
    
    func assetAtIndexPath(_ indexPath: IndexPath) -> PHAsset {
        let reversedIndex = fetchResult.count - indexPath.item - 1
        let asset = fetchResult[reversedIndex]
        
        return asset
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        UIView.setAnimationsEnabled(false)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoCellIdentifier, for: indexPath) as! PhotoCell
        cell.accessibilityIdentifier = "photo_cell_\(indexPath.item)"
        if let settings = settings {
            cell.settings = settings
        }
        
        // Cancel any pending image requests
        if cell.tag != 0 {
            photosManager.cancelImageRequest(PHImageRequestID(cell.tag))
        }
        
        let asset = assetAtIndexPath(indexPath)
        cell.asset = asset
        
        let initialRequestOptions = PHImageRequestOptions()
        initialRequestOptions.isSynchronous = false
        initialRequestOptions.resizeMode = .exact
        initialRequestOptions.deliveryMode = .fastFormat
        
        print("width = \(imageSize.width)")
        print("height = \(imageSize.height)")
        
        // Request image
        cell.tag = Int(photosManager.requestImage(for: asset, targetSize: imageSize, contentMode: imageContentMode, options: initialRequestOptions) { (result, _) in
            cell.imageView.image = result
        })
        
        // Set selection number
        if let index = selections.index(of: asset) {
            if let character = settings?.selectionCharacter {
                cell.selectionString = String(character)
            } else {
                cell.selectionString = String(index+1)
            }
            
            cell.photoSelected = true
        } else {
            cell.photoSelected = false
        }
        
         cell.hiddenGif = true
         if settings?.enableGif ?? false && selections.count == 0 {
            var isGif = false
            DispatchQueue.global().async() {
                let resourceList = PHAssetResource.assetResources(for: asset)
                for (_, resource) in resourceList.enumerated() {
                    if (resource.uniformTypeIdentifier == "com.compuserve.gif") {
                        isGif = true
                        break
                    }
                }
                DispatchQueue.main.async() {
                    cell.hiddenGif = !isGif
                }
            }
         }
        
        UIView.setAnimationsEnabled(true)
        
        return cell
    }
    
    func registerCellIdentifiersForCollectionView(_ collectionView: UICollectionView?) {
        collectionView?.register(UINib(nibName: "PhotoCell", bundle: BSImagePickerViewController.bundle), forCellWithReuseIdentifier: photoCellIdentifier)
    }
}
