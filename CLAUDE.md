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
