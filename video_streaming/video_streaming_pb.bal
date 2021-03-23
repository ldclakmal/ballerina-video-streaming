import ballerina/grpc;

public client class VideoStreamingClient {

    *grpc:AbstractClientEndpoint;

    private grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        // initialize client endpoint.
        self.grpcClient = check new(url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR, getDescriptorMap());
    }

    isolated remote function 'stream() returns stream<byte[], grpc:Error>|grpc:Error {
        Empty message = {};
        var payload = check self.grpcClient->executeServerStreaming("VideoStreaming/stream", message);
        [stream<anydata, grpc:Error>, map<string|string[]>][result, _] = payload;
        BytesStream outputStream = new BytesStream(result);
        return new stream<byte[], grpc:Error>(outputStream);
    }

    isolated remote function streamContext() returns ContextBytesStream|grpc:Error {
        Empty message = {};
        var payload = check self.grpcClient->executeServerStreaming("VideoStreaming/stream", message);
        [stream<anydata, grpc:Error>, map<string|string[]>][result, headers] = payload;
        BytesStream outputStream = new BytesStream(result);
        return {content: new stream<byte[], grpc:Error>(outputStream), headers: headers};
    }

}

public class BytesStream {
    private stream<anydata, grpc:Error> anydataStream;

    public isolated function init(stream<anydata, grpc:Error> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {| byte[] value; |}|grpc:Error? {
        var streamValue = self.anydataStream.next();
        if (streamValue is ()) {
            return streamValue;
        } else if (streamValue is grpc:Error) {
            return streamValue;
        } else {
            record {| byte[] value; |} nextRecord = {value: <byte[]>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns grpc:Error? {
        return self.anydataStream.close();
    }
}

public client class VideoStreamingByteCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }
    
    isolated remote function sendBytes(byte[] response) returns grpc:Error? {
        return self.caller->send(response);
    }
    isolated remote function sendContextBytes(ContextBytes response) returns grpc:Error? {
        return self.caller->send(response);
    }
    
    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }
}

public type ContextNil record {|
    map<string|string[]> headers;
|};

public type ContextBytesStream record {|
    stream<byte[]> content;
    map<string|string[]> headers;
|};
public type ContextBytes record {|
    byte[] content;
    map<string|string[]> headers;
|};

public type Empty record {|
    
|};

const string ROOT_DESCRIPTOR = "0A15766964656F5F73747265616D696E672E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F1A1B676F6F676C652F70726F746F6275662F656D7074792E70726F746F32510A0E566964656F53747265616D696E67123F0A0673747265616D12162E676F6F676C652E70726F746F6275662E456D7074791A1B2E676F6F676C652E70726F746F6275662E427974657356616C75653001620670726F746F33";
isolated function getDescriptorMap() returns map<string> {
    return {
        "video_streaming.proto":"0A15766964656F5F73747265616D696E672E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F1A1B676F6F676C652F70726F746F6275662F656D7074792E70726F746F32510A0E566964656F53747265616D696E67123F0A0673747265616D12162E676F6F676C652E70726F746F6275662E456D7074791A1B2E676F6F676C652E70726F746F6275662E427974657356616C75653001620670726F746F33",
        "google/protobuf/wrappers.proto":"0A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F120F676F6F676C652E70726F746F62756622230A0B446F75626C6556616C756512140A0576616C7565180120012801520576616C756522220A0A466C6F617456616C756512140A0576616C7565180120012802520576616C756522220A0A496E74363456616C756512140A0576616C7565180120012803520576616C756522230A0B55496E74363456616C756512140A0576616C7565180120012804520576616C756522220A0A496E74333256616C756512140A0576616C7565180120012805520576616C756522230A0B55496E74333256616C756512140A0576616C756518012001280D520576616C756522210A09426F6F6C56616C756512140A0576616C7565180120012808520576616C756522230A0B537472696E6756616C756512140A0576616C7565180120012809520576616C756522220A0A427974657356616C756512140A0576616C756518012001280C520576616C756542570A13636F6D2E676F6F676C652E70726F746F627566420D577261707065727350726F746F50015A057479706573F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33",
        "google/protobuf/empty.proto":"0A1B676F6F676C652F70726F746F6275662F656D7074792E70726F746F120F676F6F676C652E70726F746F62756622070A05456D70747942540A13636F6D2E676F6F676C652E70726F746F627566420A456D70747950726F746F50015A057479706573F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33"
        
    };
}
