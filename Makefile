CPP_API ?= .

all: proxy_wasm_intrinsics.pb.h proxy_wasm_intrinsics_lite.pb.h struct_lite.pb.h ${CPP_API}/libprotobuf.a ${CPP_API}/libprotobuf-lite.a

protobuf: proxy_wasm_intrinsics.pb.h proxy_wasm_intrinsics_lite.pb.h struct_lite.pb.h

proxy_wasm_intrinsics.pb.h: proxy_wasm_intrinsics.proto
	protoc --cpp_out=. proxy_wasm_intrinsics.proto

proxy_wasm_intrinsics_lite.pb.h struct_lite.pb.h: proxy_wasm_intrinsics_lite.proto
	protoc --cpp_out=. -I. proxy_wasm_intrinsics_lite.proto
	protoc --cpp_out=. struct_lite.proto

${CPP_API}/libprotobuf.a ${CPP_API}/libprotobuf-lite.a:
	rm -rf protobuf-wasm \
	&& git clone https://github.com/protocolbuffers/protobuf protobuf-wasm \
	&& cd protobuf-wasm \
	&& git checkout v3.9.1 \
	&& ./autogen.sh \
	&& emconfigure ./configure --disable-shared CXXFLAGS="-O3 -flto" \
	&& emmake make \
	&& cd .. \
	&& cp protobuf-wasm/src/.libs/libprotobuf-lite.a ${CPP_API}/libprotobuf-lite.a \
	&& cp protobuf-wasm/src/.libs/libprotobuf.a ${CPP_API}/libprotobuf.a

clean:
	rm -f proxy_wasm_intrinsics.pb.h proxy_wasm_intrinsics_lite.pb.h struct_lite.pb.h ${CPP_API}/libprotobuf.a ${CPP_API}/libprotobuf-lite.a
