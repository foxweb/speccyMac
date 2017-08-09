//
//  Z80+core.swift
//  speccyMac
//
//  Created by John Ward on 21/07/2017.
//  Copyright © 2017 John Ward. All rights reserved.
//

import Foundation

extension Z80 {
    
    final func setRelativePC(_ byte: UInt8) {
        pc = byte > 127 ? pc &- (UInt16(256) - UInt16(byte)) : pc &+ UInt16(byte)
    }
    
    final func rst(_ address: UInt16) {
        memory.push(pc &+ 1)
        pc = address
        pc = pc &- 1
    }
    
    final func portOut(_ port: UInt8, byte: UInt8) {
        if port == 0xfe {
            machine?.borderColour = byte & 0x07
            
            if byte & 0x10 > 0 {
                if let clicks = machine?.clickCount {
                    machine!.clickCount = clicks + 1
                }
            }
        }
    }
    
    final func portIn(reg: Register, high: UInt8, low: UInt8) {
        var byte: UInt8 = 0x00
        
        if low == 0xfe {            // keyboard
            byte = 0xbf
            
//            if let keyboard = machine?.keyboard {
//                byte = UInt8(keyboard.first! & 0xff)
//            }
        } else if low == 0x1f {     // kempston
            if let keyboard = machine?.keyboard {
                byte = 0x00
                if keyboard.contains(124) {
                    byte |= 0x01
                }
                if keyboard.contains(123) {
                    byte |= 0x02
                }
                if keyboard.contains(125) {
                    byte |= 0x04
                }
                if keyboard.contains(126) {
                    byte |= 0x08
                }
                if keyboard.contains(49) {
                    byte |= 0x10
                }
            }
        } else if low == 0xff {     // video beam
            if (videoRow < 64) || (videoRow > 255) {
                byte = 0xff
            } else {
                if (ula >= 24) && (ula <= 152) {
                    let rowNum = videoRow - 64
                    let attribAddress = 22528 + ((rowNum >> 3) << 5)
                    let col = UInt16((ula - 24) >> 2)
                    byte = memory.get(attribAddress + col)
                } else {
                    byte = 0xff
                }
            }
        } else {
            byte = 0xff
        }
        
        Z80.f.value = (Z80.f.value & Z80.cBit) | Z80.sz53pvTable[byte]
        reg.value = byte
    }
    
}
