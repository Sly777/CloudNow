func makeOfferSDP() -> String {
    #"""
    v=0
    o=- 7841596221887335000 2 IN IP4 127.0.0.1
    s=CloudNow synthetic WebRTC offer
    t=0 0
    a=group:BUNDLE 0 1
    a=extmap-allow-mixed
    a=msid-semantic: WMS cloudnow-stream
    a=ice-lite
    m=audio 9 UDP/TLS/RTP/SAVPF 111
    c=IN IP4 0.0.0.0
    a=rtcp:9 IN IP4 0.0.0.0
    a=ice-ufrag:cloudaudio
    a=ice-pwd:cloudaudio0123456789abcdef012345
    a=ice-options:trickle
    a=fingerprint:sha-256 54:89:13:38:11:94:11:2D:E9:AA:CC:66:20:B0:25:D1:75:B1:6A:81:20:34:55:9E:02:C6:B4:A7:40:95:EE:01
    a=setup:actpass
    a=mid:0
    a=sendonly
    a=rtcp-mux
    a=rtpmap:111 opus/48000/2
    a=rtcp-fb:111 transport-cc
    a=fmtp:111 minptime=10;useinbandfec=1
    a=ssrc:192837465 cname:cloudnow-audio
    m=video 9 UDP/TLS/RTP/SAVPF 96 97 98 99 100 101 102 103 104 105 106 107
    c=IN IP4 0.0.0.0
    a=rtcp:9 IN IP4 0.0.0.0
    a=ice-ufrag:cloudvideo
    a=ice-pwd:cloudvideo0123456789abcdef012345
    a=ice-options:trickle renomination
    a=fingerprint:sha-256 54:89:13:38:11:94:11:2D:E9:AA:CC:66:20:B0:25:D1:75:B1:6A:81:20:34:55:9E:02:C6:B4:A7:40:95:EE:01
    a=setup:actpass
    a=mid:1
    a=sendonly
    a=rtcp-mux
    a=rtcp-rsize
    a=extmap:1 urn:ietf:params:rtp-hdrext:toffset
    a=extmap:2 http://www.webrtc.org/experiments/rtp-hdrext/abs-send-time
    a=extmap:3 urn:3gpp:video-orientation
    a=extmap:4 http://www.ietf.org/id/draft-holmer-rmcat-transport-wide-cc-extensions-01
    a=extmap:5 http://www.webrtc.org/experiments/rtp-hdrext/playout-delay
    a=extmap:6 http://www.webrtc.org/experiments/rtp-hdrext/video-content-type
    a=extmap:7 http://www.webrtc.org/experiments/rtp-hdrext/video-timing
    a=extmap:8 http://www.webrtc.org/experiments/rtp-hdrext/color-space
    a=extmap:9 urn:ietf:params:rtp-hdrext:sdes:mid
    a=extmap:10 urn:ietf:params:rtp-hdrext:sdes:rtp-stream-id
    a=extmap:11 urn:ietf:params:rtp-hdrext:sdes:repaired-rtp-stream-id
    a=rtpmap:96 H264/90000
    a=rtcp-fb:96 goog-remb
    a=rtcp-fb:96 transport-cc
    a=rtcp-fb:96 ccm fir
    a=rtcp-fb:96 nack
    a=rtcp-fb:96 nack pli
    a=fmtp:96 level-asymmetry-allowed=1;packetization-mode=1;profile-level-id=640033;x-google-start-bitrate=15000;x-google-max-bitrate=45000
    a=rtpmap:97 rtx/90000
    a=fmtp:97 apt=96
    a=rtpmap:98 H265/90000
    a=rtcp-fb:98 goog-remb
    a=rtcp-fb:98 transport-cc
    a=rtcp-fb:98 ccm fir
    a=rtcp-fb:98 nack
    a=rtcp-fb:98 nack pli
    a=fmtp:98 profile-id=1;tier-flag=1;level-id=186;interop-constraints=B00000000000;tx-mode=SRST;profile-space=0;max-lsr=316;max-fps=60;x-google-start-bitrate=18000;x-google-max-bitrate=50000
    a=rtpmap:99 rtx/90000
    a=fmtp:99 apt=98
    a=rtpmap:100 H265/90000
    a=rtcp-fb:100 goog-remb
    a=rtcp-fb:100 transport-cc
    a=rtcp-fb:100 ccm fir
    a=rtcp-fb:100 nack
    a=rtcp-fb:100 nack pli
    a=fmtp:100 profile-id=2;tier-flag=1;level-id=156;interop-constraints=B00000000000;tx-mode=SRST;profile-space=0;max-lsr=316;max-fps=60;color-space=bt2020;x-google-start-bitrate=18000;x-google-max-bitrate=50000
    a=rtpmap:101 rtx/90000
    a=fmtp:101 apt=100
    a=rtpmap:102 AV1/90000
    a=rtcp-fb:102 goog-remb
    a=rtcp-fb:102 transport-cc
    a=rtcp-fb:102 ccm fir
    a=rtcp-fb:102 nack
    a=rtcp-fb:102 nack pli
    a=fmtp:102 profile=0;level-idx=16;tier=0;scalability-mode=L1T2_KEY;x-google-start-bitrate=20000;x-google-max-bitrate=55000
    a=rtpmap:103 rtx/90000
    a=fmtp:103 apt=102
    a=rtpmap:104 VP9/90000
    a=rtcp-fb:104 goog-remb
    a=rtcp-fb:104 transport-cc
    a=rtcp-fb:104 ccm fir
    a=rtcp-fb:104 nack
    a=rtcp-fb:104 nack pli
    a=fmtp:104 profile-id=0;x-google-start-bitrate=12000
    a=rtpmap:105 rtx/90000
    a=fmtp:105 apt=104
    a=rtpmap:106 red/90000
    a=rtpmap:107 ulpfec/90000
    a=ssrc-group:FID 3482736482 1298374655
    a=ssrc:3482736482 cname:cloudnow-video
    a=ssrc:3482736482 msid:cloudnow-stream cloudnow-video-track
    a=ssrc:3482736482 mslabel:cloudnow-stream
    a=ssrc:3482736482 label:cloudnow-video-track
    a=ssrc:1298374655 cname:cloudnow-video
    a=ssrc:1298374655 msid:cloudnow-stream cloudnow-video-track
    a=ssrc:1298374655 mslabel:cloudnow-stream
    a=ssrc:1298374655 label:cloudnow-video-rtx
    a=candidate:842163049 1 udp 1677729535 192.0.2.10 54321 typ srflx raddr 10.0.0.4 rport 54211 generation 0 network-id 1 network-cost 10
    a=candidate:842163050 1 tcp 1518280447 192.0.2.10 9 typ host tcptype active generation 0 network-id 1 network-cost 10
    a=end-of-candidates
    """#
}

/// Shared loop counts for performance tests.
///
/// `EncodedInputPacket.prepare(length:)` zero-fills only indices `0..<length`
/// within its 64-byte capacity. That preparation is intentionally kept inside
/// the measured encoder region because real input-sending call sites pay it.
enum PerfScale {
    static let sdpInnerLoop = 2000
    static let encoderInnerLoop = 50000
}
