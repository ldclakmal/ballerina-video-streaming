import ballerina/grpc;
import ballerina/io;
import ballerina/test;

@test:Config {}
public function testVideoStreaming() {
    VideoStreamingClient|grpc:Error ep = new("http://localhost:9090");
    if (ep is grpc:Error) {
        test:assertFail("Failed to init gRPC client.");
    } else {
        stream<byte[], grpc:Error>|grpc:Error streamResult = ep->'stream();
        if (streamResult is grpc:Error) {
            test:assertFail("Failed to call video streaming API.");
        } else {
            error? e = streamResult.forEach(function(byte[] b) {
                io:Error? fileWriteBytes = io:fileWriteBytes("video_streaming/resources/copy-video-480p.mp4", b);
                if (fileWriteBytes is error) {
                    test:assertFail("Failed to write video file.");
                }
            });
        }
    }
}
