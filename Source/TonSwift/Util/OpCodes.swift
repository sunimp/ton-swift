//
//  OpCodes.swift
//
//  Created by Sun on 2024/5/7.
//

public enum OpCodes {
    public static var OUT_ACTION_SEND_MSG_TAG: Int32 = 0x0EC3C86D
    public static var SIGNED_EXTERNAL: Int32 = 0x7369676E
    public static var SIGNED_INTERNAL: Int32 = 0x73696E74
    public static var JETTON_TRANSFER: Int32 = 0xF8A7EA5
    public static var NFT_TRANSFER: Int32 = 0x5FCC3D14
    public static var STONFI_SWAP: Int32 = 0x25938561
    public static var CHANGE_DNS_RECORD: Int32 = 0x4EB1F0F9
    public static var LIQUID_TF_DEPOSIT: Int32 = 0x47D54391
    public static var LIQUID_TF_BURN: Int32 = 0x595F07BC
    public static var WHALES_DEPOSIT: Int32 = 2077040623
    public static var WHALES_WITHDRAW: UInt32 = 3665837821
}
