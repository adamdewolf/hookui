all: build
BEPINEX_VERSION = 6

mod-build:
	@echo Building HookUIMod...
	@cd mod && dotnet clean && dotnet restore && dotnet build /p:BepInExVersion=$(BEPINEX_VERSION)

install-ui-deps:
	@echo Installing frontend dependencies...
	@npm ci

ui-bundle: install-ui-deps
	@echo Building HookUI frontend...
	@node bundle_ui.mjs

ui-install: package-win
	cmd /c copy /y "dist\hookui.menu.bundle.js" "C:\Program Files (x86)\Steam\steamapps\common\Cities Skylines II\Cities2_Data\StreamingAssets\~UI~\HookUI\lib"
	cmd /c copy /y "dist\hookui.api.bundle.js" "C:\Program Files (x86)\Steam\steamapps\common\Cities Skylines II\Cities2_Data\StreamingAssets\~UI~\HookUI\lib"
	cmd /c copy /y "dist\hookui.loader.bundle.js" "C:\Program Files (x86)\Steam\steamapps\common\Cities Skylines II\Cities2_Data\StreamingAssets\~UI~\HookUI\lib"

build: ui-bundle mod-build
	@echo Build complete.

package-win: build
	cmd /c copy /y "mod\bin\Debug\netstandard2.1\0Harmony.dll" "dist"
	cmd /c copy /y "mod\bin\Debug\netstandard2.1\HookUIMod.dll" "dist"
	echo Packaged to dist/

package-unix: build
	@cp mod/bin/Debug/netstandard2.1/0Harmony.dll dist
	@cp mod/bin/Debug/netstandard2.1/HookUIMod.dll dist
	@echo Packaged to dist/