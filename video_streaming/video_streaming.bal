import ballerina/grpc;
import ballerina/io;
import ballerina/log;

public function streamVideo() returns stream<byte[] & readonly, io:Error>|io:Error {
    string videoFilePath = "video_streaming/resources/video-480p.mp4";
    return io:fileReadBlocksAsStream(videoFilePath);
}

listener grpc:Listener ep = new(9090);

@grpc:ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR,
    descMap: getDescriptorMap()
}
service "VideoStreaming" on ep {
    remote function 'stream() returns stream<byte[] & readonly, io:Error|never>|grpc:InternalError {
        log:printInfo("Streaming video file...");
        stream<byte[] & readonly, io:Error>|io:Error videoStream = streamVideo();
        if (videoStream is io:Error) {
            return error grpc:InternalError("Failed to read video file.");
        } else {
            return videoStream;
        }
    }
}
