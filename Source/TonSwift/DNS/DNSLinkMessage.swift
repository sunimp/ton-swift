import BigInt
import Foundation

public enum DNSLinkMessage {
    public static func internalMessage(
        nftAddress: Address,
        linkAddress: Address?,
        dnsLinkAmount: BigUInt,
        stateInit _: StateInit?
    ) throws -> MessageRelaxed {
        let queryId = UInt64(Date().timeIntervalSince1970)
        let data = DNSLinkData(
            queryId: queryId,
            linkAddress: linkAddress
        )
        return MessageRelaxed.internal(
            to: nftAddress,
            value: dnsLinkAmount,
            bounce: true,
            body: try Builder().store(
                data
            ).endCell()
        )
    }
}
