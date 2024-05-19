//
//  TutorProperty.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/19/24.
//

import UIKit

enum TutorContentProperty: Int {
    case zero = 0
    case one = 1
    case two = 2
    case three = 3
    case four = 4
    
    func getContent() -> String {
        switch self {
        case .zero:
            """
            每天會依照您所在地的天氣，
            給予您一組相對應的顏色，
            從中選一個你喜歡的顏色吧！
            """
        case .one:
            """
            拿著您手上的顏色，
            去跟周圍的朋友混合顏色，
            究竟能混色什麼的顏色呢？
            真令人期待！
            """
        case .two:
            """
            找尋您周圍含有該顏色的任何東西，
            景色、物品、食物...
            發揮您的觀察力 ！
            然後拍張照片、撰寫貼文，
            分享給大家吧 ！
            """
        case .three:
            """
            顏色相似度愈高，
            能得到愈多獎勵 ！
            並與全世界的觀察家排名，
            快來成為世界第一的顏色大師 ！
            """
        case .four:
            """
            自由瀏覽大家的貼文
            看看其他人怎麼詮釋顏色
            留言、追蹤、聊天
            結交志同道合的顏色大師吧！
            """
        }
    }
}

enum TutorTitleProperty: Int {
    case zero = 0
    case one = 1
    case two = 2
    case three = 3
    case four = 4
    
    func getTitle() -> String {
        switch self {
        case .zero:
            "選擇顏色"
        case .one:
            "混合顏色"
        case .two:
            "發佈顏色"
        case .three:
            "顏色足跡"
        case .four:
            "瀏覽貼文"
        }
    }
}