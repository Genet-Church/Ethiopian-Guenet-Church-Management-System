#!/bin/sh
# deploy.sh

# 1. Exit immediately if a command exits with a non-zero status.
# This prevents deploying a broken build.
set -e

# 2. Build the Flutter web app for release.
echo "Building Flutter web app with CanvasKit renderer..."

# We use --no-wasm-dry-run to suppress the WebAssembly compatibility warnings,
# as our project intentionally uses packages that rely on JS-interop.
flutter build web --web-renderer canvaskit --release --base-href "/genet-church-live-demo/" --no-tree-shake-icons --no-wasm-dry-run

# 3. Navigate into the build output directory.
cd build/web

# 4. (Optional) Create a CNAME file if you are using a custom domain.
# echo "your.custom.domain.com" > CNAME

# 5. Initialize a new Git repository, add all files, and commit them.
# The commit message includes the current date for tracking.
git init
git add -A
git commit -m "Deploy to GitHub Pages: $(date)"

# 6. Push the build to the `gh-pages` branch of your repository.
# This command forcefully updates the gh-pages branch with the new build.
echo "Deploying to GitHub Pages..."
git push -f git@github.com:HundefraN/genet-church-live-demo.git main:gh-pages

# 7. Clean up by returning to the project root and removing the temporary .git directory.
cd -
rm -rf build/web/.git

echo "✅ Deployment complete!"