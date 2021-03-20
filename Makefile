.PHONY: all clean

all:	pamLibrary \
	windowsHelloAuthComponent \
	windowsHelloCredComponent

pamLibrary:
	cargo build --release

windowsHelloAuthComponent:
	cd contrib/WindowsHelloAuthenticator && \
	dotnet.exe msbuild -property:Configuration=Release -property:RuntimeIdentifiers=win10-x86

windowsHelloCredComponent:
	cd contrib/WindowsHelloKeyCredentialCreator && \
	dotnet.exe msbuild -property:Configuration=Release -property:RuntimeIdentifiers=win10-x86

clean:
	cargo clean
	cd contrib/WindowsHelloAuthenticator && \
	dotnet.exe msbuild -target:Clean
	cd contrib/WindowsHelloKeyCredentialCreator && \
	dotnet.exe msbuild -target:Clean
