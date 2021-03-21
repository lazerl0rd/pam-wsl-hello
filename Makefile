.PHONY: all clean

all:	pamLibrary \
	windowsHelloAuthComponent \
	windowsHelloCredComponent

pamLibrary:
	cargo build --release
ifeq (, $(shell which llvm-strip))
		strip --strip-unneeded target/release/libpam_wsl_hello.so
else
		llvm-strip --strip-unneeded target/release/libpam_wsl_hello.so
endif

windowsHelloAuthComponent:
	cd contrib/WindowsHelloAuthenticator && \
	dotnet.exe msbuild -property:Configuration=Release -property:RuntimeIdentifiers=win10

windowsHelloCredComponent:
	cd contrib/WindowsHelloKeyCredentialCreator && \
	dotnet.exe msbuild -property:Configuration=Release -property:RuntimeIdentifiers=win10

clean:
	cargo clean
	cd contrib/WindowsHelloAuthenticator && \
	dotnet.exe msbuild -target:Clean
	cd contrib/WindowsHelloKeyCredentialCreator && \
	dotnet.exe msbuild -target:Clean
	rm -r out

release: all
	mkdir -p out
	cp -f  target/release/libpam_wsl_hello.so out
	cp -fr contrib/WindowsHelloAuthenticator/bin/Release out/WindowsHelloAuthenticator
	cp -fr contrib/WindowsHelloKeyCredentialCreator/bin/Release out/WindowsHelloKeyCredentialCreator
	cd out && \
	tar -I zstd -cvf pam-wsl-hello.tar.zst *
