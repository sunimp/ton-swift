import BigInt
import Foundation

public enum DNSRenewMessage {
    public static func internalMessage(
        nftAddress: Address,
        dnsLinkAmount: BigUInt,
        stateInit _: StateInit?
    ) throws -> MessageRelaxed {
        let queryId = UInt64(Date().timeIntervalSince1970)
        let data = DNSRenewData(queryId: queryId)
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
