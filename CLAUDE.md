# CLAUDE.md

## Project overview
- Repository: `aasyrafaidi-hue/Hardirku`
- The project source is packaged in `HadirKu-LejarModen.zip` and contains an Android application under `HadirKu-LejarModen/HadirKu`.
- The application is Java/Kotlin compatible, Gradle-based Android software in this repository.
- Preserve existing behavior, localization, UI layout, and database/engine logic unless the task explicitly requests a change.

## Repository setup
```bash
# Extract once at the repository root
rm -rf project
mkdir project
unzip -q "HadirKu-LejarModen.zip" -d project

ZIP=project
DIR=$(dirname "$(find "$ZIP" -name settings.gradle.kts | head -n 1)")
cd "$DIR"
```

Using JDK 17:
```bash
export JAVA_HOME=<path-to-jdk-17>
./gradlew testDebugUnitTest --stacktrace
./gradlew assembleRelease --stacktrace
```

On Windows, use `gradlew.bat` instead of `./gradlew`.

## Working guidelines
- Read the relevant source and tests before modifying code.
- Keep changes focused; do not reformat unrelated files or archive contents.
- Do not commit generated folders such as `.gradle/`, `build/`, or local IDE files.
- Prefer Java or Kotlin style already present in the file and package being edited.
- Add or update unit tests for changed engine, data, or calculation logic.
- Run the narrowest relevant test first, then `testDebugUnitTest` when feasible.
- Never expose or commit secrets, API keys, signing keys, keystores, or private device data.

## Validation
- Unit test reports are generated under `app/build/reports/tests/`.
- APK output is generated under `app/build/outputs/apk/`.
- Report failures with the failing test name and concise stack trace.

## DEV vs production
- **Production** = app "Duitku" (`com.asyraf.hadirku`), built from `main` with `assembleRelease`; GitHub release `v1.0.N` (`DuitkuIsteri-v1.0.N.apk`). This is the owner's real data — only merge to `main` after the owner approves a DEV build.
- **DEV** = app "Duitku DEV" (`com.asyraf.hadirku.dev`, version `2.0.N-dev`, grey-blue icon, `BuildConfig.IS_DEV = true`), built from `dev` / `dev-*` / `enjin-*` with `assembleDev` (same R8 settings as release). Installs side by side with production; its data, backups (`duitku-DEV-salinan-*.json`) and Firebase household are separate.
- Normal flow: work on `dev` → CI publishes pre-release `dev-v2.0.N` (`DuitkuDEV-v2.0.N.apk`, never "latest") → owner tests → merge `dev` into `main` → production release.
- Firebase: `google-services.json` has a client for `com.asyraf.hadirku.dev` copied from the production client so builds work; registering the `.dev` app in Firebase Console and replacing the file is the clean long-term setup.
