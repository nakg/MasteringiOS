//
//  Copyright (c) 2018 KxCoding <kky0317@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation

// 이미지링크를 생성하고, 상수로 저장. url형식이지만, url instance 는아니다. 네트워크를 통해 데이터를 요청할 때에는 항상 url instance가 필요하다.
// Please enter the file path uploaded to the dropbox here.
// https://dl.dropboxusercontent.com
let bigFileUrlStr = "https://dl.dropboxusercontent.com/s/xd6mw4mcgx5y474/intro-big.mp4?dl=0"
let smallFileUrlStr = "https://dl.dropboxusercontent.com/s/xgnp7o2xld1u26i/intro-small.mp4?dl=0"
let picUrlStr = "https://dl.dropboxusercontent.com/s/53j13ck1gxylmqt/pic.jpg?dl=0"

// Please enter the dropbox access token here.
let dropBoxAccessToken = "CQJSUOT5S5AAAAAAAAAAFQA3IzXXhBeWOIFcsyYffEMvMc2tJjDoaknRgwmh2Hot"
