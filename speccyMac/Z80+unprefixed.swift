//
//  Z80+unprefixed.swift
//  speccyMac
//
//  Created by John Ward on 21/07/2017.
//  Copyright © 2017 John Ward. All rights reserved.
//

import Foundation

extension Z80 {
    
    final func unprefixed(opcode: UInt8, first: UInt8, second: UInt8) throws {
        
        let instruction = unprefixedOps[opcode]
        var normalFlow = true
        let word16 = (UInt16(second) << 8) | UInt16(first)
        
        switch opcode {
            
        case 0x00:  // nop
            break
            
        case 0x01:  // ld bc, nnnn
            bc.value = word16
            
        case 0x02:  // ld (bc), a
            memory.set(bc.value, byte: a.value)
            
        case 0x03:  // inc bc
            bc.inc()
            
        case 0x04:  // inc b
            b.inc()
            
        case 0x05:  // dec b
            b.dec()
            
        case 0x06:  // ld b, n
            b.value = first
            
        case 0x07:  // rlca
            a.rlca()
            
        case 0x08:  // ex af, af'
            let temp = af.value
            af.value = exaf
            exaf = temp
            
        case 0x09:  // add hl, bc
            hl.add(bc.value)
            
        case 0x0a:  // ld a, (bc)
            a.value = memory.get(bc)
            
        case 0x0b:  // dec bc
            bc.dec()
            
        case 0x0c:  // inc c
            c.inc()
            
        case 0x0d:  // dec c
            c.dec()
            
        case 0x0e:  // ld c, n
            c.value = first
            
        case 0x0f:  // rrca
            a.rrca()
            
        case 0x10:  // djnz nn
            b.value = b.value &- 1
            if b.value > 0 {
                setRelativePC(first)
            } else {
                normalFlow = false
            }
            
        case 0x11:  // ld de, nnnn
            de.value = word16
            
        case 0x12:  // ld (de), a
            memory.set(de.value, byte: a.value)
            
        case 0x13:  // inc de
            de.inc()
            
        case 0x14:  // inc d
            d.inc()
            
        case 0x15:  // dec d
            d.dec()
            
        case 0x16:  // ld d, n
            d.value = first
            
        case 0x17:  // rla
            a.rla()
            
        case 0x18:  // jr d
            setRelativePC(first)
            
        case 0x19:  // add hl, de
            hl.add(de.value)
            
        case 0x1a:  // ld a, (de)
            a.value = memory.get(de)
            
        case 0x1b:  // dec de
            de.dec()
            
        case 0x1c:  // inc e
            e.inc()
            
        case 0x1d:  // dec e
            e.dec()
            
        case 0x1e:  // ld e, n
            e.value = first
            
        case 0x1f:  // rra
            a.rra()
            
        case 0x20:  // jr nz, nn
            if Z80.f.value & Z80.zBit > 0 {
                normalFlow = false
            } else {
                setRelativePC(first)
            }
            
        case 0x21:  // ld hl, nnnn
            hl.value = word16
            
        case 0x22:  // ld (nnnn), hl
            memory.set(word16, regPair: hl)
            
        case 0x23:  // inc hl
            hl.inc()
            
        case 0x24:  // inc h
            h.inc()
            
        case 0x26:  // ld h, n
            h.value = first
            
        case 0x28:  // jr z, nn
            if Z80.f.value & Z80.zBit > 0 {
                setRelativePC(first)
            } else {
                normalFlow = false
            }
            
        case 0x29:  // add hl, hl
            hl.add(hl.value)
            
        case 0x2a:  // ld hl, (nnnn)
            l.value = memory.get(word16)
            h.value = memory.get(word16 &+ 1)
            
        case 0x2b:  // dec hl
            hl.dec()
            
        case 0x2c:  // inc l
            l.inc()
            
        case 0x2d:  // dec l
            l.dec()
            
        case 0x2e:  // ld l, n
            l.value = first
            
        case 0x2f:  // cpl
            a.cpl()
            
        case 0x30:  // jr nc, nn
            if Z80.f.value & Z80.cBit > 0 {
                normalFlow = false
            } else {
                setRelativePC(first)
            }
            
        case 0x31:  // ld sp, nn
            Z80.sp = word16
            
        case 0x32:  // ld (nnnn), a
            memory.set(word16, reg: a)
            
        case 0x34:  // inc (hl)
            memory.inc(hl.value)
            
        case 0x35:  // dec (hl)
            memory.dec(hl.value)
            
        case 0x36:  // ld (hl), n
            memory.set(hl.value, byte: first)
            
        case 0x37:  // scf
            Z80.f.value &= Z80.zBit | Z80.sBit | Z80.pvBit
            Z80.f.value |= (a.value & (Z80.threeBit | Z80.fiveBit))
            Z80.f.value |= Z80.cBit
            
        case 0x38:  // jr c, nn
            if Z80.f.value & Z80.cBit > 0 {
                setRelativePC(first)
            } else {
                normalFlow = false
            }
            
        case 0x3a:  // ld a, (nn)
            a.value = memory.get(word16)
            
        case 0x3c:  // inc a
            a.inc()
            
        case 0x3d:  // dec a
            a.dec()
            
        case 0x3e:  // ld a, n
            a.value = first
            
        case 0x3f:  // ccf
            Z80.f.value = (Z80.f.value & (Z80.pvBit | Z80.zBit | Z80.sBit)) | ((Z80.f.value & Z80.cBit) > 0 ? Z80.hBit : Z80.cBit) | (a.value & (Z80.threeBit | Z80.fiveBit))
            
        case 0x40:  // ld b, b
            break
            
        case 0x41:  // ld b, c
            b.value = c.value
            
        case 0x42:  // ld b, d
            b.value = d.value
            
        case 0x44:  // ld b, h
            b.value = h.value
            
        case 0x45:  // ld b, l
            b.value = l.value
            
        case 0x46:  // ld b, (hl)
            b.value = memory.get(hl)
            
        case 0x47:  // ld b, a
            b.value = a.value
            
        case 0x4a:  // ld c, d
            c.value = d.value
            
        case 0x4b:  // ld c, e
            c.value = e.value
            
        case 0x4c:  // ld c, h
            c.value = h.value
            
        case 0x4d:  // ld c, l
            c.value = l.value
            
        case 0x4e:  // ld c, (hl)
            c.value = memory.get(hl)
            
        case 0x4f:  // ld c, a
            c.value = a.value
            
        case 0x50:  // ld d, b
            d.value = b.value
            
        case 0x53:  // ld d, e
            d.value = e.value
            
        case 0x54:  // ld d, h
            d.value = h.value
            
        case 0x56:  // ld d, (hl)
            d.value = memory.get(hl)
            
        case 0x57:  // ld d, a
            d.value = a.value
            
        case 0x58:  // ld e, b
            e.value = b.value
            
        case 0x59:  // ld e, c
            e.value = c.value
            
        case 0x5c:  // ld e, h
            e.value = h.value
            
        case 0x5d:  // ld e, l
            e.value = l.value
            
        case 0x5e:  // ld e, (hl)
            e.value = memory.get(hl)
            
        case 0x5f:  // ld e, a
            e.value = a.value
            
        case 0x61:  // ld h, c
            h.value = c.value
            
        case 0x62:  // ld h, d
            h.value = d.value
            
        case 0x63:  // ld h, e
            h.value = e.value
            
        case 0x66:  // ld h, (hl)
            h.value = memory.get(hl)
            
        case 0x67:  // ld h, a
            h.value = a.value
            
        case 0x68:  // ld l, b
            l.value = b.value
            
        case 0x6b:  // ld l, e
            l.value = e.value
            
        case 0x6f:  // ld l, a
            l.value = a.value
            
        case 0x71:  // ld (hl), c
            memory.set(hl.value, byte: c.value)
            
        case 0x72:  // ld (hl), d
            memory.set(hl.value, byte: d.value)
            
        case 0x73:  // ld (hl), e
            memory.set(hl.value, byte: e.value)
            
        case 0x75:  // ld (hl), a
            memory.set(hl.value, byte: l.value)
            
        case 0x76:  // halt
            halted = true
            pc = pc &- 1
            
        case 0x77:  // ld (hl), a
            memory.set(hl.value, byte: a.value)
            
        case 0x78:  // ld a, b
            a.value = b.value
            
        case 0x79:  // ld a, c
            a.value = c.value
            
        case 0x7a:  // ld a, d
            a.value = d.value
            
        case 0x7b:  // ld a, e
            a.value = e.value
            
        case 0x7c:  // ld a, h
            a.value = h.value
            
        case 0x7d:  // ld a, l
            a.value = l.value
            
        case 0x7e:  // ld a, (hl)
            a.value = memory.get(hl)
            
        case 0x80:  // add a, b
            a.add(b.value)
            
        case 0x81:  // add a, c
            a.add(c.value)
            
        case 0x84:  // add a, h
            a.add(h.value)
            
        case 0x86:  // add a, (hl)
            a.add(memory.get(hl))
            
        case 0x87:  // add a, a
            a.add(a.value)
            
        case 0x90:  // sub b
            a.sub(b.value)
            
        case 0x91:  // sub c
            a.sub(c.value)
            
        case 0xa3:  // and e
            a.and(e)
            
        case 0xa6:  // and (hl)
            a.and(memory.get(hl))
            
        case 0xa7:  // and a
            a.and(a)
            
        case 0xaa:  // xor d
            a.xor(d)
            
        case 0xac:  // xor h
            a.xor(h)
            
        case 0xad:  // xor l
            a.xor(l)
            
        case 0xae:  // xor (hl)
            a.xor(memory.get(hl))
            
        case 0xaf:  // xor a
            a.xor(a)
            
        case 0xb1:  // or c
            a.or(c)
            
        case 0xb3:  // or e
            a.or(e)
            
        case 0xb5:  // or l
            a.or(l)
            
        case 0xb6:  // or (hl)
            a.or(memory.get(hl))
            
        case 0xb7:  // or a
            a.or(a)
            
        case 0xb8:  // cp b
            a.cp(b)
            
        case 0xb9:  // cp c
            a.cp(c)
            
        case 0xba:  // cp d
            a.cp(d)
            
        case 0xbc:  // cp h
            a.cp(h)
            
        case 0xbd:  // cp l
            a.cp(l)
            
        case 0xbe:  // cp (hl)
            a.cp(memory.get(hl))
            
        case 0xc0:  // ret nz
            if Z80.f.value & Z80.zBit > 0 {
                normalFlow = false
            } else {
                pc = memory.pop()
                pc = pc &- 1
            }
            
        case 0xc1:  // pop bc
            bc.value = memory.pop()
            
        case 0xc2:  // jp nz, nnnn
            if Z80.f.value & Z80.zBit > 0 {
                normalFlow = false
            } else {
                pc = word16
                pc = pc &- 3
            }
            
        case 0xc3:  // jp nnnn
            pc = word16
            pc = pc &- 3
            
        case 0xc5:  // push bc
            memory.push(bc)
            
        case 0xc6:  // add a, n
            a.add(first)
            
        case 0xc8:  // ret z
            if Z80.f.value & Z80.zBit > 0 {
                pc = memory.pop()
                pc = pc &- 1
            } else {
                normalFlow = false
            }
            
        case 0xc9:  // ret
            pc = memory.pop()
            pc = pc &- 1
            
        case 0xca:  // jp z, nn
            if Z80.f.value & Z80.zBit > 0 {
                pc = word16
                pc = pc &- 3
            } else {
                normalFlow = false
            }
            
        case 0xcc:  // call z, nn
            if Z80.f.value & Z80.zBit > 0 {
                memory.push(pc &+ 3)
                pc = word16
                pc = pc &- 3
            } else {
                normalFlow = false
            }
            
        case 0xcd:  // call nnnn
            memory.push(pc &+ 3)
            pc = word16
            pc = pc &- 3
            
        case 0xd0:  // ret nc
            if Z80.f.value & Z80.cBit > 0 {
                normalFlow = false
            } else {
                pc = memory.pop()
                pc = pc &- 1
            }
            
        case 0xd1:  // pop de
            de.value = memory.pop()
            
        case 0xd2:  // jp nc, nn
            if Z80.f.value & Z80.cBit > 0 {
                normalFlow = false
            } else {
                pc = word16
                pc = pc &- 3
            }
            
        case 0xd3:  // out (n), a
            portOut(first, byte:a.value)
            
        case 0xd4:  // call nc, nn
            if Z80.f.value & Z80.cBit > 0 {
                normalFlow = false
            } else {
                memory.push(pc &+ 3)
                pc = word16
                pc = pc &- 3
            }
            
        case 0xd5:  // push de
            memory.push(de)
            
        case 0xd6:  // sub n
            a.sub(first)
            
        case 0xd9:  // exx
            var temp = bc.value
            bc.value = exbc
            exbc = temp
            
            temp = de.value
            de.value = exde
            exde = temp
            
            temp = hl.value
            hl.value = exhl
            exhl = temp
            
        case 0xda:  // jp c, nn
            if Z80.f.value & Z80.cBit > 0 {
                pc = word16
                pc = pc &- 3
            } else {
                normalFlow = false;
            }
            
        case 0xdb:
            portIn(reg: a, high: a.value, low: first)
            
        case 0xdf:  // rst 18
            rst(0x0018)
            
        case 0xe1:  // pop hl
            hl.value = memory.pop()
            
        case 0xe5:  // push hl
            memory.push(hl)
            
        case 0xe6:  // and n
            a.and(first)
            
        case 0xe9:  // jp (hl)
            pc = hl.value
            pc = pc &- 1
            
        case 0xeb:  // ex de, hl
            let temp = de.value
            de.value = hl.value
            hl.value = temp
            
        case 0xee:  // xor n
            a.xor(first)
            
        case 0xf1:  // pop af
            af.value = memory.pop()
            
        case 0xf3:  // di
            interrupts = false
            iff1 = 0
            iff2 = 2
            
        case 0xf5:  // push af
            memory.push(af)
            
        case 0xf6:  // or n
            a.or(first)
            
        case 0xf8:  // ret m
            if Z80.f.value & Z80.sBit > 0 {
                pc = memory.pop()
                pc = pc &- 1
            } else {
                normalFlow = false
            }
            
        case 0xf9:  // ld sp, hl
            Z80.sp = hl.value
            
        case 0xfb:  // ei
            interrupts = true
            iff1 = 1
            iff2 = 1
            
        case 0xfe:  // cp n
            a.cp(first)
            
        case 0xff:  // rst 38
            rst(0x0038)
            
        default:
            throw NSError(domain: "z80 unprefixed", code: 1, userInfo: ["opcode" : String(opcode, radix: 16, uppercase: true), "instruction" : instruction.opCode, "pc" : pc])
        }
        
//        print("\(pc) : \(instruction.opCode)")        
        
        pc = pc &+ instruction.length
        
        incCounters(normalFlow ? instruction.tStates : instruction.altTStates)        
        r.inc()
    }
}
