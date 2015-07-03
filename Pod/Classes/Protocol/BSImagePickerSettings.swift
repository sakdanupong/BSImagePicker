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

import Photos

public protocol BSImagePickerSettings {
    /**
    Closure that gets called on every selection.
    */
    var selectionClosure: ((asset: PHAsset) -> Void)? {get set}
    
    /**
    Closure that gets called on every deselection.
    */
    var deselectionClosure: ((asset: PHAsset) -> Void)? {get set}
    
    /**
    Closure that gets called when user cancels.
    */
    var cancelClosure: ((assets: [PHAsset]) -> Void)? {get set}
    
    /**
    Closure that gets called when user finishes.
    */
    var finishClosure: ((assets: [PHAsset]) -> Void)? {get set}
    
    /**
    Max number of images user can select
    */
    var maxNumberOfSelections: Int {get set}
    
    /**
    Cancel button
    */
    var cancelButton: UIBarButtonItem { get }
    
    /**
    Done button
    */
    var doneButton: UIBarButtonItem { get }
    
    /**
    Album button
    */
    var albumButton: UIButton { get }
    
    /**
    Character to use for selection. If nil, selection number will be used
    */
    var selectionCharacter: Character? { get set }
}